import Foundation

public struct GetTeamsUseCase {
    private let repository: TeamsRepository
    
    public init(repository: TeamsRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> TeamListResponse {
        return try await repository.getTeams()
    }
}
