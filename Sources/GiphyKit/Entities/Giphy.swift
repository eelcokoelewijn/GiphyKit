import Foundation

public struct Giphy {
    public let type: String
    public let identifier: String
    public let slug: String
    public let url: URL
    public let bitlyGifURL: URL
    public let bitlyURL: URL
    public let embedURL: URL
    public let username: String
    public let source: URL?
    public let rating: Rating
    public let caption: String?
    public let contentURL: URL?
    public let sourceTLD: String
    public let sourcePostURL: URL?
    public let importDateTime: Date?
    public let trendingDateTime: Date?
    public var images: [GiphyImage] = []
}

extension Giphy {
    // swiftlint:disable function_body_length cyclomatic_complexity
    public init?(json: [String: Any], types: [ImageType]) {
        guard let type = json["type"] as? String else { print("type"); return nil }
        guard let identifier = json["id"] as? String else { print("id"); return nil }
        guard let slug = json["slug"] as? String else { print("slug"); return nil }
        guard let urlV = json["url"] as? String,
            let url = URL(string: urlV) else { print("url"); return nil }
        guard let bitlyGifURLV = json["bitly_gif_url"] as? String,
            let bitlyGifURL = URL(string: bitlyGifURLV) else { print("bitly gif url"); return nil }
        guard let bitlyURLV = json["bitly_url"] as? String,
            let bitlyURL = URL(string: bitlyURLV) else { print("bitly url"); return nil }
        guard let embedURLV = json["embed_url"] as? String,
            let embedURL = URL(string: embedURLV) else { print("embed"); return nil }
        guard let username = json["username"] as? String else { print("username"); return nil }
        guard let sourceV = json["source"] as? String else { print("source"); return nil }
        guard let ratingV = json["rating"] as? String,
            let rating = Rating(rawValue: ratingV) else { print("rating"); return nil }
        guard let contentURLV = json["content_url"] as? String else { print("content url"); return nil }
        guard let sourceTLD = json["source_tld"] as? String else { print("source tld"); return nil }
        guard let sourcePostURLV = json["source_post_url"] as? String else { print("source url"); return nil }
        guard let importDateTimeV = json["import_datetime"] as? String else { print("import"); return nil }
        guard let trendingDateTimeV = json["trending_datetime"] as? String else { print("trending"); return nil }
        guard let images = json["images"] as? [String: Any] else { print("images"); return nil }

        let dateFrmttr = DateFormatter()
        dateFrmttr.dateFormat = "yyyy-MM-dd hh:mm:ss"

        self.type = type
        self.identifier = identifier
        self.slug = slug
        self.url = url
        self.bitlyGifURL = bitlyGifURL
        self.bitlyURL = bitlyURL
        self.embedURL = embedURL
        self.username = username
        self.source = URL(string: sourceV)
        self.rating = rating
        self.caption = json["caption"] as? String
        self.contentURL = URL(string: contentURLV)
        self.sourceTLD = sourceTLD
        self.sourcePostURL = URL(string: sourcePostURLV)
        self.importDateTime = dateFrmttr.date(from: importDateTimeV)
        self.trendingDateTime = dateFrmttr.date(from: trendingDateTimeV)
        self.images = get(images: types, fromJson: images)
    }
    // swiftlint:enable function_body_length cyclomatic_complexity

    private func get(images: [ImageType], fromJson json: [String: Any]) -> [GiphyImage] {
        return images.flatMap({ type in
            guard let dic: [String: Any] = json[type.rawValue] as? [String: Any],
                let image: GiphyImage = GiphyImage(json: dic, type: type) else { return nil }
            return image
        })
    }
}
