# Keep AI agents inside your iOS architecture

The sample project for the article
[Keep AI agents inside your iOS architecture](https://markoengelman.com/keep-ai-agents-inside-your-ios-architecture/).

A small favourites feature, split into four layers, where the architecture rules live in the build and in
tests instead of in a prompt. A coding agent that breaks one of these rules gets a failing build or a failing
test that names the file, rather than a sentence in `AGENTS.md` it may have forgotten.

## Requirements

- Xcode 27 (Swift 6.4)
- iOS 27 or macOS 27 to run the tests

The package uses `swift-tools-version: 6.4` and targets iOS 27 and macOS 27, because the view uses
`alert(_:item:)`, new in iOS 27. The compiler settings themselves work from tools version 6.2.

## Structure

```
Sources/
├── FavouritesDomain/        Business rules and the interfaces they need
│   ├── Favourites.swift         The favourites list and its rules: no duplicates, at most 20
│   └── AddFavourite.swift       The use case, and the FavouritesStore protocol
├── FavouritesData/          Networking behind the domain's interfaces
│   └── RemoteFavouritesStore.swift
├── FavouritesPresentation/  View models: what to show, not how it looks
│   ├── FavouritesViewModel.swift
│   └── FavouritesViewModel+Preview.swift
└── FavouritesUI/            SwiftUI views and nothing else
    └── FavouritesView.swift
Tests/
├── FavouritesDomainTests/   The domain rules, as a specification
└── ArchitectureTests/       Which layer may import what
```

The dependencies point one way:

```
FavouritesUI ──▶ FavouritesPresentation ──▶ FavouritesDomain ◀── FavouritesData
```

Data and Presentation never depend on each other, and UI depends on Presentation only. The view model
exposes ready-to-show `titles` and keeps the domain model private, so a view never sees a domain type.

## Try breaking it

These are the experiments behind the article. Each one is a change an agent could plausibly make.

### Leak SwiftUI into the domain

Add `Sources/FavouritesDomain/Tint.swift`:

```swift
import SwiftUI

extension Favourites {
    public var tint: Color { ids.isEmpty ? .gray : .yellow }
}
```

The build fails with `property cannot be declared public because its type uses an internal type`. Change the
import to `public import SwiftUI` and the build passes, but `ArchitectureTests` fails with
`FavouritesDomain/Tint.swift imports ["SwiftUI"]`.

### Use Data from Presentation

Add `import FavouritesData` to any file in `FavouritesPresentation` and use `RemoteFavouritesStore`.

- A clean build fails with `unable to resolve module dependency: 'FavouritesData'`.
- Once `FavouritesData` has been built, a plain `swift build` or Xcode build only warns that
  `'FavouritesPresentation' is missing a dependency on 'FavouritesData'`, and succeeds.
- `swift build --explicit-target-dependency-import-check error`, or `xcodebuild` with
  `DIAGNOSE_MISSING_TARGET_DEPENDENCIES=YES_ERROR`, fails, but only on the build that recompiles the file.
  Run it again without changes and it passes.
- `ArchitectureTests` fails either way.

### Use the domain from the UI

Add `import FavouritesDomain` to a file in `FavouritesUI`. The domain is a transitive dependency through
Presentation, so the build succeeds without a warning – clean, incremental and with the flag.
`ArchitectureTests` is the only thing that fails.

## What this doesn't catch

- **Types inside an allowed module.** `ArchitectureTests` reads imports, and `URLSession` is part of
  Foundation. A domain that calls it directly passes.
- **Silenced concurrency errors.** `@unchecked Sendable` and `nonisolated(unsafe)` compile without a warning,
  even with warnings as errors. Review them, or add a lint rule.
- **Loosened access control.** Removing `private(set)` from `Favourites.ids` breaks no test. Treat it as a
  review flag.
- **Stale incremental builds.** The dependency check runs only when a file is recompiled, so the flagged build
  passes the second time it runs. CI should run a clean build.
