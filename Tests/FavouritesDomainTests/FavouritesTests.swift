import FavouritesDomain
import Foundation
import Testing

struct FavouritesTests {
    @Test func rejectsTheSameItemTwice() throws {
        var favourites = Favourites()
        let id = ItemID()
        try favourites.add(id)

        #expect(throws: Favourites.Error.alreadyAdded) { try favourites.add(id) }
    }

    @Test func rejectsItemsPastTheLimit() throws {
        var favourites = Favourites()
        for _ in 0..<20 {
            try favourites.add(ItemID())
        }

        #expect(throws: Favourites.Error.limitReached) { try favourites.add(ItemID()) }
    }
}
