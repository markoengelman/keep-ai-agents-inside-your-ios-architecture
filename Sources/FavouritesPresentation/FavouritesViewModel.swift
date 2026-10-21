public import FavouritesDomain
public import Observation
import Foundation

@Observable
public final class FavouritesViewModel {
    public var titles: [String] {
        favourites.ids.map(\.uuidString)
    }
    public var errorMessage: String?

    private var favourites = Favourites()
    private let addFavourite: AddFavourite

    public init(addFavourite: AddFavourite) {
        self.addFavourite = addFavourite
    }

    public func addRandomItem() async {
        do {
            favourites = try await addFavourite(UUID(), to: favourites)
        } catch {
            errorMessage = "Couldn’t add this item to your favourites."
        }
    }
}
