import Foundation

public enum GiphyNetworkServiceResult<T> {
    case success(T)
    case failure(msg: String, code: Int)
}

public protocol GiphyNetworkService {
    init(config: GiphyConfig)
    func load(_ request: GiphyRequest, completion: @escaping (GiphyNetworkServiceResult<[String: Any]>) -> Void)
}

public protocol UsesGiphyNetworkService {
    var giphyNetworkService: GiphyNetworkService { get }
}
