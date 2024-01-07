import Foundation

public struct ChatRequest: Codable {
    public var model: String
    public var messages: [Message]
    public var temperature: Float?
    public var topP: Float?
    public var maxTokens: Int?
    public var stream: Bool?
    public var safeMode: Bool?
    public var randomSeed: Int?
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case temperature
        case topP = "top_p"
        case maxTokens = "max_tokens"
        case stream
        case safeMode = "safe_mode"
        case randomSeed = "random_seed"
    }
    
    public init(model: String, messages: [Message], temperature: Float? = nil, topP: Float? = nil, 
                maxTokens: Int? = nil, stream: Bool? = nil, safeMode: Bool? = nil, randomSeed: Int? = nil) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.topP = topP
        self.maxTokens = maxTokens
        self.stream = stream
        self.safeMode = safeMode
        self.randomSeed = randomSeed
    }
}

public struct ChatResponse: Codable {
    public let id: String
    public let object: String?
    public let created: Date
    public let model: String
    public let choices: [Choice]
    public let usage: Usage?
    
    public struct Choice: Codable {
        public let index: Int
        public let message: Message
        public let finishReason: FinishReason?
        
        enum CodingKeys: String, CodingKey {
            case index
            case message
            case finishReason = "finish_reason"
        }
    }
}

public struct ChatStreamResponse: Codable {
    public let id: String
    public let object: String?
    public let created: Date?
    public let model: String
    public let choices: [Choice]
    public let usage: Usage?
    
    public struct Choice: Codable {
        public let index: Int
        public let delta: Message
        public let finishReason: FinishReason?
        
        enum CodingKeys: String, CodingKey {
            case index
            case delta
            case finishReason = "finish_reason"
        }
    }
}

public struct Message: Codable {
    public var role: Role?
    public var content: String?
    
    public enum Role: String, Codable {
        case system, assistant, user
    }
    
    public init(role: Role, content: String) {
        self.role = role
        self.content = content
    }
}

public enum FinishReason: String, Codable {
    case stop, length, model_length
}

public struct Usage: Codable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
