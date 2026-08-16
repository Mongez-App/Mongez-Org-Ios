import Foundation

public protocol TeamsRepository {
    func getTeams() async throws -> TeamListResponse
    func createTeam(name: String, photoUrl: String, inviteCode: String) async throws -> NewTeam
}
