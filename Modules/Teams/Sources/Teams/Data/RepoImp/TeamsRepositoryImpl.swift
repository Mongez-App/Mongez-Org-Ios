import Foundation
import Common

public class TeamsRepositoryImpl: TeamsRepository {
    private let remoteDataSource: TeamsRemoteDataSource
    
    public init(remoteDataSource: TeamsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getTeams() async throws -> TeamListResponse {
        let responseDTO = try await remoteDataSource.getTeams()
        return TeamListResponseDTO.mapToTeamListResponse(dto: responseDTO)
    }
    
    public func createTeam(name: String, photoUrl: String, inviteCode: String) async throws -> NewTeam {
        let requestDTO = CreateTeamRequestDTO(name: name, photoUrl: photoUrl, inviteCode: inviteCode)
        let responseDTO = try await remoteDataSource.createTeam(request: requestDTO)
        return TeamListResponseDTO.mapToNewTeam(dto: responseDTO)
    }
}
