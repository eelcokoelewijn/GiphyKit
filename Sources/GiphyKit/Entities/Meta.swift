import Foundation

//meta: {
//    status: 200,
//    msg: "OK"
//}
public struct Meta {
    public let status: Int
    public let message: String
}

extension Meta {
    public init?(json: [String: Any]) {
        guard let status = json["status"] as? Int else { return nil }
        guard let msg = json["msg"] as? String else { return nil }

        self.status = status
        self.message = msg
    }
}

extension Meta: Equatable {
    public static func == (lhs: Meta, rhs: Meta) -> Bool {
            return lhs.status == rhs.status &&
                lhs.message == rhs.message
    }
}
