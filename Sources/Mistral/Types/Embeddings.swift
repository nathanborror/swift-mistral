import Foundation

public struct EmbeddingsRequest: Codable {
    public var input: [String]
    public var model: String
    public var encoding_format: String = "float"

    public init(model: String, input: [String]) {
        self.model = model
        self.input = input
    }
}

public struct EmbeddingsResponse: Codable {
    public let id: String
    public let object: String
    public let model: String
    public let usage: Usage
    public let data: [Embedding]
    
    public struct Embedding: Codable {
        public let object: String
        public let embedding: [Double]
        public let index: Int
    }
    
    public struct Usage: Codable {
        public let prompt_tokens: Int
        public let completion_tokens: Int
        public let total_tokens: Int
    }
}
