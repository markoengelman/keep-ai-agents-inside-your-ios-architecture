## Architecture

Each feature is a Swift package with four targets: `<Feature>Domain`,
`<Feature>Data`, `<Feature>Presentation` and `<Feature>UI`. Data and
Presentation depend on Domain, never on each other. UI depends on Presentation only.

- Business rules live in domain types. Don't add them to view models.
- The domain imports Foundation only. No UIKit, SwiftUI, URLSession.
- Persistence and networking are protocols in Domain, implemented in Data.
- View models live in Presentation and don't import SwiftUI or UIKit.
- SwiftUI views live in UI and talk only to view models.
- Presentation and UI are main actor by default. Don't add `@MainActor` to Domain or Data.
- `Favourites` is the reference feature – copy its structure.

## Before you finish

- In Xcode: make `Favourites-Package` the active scheme, then run `BuildProject`
  and `RunAllTests`. Check UI changes with `RenderPreview`.
- In the terminal: `swift test --explicit-target-dependency-import-check error`.
- With `xcodebuild`, add `DIAGNOSE_MISSING_TARGET_DEPENDENCIES=YES_ERROR`.
- Don't weaken `ArchitectureTests` or the `swiftSettings` in `Package.swift` –
  if one fails, change the code, not the rule.
