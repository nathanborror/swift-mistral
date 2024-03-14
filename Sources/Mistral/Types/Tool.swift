import Foundation
import SharedKit

public struct Tool: Codable, Equatable {
    public let type: String
    public let function: Function?
    
    public struct Function: Codable, Equatable {
        public let name: String
        public let description: String?
        public let parameters: JSONSchema?
      
        public init(name: String, description: String? = nil, parameters: JSONSchema? = nil) {
          self.name = name
          self.description = description
          self.parameters = parameters
        }
    }
    
    public init(type: String, function: Function) {
        self.type = type
        self.function = function
    }
}
