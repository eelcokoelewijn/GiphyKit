import Foundation

public protocol GiphyKit {
    func search(for request: SearchRequest, completion: @escaping (GiphyResponse) -> Void)
    func trending(_ request: TrendingRequest, completion: @escaping (GiphyResponse) -> Void)
    func translate(to request: TranslateRequest, completion: @escaping (GiphyResponse) -> Void)
    func random(_ request: RandomRequest, completion: @escaping (GiphyResponse) -> Void)
}

public protocol UsesGiphyKit {
    var giphyKit: GiphyKit { get }
}

public struct MixinGiphyKit: GiphyKit, UsesGiphyNetworkService {
    public let giphyNetworkService: GiphyNetworkService

    public init(giphyNetworkService: GiphyNetworkService) {
        self.giphyNetworkService = giphyNetworkService
    }

    public func search(for request: SearchRequest, completion: @escaping (GiphyResponse) -> Void) {
        giphyNetworkService.load(request) { result in
            if case let .failure(msg, code) = result {
                completion(GiphyResponse(meta: Meta(status: code, message: msg)))
            } else if case let .success(response) = result {
                completion(self.parse(imageTypes: request.imageTypes, fromJSON: response))
            }
        }
    }

    public func trending(_ request: TrendingRequest, completion: @escaping (GiphyResponse) -> Void) {
        giphyNetworkService.load(request) { result in
            if case let .failure(msg, code) = result {
                completion(GiphyResponse(meta: Meta(status: code, message: msg)))
            } else if case let .success(response) = result {
                completion(self.parse(imageTypes: request.imageTypes, fromJSON: response))
            }
        }
    }

    public func translate(to request: TranslateRequest, completion: @escaping (GiphyResponse) -> Void) {
        giphyNetworkService.load(request) { result in
            if case let .failure(msg, code) = result {
                completion(GiphyResponse(meta: Meta(status: code, message: msg)))
            } else if case let .success(response) = result {
                completion(self.parse(imageTypes: request.imageTypes, fromJSON: response))
            }
        }
    }

    public func random(_ request: RandomRequest, completion: @escaping (GiphyResponse) -> Void) {
        giphyNetworkService.load(request) { result in
            if case let .failure(msg, code) = result {
                completion(GiphyResponse(meta: Meta(status: code, message: msg)))
            } else if case let .success(response) = result {
                completion(self.parse(imageTypes: request.imageTypes, fromJSON: response))
            }
        }
    }

    private func parse(imageTypes: [ImageType], fromJSON json: [String: Any]) -> GiphyResponse {
        guard let response = GiphyResponse(json: json, imageTypes: imageTypes) else {
            return GiphyResponse(meta: Meta(status: 1000, message: "GiphyKit failed to parse json"),
                                 pagination: nil,
                                 giphies: [])
        }
        return response
    }
}
