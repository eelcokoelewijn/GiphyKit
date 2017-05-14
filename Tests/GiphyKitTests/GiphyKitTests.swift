import XCTest
@testable import GiphyKit

class GiphyKitTests: XCTestCase {
    var session: URLSession!
    var baseUrl: URL = URL(string: "https://api.giphy.com/v1/gifs/")!
    var apiKey: String = "dc6zaTOxFJmzC" //The public beta key is "dc6zaTOxFJmzC”
    var sampleMetaSuccess: Meta?

    override func setUp() {
        super.setUp()
        session = URLSession.shared
        sampleMetaSuccess = Meta(status: 200, message: "OK")
    }

    func testParsingOfGiphyResultWithMetadata() {
        let exp = expecting(description: "Metadata is parsed successful from response")
        let search = SearchRequest(query: "testing", limit: nil, offset: nil, lang: nil, rating: nil, format: nil)
        request(search) { result in
            if case let .success(response) = result {
                let result = GiphyResponse(json: response, imageTypes: [.original])
                XCTAssertNotNil(result)
                XCTAssertEqual(result?.meta, self.sampleMetaSuccess)
                exp.fulfill()
            }
        }
        wait(5)
    }

    func testParsingOfGiphyResultWithPagination() {
        let exp = expecting(description: "Pagination is parsed successful from response")
        let search = SearchRequest(query: "testing", limit: nil, offset: nil, lang: nil, rating: nil, format: nil)
        request(search) { result in
            if case let .success(response) = result {
                let result = GiphyResponse(json: response, imageTypes: [.original])
                XCTAssertNotNil(result?.pagination)
                exp.fulfill()
            }
        }
        wait(5)
    }

    func testParsingOfGiphyResultContainsGiphiesEqualToPaginationSize() {
        let exp = expecting(description: "Number of giphies parsed is equal to pagination count")
        let search = SearchRequest(query: "testing")
        request(search) { result in
            if case let .success(response) = result {
                let result = GiphyResponse(json: response, imageTypes: [.original])
                XCTAssertEqual(result?.giphies.count, result?.pagination?.count)
                exp.fulfill()
            }
        }
        wait(5)
    }

    func testParsingOfGiphyResultContainsGiphiesOriginal() {
        let exp = expecting(description: "Result contains original giphy image")
        let search = SearchRequest(query: "testing")
        request(search) { result in
            if case let .success(response) = result {
                let result = GiphyResponse(json: response, imageTypes: [.original])
                XCTAssertEqual(result?.giphies.first?.images.first?.type, .original)
                exp.fulfill()
            }
        }
        wait(5)
    }

    static var allTests = [
        ("testParsingOfGiphyResultWithMetadata", testParsingOfGiphyResultWithMetadata),
        ("testParsingOfGiphyResultWithPagination", testParsingOfGiphyResultWithPagination)
    ]

    private func request(_ request: GiphyRequest,
                         completion: @escaping (GiphyNetworkServiceResult<[String: Any]>) -> Void) {
        let requestUrl = baseUrl.appendingPathComponent(request.path, isDirectory: false)
        var items: [URLQueryItem] = request.params.flatMap { (param: (key: String, value: String?)) in
            guard let value = param.value else { return nil }
            return URLQueryItem(name: param.key, value: value)
        }
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        var urlComp = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false)!
        urlComp.queryItems = items
        let request = URLRequest(url: urlComp.url!)
        let task = session.dataTask(with: request, completionHandler: { (data, _, _) in
            guard let data = data else {
                completion(.failure(msg: "no data", code: 1001))
                return
            }
            guard let parseResult = try? JSONSerialization.jsonObject(with: data, options: []),
                let result = parseResult as? [String: Any] else {
                    completion(.failure(msg: "error parsing json", code: 1000))
                    return
            }
            completion(.success(result))
        })
        task.resume()
    }
}

extension XCTestCase {
    func expecting(description: String = "\(#function)") -> XCTestExpectation {
        return expectation(description: description)
    }

    func wait(_ timeout: TimeInterval = 0.1) {
        self.waitForExpectations(timeout: timeout, handler: nil)
    }

    func delay(_ delay: Double = 1.0, executeAfter: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            executeAfter()
        }
    }
}
