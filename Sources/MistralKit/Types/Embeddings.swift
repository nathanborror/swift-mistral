import Foundation

public struct EmbeddingRequest: Codable {
    public var model: String
    public var input: [String]
    public var encodingFormat: EncodingFormat
    
    public enum EncodingFormat: Codable {
        case float
    }
    
    public init(model: String, input: [String], encodingFormat: EncodingFormat = .float) {
        self.model = model
        self.input = input
        self.encodingFormat = encodingFormat
    }
}

public struct EmbeddingResponse: Codable {
    public let id: String
    public let object: String
    public let data: [Embedding]
    public let model: String
    public let usage: Usage
    
    public struct Embedding: Codable {
        public let object: String
        public let embedding: [Double]
        public let index: Int
    }
    
    public struct Usage: Codable {
        public let promptTokens: Int
        public let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
}
