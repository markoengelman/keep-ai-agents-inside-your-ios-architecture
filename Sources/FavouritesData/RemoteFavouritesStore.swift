public import FavouritesDomain
public import Foundation

public struct RemoteFavouritesStore: FavouritesStore {
    private let url: URL
    private let session: URLSession

    public init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    public func save(_ favourites: Favourites) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(favourites.ids)
        _ = try await session.data(for: request)
    }
}
