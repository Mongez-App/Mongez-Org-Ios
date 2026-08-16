import Foundation

public struct CreateTeamUseCase {
    private let repository: TeamsRepository
    
    public init(repository: TeamsRepository) {
        self.repository = repository
    }
    
    public func execute(name: String, photoUrl: String, inviteCode: String) async throws -> NewTeam {
        return try await repository.createTeam(name: name, photoUrl: photoUrl, inviteCode: inviteCode)
    }
}
