import Foundation

public enum ImageType: String {
    case fixed_height
    case fixed_height_still
    case fixed_height_downsampled
    case fixed_width
    case fixed_width_still
    case fixed_width_downsampled
    case fixed_height_small
    case fixed_height_small_still
    case fixed_width_small
    case fixed_width_small_still
    case preview
    case downsized_small
    case downsized
    case downsized_medium
    case downsized_large
    case downsized_still
    case original
    case original_still
    case looping
}

// MARK: GiphyImage

public struct GiphyImage {
    public let type: ImageType
    public let url: URL
    public let width: Float
    public let height: Float
    public var mp4: URL?
    public var mp4Size: Float?
    public var webp: URL?
    public var webpSize: Float?
    public var size: Float?
}

extension GiphyImage {
    init?(json: [String: Any], type: ImageType) {
        guard let urlV = json["url"] as? String,
            let url = URL(string: urlV) else { return nil }
        guard let widthV = json["width"] as? String,
            let width = Float(widthV) else { return nil }
        guard let heightV = json["height"] as? String,
            let height = Float(heightV) else { return nil }

        self.type = type
        self.url = url
        self.width = width
        self.height = height
        if let mp4V = json["mp4"] as? String {
            self.mp4 = URL(string: mp4V)
        }
        if let mp4SizeV = json["mp4_size"] as? String {
            self.mp4Size = Float(mp4SizeV)
        }
        if let webpV = json["webp"] as? String {
            self.webp = URL(string: webpV)
        }
        if let webpSizeV = json["webp_size"] as? String {
            self.webpSize = Float(webpSizeV)
        }
        if let sizeV = json["size"] as? String {
            self.size = Float(sizeV)
        }
    }
}
