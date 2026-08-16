import Foundation
import Common

public protocol TeamsRemoteDataSource {
    func getTeams() async throws -> TeamListResponseDTO
    func createTeam(request: CreateTeamRequestDTO) async throws -> TeamDTO
}

public class TeamsRemoteDataSourceImpl: TeamsRemoteDataSource {
    public init() {}
    
    public func getTeams() async throws -> TeamListResponseDTO {
        let endpoint = TeamsEndpoints.getTeams
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamListResponseDTO.self)
    }
    
    public func createTeam(request: CreateTeamRequestDTO) async throws -> TeamDTO {
        let endpoint = TeamsEndpoints.createTeam(request: request)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamDTO.self)
    }
}
