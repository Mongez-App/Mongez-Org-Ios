import Foundation
import Combine
import Common

@MainActor
public class TeamsViewModel: ObservableObject {
    @Published public var teams: [Team] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let getTeamsUseCase: GetTeamsUseCase
    private let createTeamUseCase: CreateTeamUseCase
    private let cloudinaryService: CloudinaryServiceProtocol
    
    nonisolated public init(
        getTeamsUseCase: GetTeamsUseCase,
        createTeamUseCase: CreateTeamUseCase,
        cloudinaryService: CloudinaryServiceProtocol
    ) {
        self.getTeamsUseCase = getTeamsUseCase
        self.createTeamUseCase = createTeamUseCase
        self.cloudinaryService = cloudinaryService
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
    
    public func createTeam(name: String, photoData: Data?, inviteCode: String) async -> Bool {
        self.isLoading = true
        self.errorMessage = nil
        
        var photoUrl = ""
        
        if let data = photoData {
            do {
                photoUrl = try await cloudinaryService.uploadImage(imageData: data)
            } catch {
                self.errorMessage = "Failed to upload photo: \(error.localizedDescription)"
                self.isLoading = false
                return false
            }
        }
        
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
