//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Common

public enum TeamCoursesEndPoint: EndPoint {
    case getCourses(teamId: String, organizationId: String)
    case createCourse(request: CreateTeamCourseRequestDTO, organizationId: String)
    case uploadMaterial(courseId: String, fileData: Data, fileName: String, mimeType: String, boundary: String)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getCourses(let teamId, _): return "/organization/getCourses?teamId=\(teamId)"
        case .createCourse: return "/organization/createCourse"
        case .uploadMaterial: return "/organization/uploadCourseMaterial"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getCourses: return .get
        case .createCourse, .uploadMaterial: return .post
        }
    }
    
    public var headers: [String : String]? {
        var defaultHeaders: [String: String] = [:]
        
        // If testing with fixed org22, send empty token to bypass backend mismatch
        let token = UserDefaults.standard.string(forKey: "main_token") ?? ""


        switch self {
        case .getCourses(_, let organizationId):
            defaultHeaders["Authorization"] = organizationId == "org22" ? "Bearer " : "Bearer \(token)"
            defaultHeaders["x-user-id"] = organizationId // From Postman Screenshot
            defaultHeaders["Content-Type"] = "application/json"
        case .createCourse(_, let organizationId):
            defaultHeaders["Authorization"] = organizationId == "org22" ? "Bearer " : "Bearer \(token)"
            defaultHeaders["x-user-id"] = organizationId
            defaultHeaders["Content-Type"] = "application/json"
        case .uploadMaterial(_, _, _, _, let boundary):
            defaultHeaders["Authorization"] = "Bearer \(token)"
            defaultHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        }
        return defaultHeaders
    }
    
    public var body: Data? {
        switch self {
        case .getCourses:
            return nil
        case .createCourse(let request, _):
            return try? JSONEncoder().encode(request)
        case .uploadMaterial(let courseId, let fileData, let fileName, let mimeType, let boundary):
            return createMultipartBody(courseId: courseId, fileData: fileData, fileName: fileName, mimeType: mimeType, boundary: boundary)
        }
    }
    
    private func createMultipartBody(courseId: String?, fileData: Data, fileName: String, mimeType: String, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        if let courseId = courseId {
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"courseId\"\(lineBreak)\(lineBreak)".data(using: .utf8)!)
            body.append("\(courseId)\(lineBreak)".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append(lineBreak.data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return body
    }
}
