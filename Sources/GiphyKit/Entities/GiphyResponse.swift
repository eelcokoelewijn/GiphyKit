import Foundation

//"data": [
//{
//    type: "gif",
//    id: "FiGiRei2ICzzG",
//    slug: "funny-cat-FiGiRei2ICzzG",
//    url: "http://giphy.com/gifs/funny-cat-FiGiRei2ICzzG",
//    bitly_gif_url: "http://gph.is/1fIdLOl",
//    bitly_url: "http://gph.is/1fIdLOl",
//    embed_url: "http://giphy.com/embed/FiGiRei2ICzzG",
//    username: "",
//    source: "http://tumblr.com",
//    rating: "g",
//    content_url: "",
//    source_tld: "tumblr.com",
//    source_post_url: "http://tumblr.com",
//    import_datetime: "2014-01-18 09:14:20",
//    trending_datetime: "1970-01-01 00:00:00",
//    images: {
//        .....
//        original: {
//            url: "http://media2.giphy.com/media/FiGiRei2ICzzG/giphy.gif",
//            width: "500",
//            height: "176",
//            size: "426811",
//            frames: "22",
//            mp4: "http://media2.giphy.com/media/FiGiRei2ICzzG/giphy.mp4",
//            mp4_size: "51432",
//            webp: "http://media2.giphy.com/media/FiGiRei2ICzzG/giphy.webp",
//            webp_size: "291616"
//        },
//        original_still: {
//            url: "http://media2.giphy.com/media/FiGiRei2ICzzG/giphy_s.gif",
//            width: "500",
//            height: "176"
//        }
//    }
//},
//...
//],
//"meta": {
//    "status": 200,
//    "msg": "OK"
//},
//"pagination": {
//    "total_count": 1947,
//    "count": 25,
//    "offset": 0
//}

public struct GiphyResponse {
    public let meta: Meta
    public let pagination: Pagination?
    public let giphies: [Giphy]

    public init(meta: Meta, pagination: Pagination? = nil, giphies: [Giphy] = []) {
        self.meta = meta
        self.pagination = pagination
        self.giphies = giphies
    }
}

extension GiphyResponse {
    init?(json: [String: Any]) {
        guard let data = json["data"] as? [[String: Any]] else { return nil }
        guard let metaJSON = json["meta"] as? [String: Any],
            let meta = Meta(json: metaJSON) else { return nil }

        if let pagination = json["pagination"] as? [String: Any] {
            self.pagination = Pagination(json: pagination)
        } else {
            self.pagination = nil
        }

        self.meta = meta
        self.giphies = data.flatMap({ item in
            Giphy(json: item)
        })
    }
}
