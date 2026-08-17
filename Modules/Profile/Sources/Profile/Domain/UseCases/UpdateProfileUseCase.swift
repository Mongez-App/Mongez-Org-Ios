import Foundation

public struct UpdateProfileUseCase {
    private let repository: ProfileRepository

    public init(repository: ProfileRepository) {
        self.repository = repository
    }

    public func execute(name: String, photoUrl: String?) async throws -> OrganizationProfile {
        return try await repository.updateProfile(name: name, photoUrl: photoUrl)
    }
}
