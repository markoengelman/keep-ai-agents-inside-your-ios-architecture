import FavouritesDomain

extension FavouritesViewModel {
    /* Saves nowhere, so a preview works without a network */
    public static func preview() -> FavouritesViewModel {
        FavouritesViewModel(addFavourite: AddFavourite(store: PreviewStore()))
    }
}

private struct PreviewStore: FavouritesStore {
    func save(_ favourites: Favourites) async throws {}
}
