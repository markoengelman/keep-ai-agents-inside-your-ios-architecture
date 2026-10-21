public import Foundation

public typealias ItemID = UUID

public struct Favourites: Equatable, Sendable {
    public static let limit = 20

    public enum Error: Swift.Error, Equatable {
        case alreadyAdded
        case limitReached
    }

    public private(set) var ids: [ItemID] = []

    public init() {}

    public mutating func add(_ id: ItemID) throws {
        guard !ids.contains(id) else { throw Error.alreadyAdded }
        guard ids.count < Self.limit else { throw Error.limitReached }
        ids.append(id)
    }
}
