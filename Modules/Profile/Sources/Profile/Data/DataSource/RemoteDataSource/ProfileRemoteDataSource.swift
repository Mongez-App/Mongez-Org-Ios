import Foundation
import Common

public protocol ProfileRemoteDataSource {
    func getProfile() async throws -> OrganizationProfileDTO
    func updateProfile(name: String, photoUrl: String?) async throws -> OrganizationProfileDTO
    func uploadProfilePhoto(fileData: Data, fileName: String) async throws -> UploadOrganizationPhotoResponseDTO
}

public class ProfileRemoteDataSourceImpl: ProfileRemoteDataSource {
    public init() {}

    public func getProfile() async throws -> OrganizationProfileDTO {
        let endpoint = ProfileEndpoints.getProfile
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: OrganizationProfileDTO.self)
    }

    public func updateProfile(name: String, photoUrl: String?) async throws -> OrganizationProfileDTO {
        let endpoint = ProfileEndpoints.updateProfile(name: name, photoUrl: photoUrl)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: OrganizationProfileDTO.self)
    }

    public func uploadProfilePhoto(fileData: Data, fileName: String) async throws -> UploadOrganizationPhotoResponseDTO {
        let boundary = "Boundary-\(UUID().uuidString)"
        let payload = createMultipartBody(fileData: fileData, boundary: boundary, fieldName: "file", fileName: fileName, mimeType: "image/jpeg")
        let endpoint = ProfileEndpoints.uploadProfilePhoto(payload: payload, boundary: boundary)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: UploadOrganizationPhotoResponseDTO.self)
    }

    private func createMultipartBody(fileData: Data, boundary: String, fieldName: String, fileName: String, mimeType: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append("\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        return body
    }
}
