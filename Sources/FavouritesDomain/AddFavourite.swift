public protocol FavouritesStore: Sendable {
    func save(_ favourites: Favourites) async throws
}

public struct AddFavourite: Sendable {
    private let store: any FavouritesStore

    public init(store: any FavouritesStore) {
        self.store = store
    }

    public func callAsFunction(_ id: ItemID, to favourites: Favourites) async throws -> Favourites {
        var updated = favourites
        try updated.add(id)
        try await store.save(updated)
        return updated
    }
}
