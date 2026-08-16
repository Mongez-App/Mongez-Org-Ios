import Foundation

public struct CreateTeamRequestDTO: Encodable {
    public let name: String
    public let photoUrl: String
    public let inviteCode: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case photoUrl
        case inviteCode = "invite_code"
    }
}
