import Foundation
import SharedKit

public struct ChatRequest: Codable, Sendable {
    public var model: String
    public var temperature: Double?
    public var top_p: Double?
    public var max_tokens: Int?
    public var stream: Bool?
    public var stop: [String]?
    public var random_seed: Int?
    public var messages: [Message]
    public var response_format: ResponseFormat?
    public var tools: [Tool]?
    public var tool_choice: ToolChoice?
    public var presence_penalty: Double?
    public var frequency_penalty: Double?
    public var n: Int?
    public var safe_prompt: Bool?

    public struct Message: Codable, Sendable {
        public var content: [Content]?
        public var tool_calls: [ToolCall]?
        public var prefix: Bool?
        public var role: Role?

        public struct Content: Codable, Sendable {
            public var type: ContentType
            public var text: String?
            public var image_url: ImageURL?

            public enum ContentType: String, CaseIterable, Codable, Sendable {
                case text, image_url
            }

            public struct ImageURL: Codable, Sendable {
                public var url: String
                public var detail: String?

                public init(url: String, detail: String? = nil) {
                    self.url = url
                    self.detail = detail
                }
            }

            public init(type: ContentType, text: String? = nil, image_url: ImageURL? = nil) {
                self.type = type
                self.text = text
                self.image_url = image_url
            }
        }

        public enum Role: String, CaseIterable, Codable, Sendable {
            case system, assistant, user, tool
        }

        public struct ToolCall: Codable, Sendable {
            public var id: String
            public var type: String = "function"
            public var function: Function

            public struct Function: Codable, Sendable {
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

        public init(content: [Content]? = nil, tool_calls: [ToolCall]? = nil, prefix: Bool? = nil, role: Role? = nil) {
            self.content = content
            self.tool_calls = tool_calls
            self.prefix = prefix
            self.role = role
        }
    }

    public struct ResponseFormat: Codable, Sendable {
        public var type: ResponseFormatType

        public enum ResponseFormatType: String, CaseIterable, Codable, Sendable {
            case text, json_object
        }

        public init(type: ResponseFormatType) {
            self.type = type
        }
    }

    public struct Tool: Codable, Sendable {
        public var type: String = "function"
        public var function: Function?

        public struct Function: Codable, Sendable {
            public var name: String
            public var description: String?
            public var parameters: JSONSchema?

            public init(name: String, description: String? = nil, parameters: JSONSchema? = nil) {
                self.name = name
                self.description = description
                self.parameters = parameters
            }
        }

        public init(function: Function? = nil) {
            self.function = function
        }
    }

    public enum ToolChoice: Codable, Sendable {
        case none, auto, any, required, tool(Tool)

        public struct Tool: Codable, Sendable {
            public var type: String = "function"
            public var function: Function

            public struct Function: Codable, Sendable {
                public var name: String

                public init(name: String) {
                    self.name = name
                }
            }

            public init(function: Function) {
                self.function = function
            }
        }
    }

    public init(model: String, temperature: Double? = nil, top_p: Double? = nil, max_tokens: Int? = nil, stream: Bool? = nil, stop: [String]? = nil, random_seed: Int? = nil, messages: [Message], response_format: ResponseFormat? = nil, tools: [Tool]? = nil, tool_choice: ToolChoice? = nil, presence_penalty: Double? = nil, frequency_penalty: Double? = nil, n: Int? = nil, safe_prompt: Bool? = nil) {
        self.model = model
        self.temperature = temperature
        self.top_p = top_p
        self.max_tokens = max_tokens
        self.stream = stream
        self.stop = stop
        self.random_seed = random_seed
        self.messages = messages
        self.response_format = response_format
        self.tools = tools
        self.tool_choice = tool_choice
        self.presence_penalty = presence_penalty
        self.frequency_penalty = frequency_penalty
        self.n = n
        self.safe_prompt = safe_prompt
    }
}

public struct ChatResponse: Codable, Sendable {
    public let id: String
    public let object: String
    public let model: String
    public let usage: Usage?
    public let created: Date
    public let choices: [Choice]

    public struct Usage: Codable, Sendable {
        public let prompt_tokens: Int
        public let completion_tokens: Int
        public let total_tokens: Int
    }

    public struct Choice: Codable, Sendable {
        public let index: Int
        public let message: Message
        public let finish_reason: FinishReason?

        public struct Message: Codable, Sendable {
            public let content: String?
            public let tool_calls: [ToolCall]?
            public let prefix: String?
            public let role: String?

            public struct ToolCall: Codable, Sendable {
                public let id: String?
                public let type: String?
                public let function: Function

                public struct Function: Codable, Sendable {
                    public var name: String
                    public var arguments: String
                }
            }
        }

        public enum FinishReason: String, CaseIterable, Codable, Sendable {
            case stop, length, model_length, error, tool_calls
        }
    }
}

public struct ChatStreamResponse: Codable, Sendable {
    public let id: String
    public let object: String?
    public let model: String
    public let created: Date?
    public let choices: [Choice]
    public let usage: Usage?

    public struct Usage: Codable, Sendable {
        public let prompt_tokens: Int
        public let completion_tokens: Int
        public let total_tokens: Int
    }

    public struct Choice: Codable, Sendable {
        public let index: Int
        public let delta: Message
        public let finish_reason: FinishReason?

        public struct Message: Codable, Sendable {
            public let content: String?
            public let tool_calls: [ToolCall]?
            public let prefix: String?
            public let role: String?

            public struct ToolCall: Codable, Sendable {
                public let id: String?
                public let type: String?
                public let function: Function

                public struct Function: Codable, Sendable {
                    public var name: String
                    public var arguments: String
                }
            }
        }

        public enum FinishReason: String, CaseIterable, Codable, Sendable {
            case stop, length, model_length, error, tool_calls
        }
    }
}

extension ChatRequest.ToolChoice {

    enum CodingKeys: String, CodingKey {
        case none, auto, any, required, tool
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none:
            try container.encode(CodingKeys.none.rawValue)
        case .auto:
            try container.encode(CodingKeys.auto.rawValue)
        case .any:
            try container.encode(CodingKeys.any.rawValue)
        case .required:
            try container.encode(CodingKeys.required.rawValue)
        case .tool(let tool):
            try container.encode(tool)
        }
    }
}
