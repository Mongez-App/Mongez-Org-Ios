import Foundation
import Combine

@MainActor
public class TeamsViewModel: ObservableObject {
    @Published public var teams: [Team] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let getTeamsUseCase: GetTeamsUseCase
    private let createTeamUseCase: CreateTeamUseCase
    
    nonisolated public init(
        getTeamsUseCase: GetTeamsUseCase,
        createTeamUseCase: CreateTeamUseCase
    ) {
        self.getTeamsUseCase = getTeamsUseCase
        self.createTeamUseCase = createTeamUseCase
    }
    
    public func fetchTeams() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            let response = try await getTeamsUseCase.execute()
            self.teams = response.teams
        } catch {
            self.errorMessage = error.localizedDescription
            print("Fetch Teams Error: \(error)")
        }
        self.isLoading = false
    }
    
    public func createTeam(name: String, photoUrl: String, inviteCode: String) async -> Bool {
        self.isLoading = true
        self.errorMessage = nil
        do {
            _ = try await createTeamUseCase.execute(
                name: name,
                photoUrl: photoUrl,
                inviteCode: inviteCode
            )
            self.isLoading = false
            await fetchTeams()
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            return false
        }
    }
}
