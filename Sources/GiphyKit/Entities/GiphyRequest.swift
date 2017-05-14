import Foundation

public enum Rating: String {
    case y
    case g
    case pg
    case pg13 = "pg-13"
    case r
}

public enum Format: String {
    case json
    case html
}

public protocol GiphyRequest {
    var path: String { get }
    var params: [String: String?] { get }
    var method: String { get }
    var format: Format? { get }
    var imageTypes: [ImageType] { get }
}

// MARK: Search
//q - search query term or phrase
//limit - (optional) number of results to return, maximum 100. Default 25.
//offset - (optional) results offset, defaults to 0.
//rating - (optional) limit results to those rated (y,g, pg, pg-13 or r).
//lang - (optional) specify default country for regional content; format 
// is 2-letter ISO 639-1 country code. See list of supported languages here
//fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test)
public struct SearchRequest: GiphyRequest {
    public let path: String = "search"
    public let method: String = "GET"
    public let query: String
    public let imageTypes: [ImageType]
    public let limit: Int?
    public let offset: Int?
    public let lang: String?
    public let rating: Rating?
    public let format: Format?
    public var params: [String : String?] {
        return ["q": query,
                "limit": limit != nil ? String(describing: limit) : nil,
                "offset": offset != nil ? String(describing: offset) : nil,
                "lang": lang,
                "rating": rating.map { $0.rawValue },
                "fmt": format.map { $0.rawValue }]
    }

    init(query: String,
         limit: Int? = nil,
         offset: Int? = nil,
         lang: String? = nil,
         rating: Rating? = nil,
         format: Format? = nil,
         imageTypes: [ImageType] = [.original, .original_still]) {
        self.query = query
        self.limit = limit
        self.offset = offset
        self.lang = lang
        self.rating = rating
        self.format = format
        self.imageTypes = imageTypes
    }
}

// MARK: Trending
//limit (optional) limits the number of results returned. By default returns 25 results.
//rating - limit results to those rated (y,g, pg, pg-13 or r).
//fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test)
public struct TrendingRequest: GiphyRequest {
    public let path: String = "trending"
    public let method: String = "GET"
    public let rating: Rating
    public let imageTypes: [ImageType]
    public let limit: Int?
    public let format: Format?
    public var params: [String : String?] {
        return ["limit": limit != nil ? String(describing: limit) : nil,
                "rating": rating.rawValue,
                "fmt": format.map { $0.rawValue }]
    }

    init(rating: Rating,
         limit: Int? = nil,
         format: Format? = nil,
         imageTypes: [ImageType] = [.original, .original_still]) {
        self.limit = limit
        self.rating = rating
        self.format = format
        self.imageTypes = imageTypes
    }
}

// MARK: Translate
//s - term or phrase to translate into a GIF
//rating - (optional) limit results to those rated (y,g, pg, pg-13 or r).
//lang - (optional) specify default country for regional content; format 
// is 2-letter ISO 639-1 country code. See list of supported langauges here
//fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test)
public struct TranslateRequest: GiphyRequest {
    public let path: String = "translate"
    public let method: String = "GET"
    public let term: String
    public let imageTypes: [ImageType]
    public let rating: Rating?
    public let lang: String?
    public let format: Format?
    public var params: [String : String?] {
        return ["s": term,
                "rating": rating.map { $0.rawValue },
                "lang": lang,
                "fmt": format.map { $0.rawValue }]
    }

    init(term: String, rating: Rating? = nil,
         lang: String? = nil,
         format: Format? = nil,
         imageTypes: [ImageType] = [.original, .original_still]) {
        self.term = term
        self.rating = rating
        self.lang = lang
        self.format = format
        self.imageTypes = imageTypes
    }
}

// MARK: Random
//tag - the GIF tag to limit randomness by
//rating - limit results to those rated (y,g, pg, pg-13 or r).
//fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test)
public struct RandomRequest: GiphyRequest {
    public let path: String = "random"
    public let method: String = "GET"
    public let tag: String
    public let imageTypes: [ImageType]
    public let rating: Rating?
    public let format: Format?
    public var params: [String : String?] {
        return ["tag": tag,
                "rating": rating.map { $0.rawValue },
                "fmt": format.map { $0.rawValue }]
    }

    init(tag: String,
         rating: Rating? = nil,
         format: Format? = nil,
         imageTypes: [ImageType] = [.original, .original_still]) {
        self.tag = tag
        self.rating = rating
        self.format = format
        self.imageTypes = imageTypes
    }
}
