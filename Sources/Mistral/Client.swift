import Foundation

public final class Client {

    public static let defaultHost = URL(string: "https://api.mistral.ai/v1")!

    public let host: URL
    public let apiKey: String

    internal(set) public var session: URLSession

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(session: URLSession = URLSession(configuration: .default), host: URL? = nil, apiKey: String) {
        self.session = session
        self.host = host ?? Self.defaultHost
        self.apiKey = apiKey

        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateInt = try container.decode(Int.self)
            return Date(timeIntervalSince1970: TimeInterval(dateInt))
        }
    }

    public enum Error: Swift.Error, CustomStringConvertible {
        case requestError(String)
        case responseError(response: HTTPURLResponse, detail: String)
        case decodingError(response: HTTPURLResponse, detail: String)
        case unexpectedError(String)

        public var description: String {
            switch self {
            case .requestError(let detail):
                return "Request error: \(detail)"
            case .responseError(let response, let detail):
                return "Response error (Status \(response.statusCode)): \(detail)"
            case .decodingError(let response, let detail):
                return "Decoding error (Status \(response.statusCode)): \(detail)"
            case .unexpectedError(let detail):
                return "Unexpected error: \(detail)"
            }
        }
    }

    private enum Method: String {
        case post = "POST"
        case get = "GET"
    }

    struct ErrorResponse: Decodable {
        let detail: Detail

        struct Detail: Swift.Error, CustomStringConvertible, Decodable {
            let loc: [String]
            let msg: String
            let type: String

            public var description: String {
                "(\(type)) — \(msg)"
            }
        }
    }
}

// MARK: - Models

extension Client {

    public func models() async throws -> ModelsResponse {
        try await fetch(.get, "models")
    }
}

// MARK: - Chats

extension Client {

    public func chatCompletions(_ request: ChatRequest) async throws -> ChatResponse {
        guard request.stream == nil || request.stream == false else {
            throw Error.requestError("ChatRequest.stream cannot be set to 'true'")
        }
        return try await fetch(.post, "chat/completions", body: request)
    }

    public func chatCompletionsStream(_ request: ChatRequest) throws -> AsyncThrowingStream<ChatStreamResponse, Swift.Error> {
        guard request.stream == true else {
            throw Error.requestError("ChatRequest.stream must be set to 'true'")
        }
        return try fetchAsync(.post, "chat/completions", body: request)
    }
}

// MARK: - Embeddings

extension Client {

    public func embeddings(_ request: EmbeddingsRequest) async throws -> EmbeddingsResponse {
        try await fetch(.post, "embeddings", body: request)
    }
}

// MARK: - Private

extension Client {

    private func fetch<Response: Decodable>(_ method: Method, _ path: String, body: Encodable? = nil) async throws -> Response {
        try checkAuthentication()
        let request = try makeRequest(path: path, method: method, body: body)
        let (data, resp) = try await session.data(for: request)
        try checkResponse(resp, data)
        return try decoder.decode(Response.self, from: data)
    }

    private func fetchAsync<Response: Codable>(_ method: Method, _ path: String, body: Encodable) throws -> AsyncThrowingStream<Response, Swift.Error> {
        try checkAuthentication()
        let request = try makeRequest(path: path, method: method, body: body)
        return AsyncThrowingStream { continuation in
            let session = StreamingSession<Response>(session: session, request: request)
            session.onReceiveContent = {_, object in
                continuation.yield(object)
            }
            session.onProcessingError = {_, error in
                continuation.finish(throwing: error)
            }
            session.onComplete = { object, error in
                continuation.finish(throwing: error)
            }
            session.perform()
        }
    }

    private func checkAuthentication() throws {
        if apiKey.isEmpty {
            throw Error.requestError("Missing API key")
        }
    }

    private func checkResponse(_ resp: URLResponse?, _ data: Data) throws {
        if let response = resp as? HTTPURLResponse, response.statusCode != 200 {
            if let err = try? decoder.decode(ErrorResponse.self, from: data) {
                throw Error.responseError(response: response, detail: err.detail.msg)
            } else {
                throw Error.responseError(response: response, detail: "Unknown response error")
            }
        }
    }

    private func makeRequest(path: String, method: Method, body: Encodable? = nil) throws -> URLRequest {
        var req = URLRequest(url: host.appending(path: path))
        req.httpMethod = method.rawValue
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        if let body {
            req.httpBody = try encoder.encode(body)
        }
        return req
    }
}
