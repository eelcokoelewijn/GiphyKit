import Foundation

// MARK: GiphyImage

public protocol GiphyImage {
    var url: URL { get }
    var width: Float { get }
    var height: Float { get }
}

public protocol Size {
    var size: Float { get }
}

public protocol MP4 {
    var mp4: URL { get }
    var mp4Size: Float { get }
}

public protocol WebP {
    var webp: URL { get set }
    var webpSize: Float { get set }
}

// MARK: Original

public struct Original: GiphyImage, MP4, WebP {
    public let url: URL
    public let width: Float
    public let height: Float
    public var mp4: URL
    public var mp4Size: Float
    public var webp: URL
    public var webpSize: Float
}

extension Original {
    init?(json: [String: Any]) {
        guard let urlV = json["url"] as? String,
            let url = URL(string: urlV) else { return nil }
        guard let widthV = json["width"] as? String,
            let width = Float(widthV) else { return nil }
        guard let heightV = json["height"] as? String,
         let height = Float(heightV) else { return nil }
        guard let mp4V = json["mp4"] as? String,
            let mp4 = URL(string: mp4V) else { return nil }
        guard let mp4SizeV = json["mp4_size"] as? String,
            let mp4Size = Float(mp4SizeV) else { return nil }
        guard let webpV = json["webp"] as? String,
            let webp = URL(string: webpV) else { return nil }
        guard let webpSizeV = json["webp_size"] as? String,
            let webpSize = Float(webpSizeV) else { return nil }

        self.url = url
        self.width = width
        self.height = height
        self.mp4 = mp4
        self.mp4Size = mp4Size
        self.webp = webp
        self.webpSize = webpSize
    }
}

// MARK: Fixed width/height downsampled

public struct FixedDownsampled: GiphyImage, Size, WebP {
    public let url: URL
    public let width: Float
    public let height: Float
    public var size: Float
    public var webp: URL
    public var webpSize: Float
}

extension FixedDownsampled {
    init?(json: [String: Any]) {
        guard let urlV = json["url"] as? String,
            let url = URL(string: urlV) else { return nil }
        guard let widthV = json["width"] as? String,
            let width = Float(widthV) else { return nil }
        guard let heightV = json["height"] as? String,
            let height = Float(heightV) else { return nil }
        guard let sizeV = json["size"] as? String,
            let size = Float(sizeV) else { return nil }
        guard let webpV = json["webp"] as? String,
            let webp = URL(string: webpV) else { return nil }
        guard let webpSizeV = json["webp_size"] as? String,
            let webpSize = Float(webpSizeV) else { return nil }
        self.url = url
        self.width = width
        self.height = height
        self.size = size
        self.webp = webp
        self.webpSize = webpSize
    }
}

// MARK: Still

public struct Still: GiphyImage {
    public var url: URL
    public var width: Float
    public var height: Float
}

extension Still {
    init?(json: [String: Any]) {
        guard let urlV = json["url"] as? String,
            let url = URL(string: urlV) else { return nil }
        guard let widthV = json["width"] as? String,
            let width = Float(widthV) else { return nil }
        guard let heightV = json["height"] as? String,
            let height = Float(heightV) else { return nil }
        self.url = url
        self.width = width
        self.height = height
    }
}
