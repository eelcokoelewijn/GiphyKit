import Foundation

//pagination: {
//    count: 25,
//    offset: 0
//    total_count: 222 //Search
//},

public struct Pagination {
    public let count: Int
    public let offset: Int
    public let totalCount: Int?
}

extension Pagination {
    public init?(json: [String: Any]) {
        guard let count = json["count"] as? Int else { return nil }
        guard let offset = json["offset"] as? Int else { return nil }
        if let totalCount = json["total_count"] as? Int {
            self.totalCount = totalCount
        } else {
            totalCount = nil
        }
        self.count = count
        self.offset = offset
    }
}

extension Pagination: Equatable {
    public static func == (lhs: Pagination, rhs: Pagination) -> Bool {
            return lhs.count == rhs.count &&
                lhs.offset == rhs.offset &&
                lhs.totalCount == rhs.totalCount
    }
}
