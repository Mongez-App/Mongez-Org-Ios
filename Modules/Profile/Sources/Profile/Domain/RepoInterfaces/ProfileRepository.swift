import Foundation

public protocol ProfileRepository {
    func getProfile() async throws -> OrganizationProfile
    func updateProfile(name: String, photoUrl: String?) async throws -> OrganizationProfile
    func uploadProfilePhoto(fileData: Data, fileName: String) async throws -> String
}
