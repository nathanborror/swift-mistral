import Foundation

public struct ModelsResponse: Codable, Sendable {
    public let object: String
    public let data: [Model]

    public struct Model: Codable, Sendable {
        public let id: String
        public let object: String?
        public let created: Date?
        public let owned_by: String?
        public let capabilities: Capabilities?
        public let name: String?
        public let description: String?
        public let max_context_length: Int?
        public let aliases: [String]?
        public let deprecation: String?
        public let default_model_temperature: Double?
        public let type: String?
        public let job: String?
        public let root: String?
        public let archived: Bool?

        public struct Capabilities: Codable, Sendable {
            public let completion_chat: Bool
            public let completion_fim: Bool
            public let function_calling: Bool
            public let fine_tuning: Bool
            public let vision: Bool
        }
    }
}
