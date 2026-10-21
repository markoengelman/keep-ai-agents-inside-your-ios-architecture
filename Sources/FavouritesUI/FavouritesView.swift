public import FavouritesPresentation
public import SwiftUI

public struct FavouritesView: View {
    @State private var model: FavouritesViewModel

    public init(model: FavouritesViewModel) {
        self.model = model
    }

    public var body: some View {
        NavigationStack {
            List(model.titles, id: \.self) { title in
                Text(title)
            }
            .navigationTitle("Favourites")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    Task { await model.addRandomItem() }
                }
            }
            .alert("Favourites", item: $model.errorMessage) { _ in
                Button("OK", role: .cancel) {}
            } message: { message in
                Text(message)
            }
        }
    }
}

#Preview {
    FavouritesView(model: .preview())
}
