import Foundation

public struct UploadProfilePhotoUseCase {
    private let repository: ProfileRepository

    public init(repository: ProfileRepository) {
        self.repository = repository
    }

    public func execute(fileData: Data, fileName: String) async throws -> String {
        return try await repository.uploadProfilePhoto(fileData: fileData, fileName: fileName)
    }
}
