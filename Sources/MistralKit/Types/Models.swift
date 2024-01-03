import Foundation

public struct ModelListResponse: Codable {
    public let object: String
    public let data: [ModelResponse]
}

public struct ModelResponse: Codable {
    public let id: String
    public let object: String
    public let created: Date
    public let ownedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case ownedBy = "owned_by"
    }
}
