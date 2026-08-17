import Foundation
import Common

public class ProfileRepositoryImpl: ProfileRepository {
    private let remoteDataSource: ProfileRemoteDataSource

    public init(remoteDataSource: ProfileRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func getProfile() async throws -> OrganizationProfile {
        let dto = try await remoteDataSource.getProfile()
        return OrganizationProfileDTO.mapToEntity(dto: dto)
    }

    public func updateProfile(name: String, photoUrl: String?) async throws -> OrganizationProfile {
        let dto = try await remoteDataSource.updateProfile(name: name, photoUrl: photoUrl)
        return OrganizationProfileDTO.mapToEntity(dto: dto)
    }

    public func uploadProfilePhoto(fileData: Data, fileName: String) async throws -> String {
        let dto = try await remoteDataSource.uploadProfilePhoto(fileData: fileData, fileName: fileName)
        return dto.photoUrl
    }
}
