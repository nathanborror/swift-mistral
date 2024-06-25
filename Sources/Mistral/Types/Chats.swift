import Foundation

public struct ChatRequest: Codable {
    public var model: String
    public var messages: [Message]
    public var tools: [Tool]?
    public let toolChoice: ToolChoice?
    public var temperature: Float?
    public var topP: Float?
    public var maxTokens: Int?
    public var stream: Bool?
    public var safeMode: Bool?
    public var randomSeed: Int?
    public var responseFormat: ResponseFormat?
    
    public enum ToolChoice: String, Codable {
        case none
        case auto
        case any
    }
    
    public struct ResponseFormat: Codable {
        public var type: String
    }
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case tools
        case toolChoice = "tool_choice"
        case temperature
        case topP = "top_p"
        case maxTokens = "max_tokens"
        case stream
        case safeMode = "safe_mode"
        case randomSeed = "random_seed"
        case responseFormat = "response_format"
    }
    
    public init(model: String, messages: [Message], tools: [Tool]? = nil, toolChoice: ToolChoice? = nil,
                temperature: Float? = nil, topP: Float? = nil, maxTokens: Int? = nil, stream: Bool? = nil,
                safeMode: Bool? = nil, randomSeed: Int? = nil, responseFormat: ResponseFormat? = nil) {
        self.model = model
        self.messages = messages
        self.tools = tools
        self.toolChoice = toolChoice
        self.temperature = temperature
        self.topP = topP
        self.maxTokens = maxTokens
        self.stream = stream
        self.safeMode = safeMode
        self.randomSeed = randomSeed
        self.responseFormat = responseFormat
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
    public var toolCalls: [ToolCall]?
    public var toolCallID: String?
    
    public enum Role: String, Codable {
        case system, assistant, user, tool
    }
    
    public struct ToolCall: Codable {
        public var id: String
        public var function: Function
        
        public struct Function: Codable {
            public var name: String?
            public var arguments: String?
            
            public init(name: String? = nil, arguments: String? = nil) {
                self.name = name
                self.arguments = arguments
            }
        }
        
        public init(id: String, function: Function) {
            self.id = id
            self.function = function
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case toolCalls = "tool_calls"
        case toolCallID = "tool_call_id"
    }
    
    public init(role: Role? = nil, content: String? = nil, toolCalls: [ToolCall]? = nil, toolCallID: String? = nil) {
        self.role = role
        self.content = content
        self.toolCalls = toolCalls
        self.toolCallID = toolCallID
    }
}

public enum FinishReason: String, Codable {
    case stop, length, model_length, error, tool_calls
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
