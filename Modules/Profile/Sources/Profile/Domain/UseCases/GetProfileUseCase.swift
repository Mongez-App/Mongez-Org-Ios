import Foundation

public struct GetProfileUseCase {
    private let repository: ProfileRepository

    public init(repository: ProfileRepository) {
        self.repository = repository
    }

    public func execute() async throws -> OrganizationProfile {
        return try await repository.getProfile()
    }
}
