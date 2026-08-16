//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import Common

public enum TeamCourseDetailsEndPoint: EndPoint {
    case getMaterials(courseId: String, organizationId: String)
    case uploadMaterial(courseId: String, fileData: Data, fileName: String, mimeType: String, boundary: String)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getMaterials(let courseId, _):
            return "/organization/getCourseMaterials?courseId=\(courseId)"
        case .uploadMaterial:
            return "/organization/uploadCourseMaterial"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getMaterials: return .get
        case .uploadMaterial: return .post
        }
    }
    
    public var headers: [String: String]? {
        var defaultHeaders = ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "main_token") ?? "")"]
        
        switch self {
        case .getMaterials(_, let organizationId):
            defaultHeaders["x-user-id"] = organizationId
            defaultHeaders["Content-Type"] = "application/json"
        case .uploadMaterial(_, _, _, _, let boundary):
            defaultHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        }
        return defaultHeaders
    }
    
    public var body: Data? {
        switch self {
        case .getMaterials:
            return nil
        case .uploadMaterial(let courseId, let fileData, let fileName, let mimeType, let boundary):
            return createMultipartBody(courseId: courseId, fileData: fileData, fileName: fileName, mimeType: mimeType, boundary: boundary)
        }
    }
    
    private func createMultipartBody(courseId: String, fileData: Data, fileName: String, mimeType: String, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        // Append courseId text field
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"courseId\"\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append("\(courseId)\(lineBreak)".data(using: .utf8)!)
        
        // Append file field
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return body
    }
}
