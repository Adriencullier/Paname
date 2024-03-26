import Foundation

/// Event Entity
public struct EventEntity: Codable, Equatable {
    // MARK: - Properties
    var id : String?
    var title: String?
    var leadText: String?
    var tags: [String]?
    var coverUrlStr: String?
    var accessUrlStr: String?
    var dateDescription: String?
    var pmr: Int?
    var blind: Int?
    var deaf: Int?
    var addressName: String?
    var addressStreet: String?
    var zipCode: String?
    var addressCity: String?
    var priceType: String?
    var dateStart: String?
    var dateEnd: String?
    var occurrences: String?
    var audience: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case leadText = "lead_text"
        case tags = "tags"
        case addressName = "address_name"
        case addressStreet = "address_street"
        case addressCity = "address_city"
        case zipCode = "address_zipcode"
        case coverUrlStr = "cover_url"
        case accessUrlStr = "access_link"
        case dateDescription = "date_description"
        case pmr = "pmr"
        case blind = "blind"
        case deaf = "deaf"
        case priceType = "price_type"
        case occurrences = "occurrences"
        case audience = "audience"
        case dateStart = "date_start"
        case dateEnd = "date_end"
    }
}
