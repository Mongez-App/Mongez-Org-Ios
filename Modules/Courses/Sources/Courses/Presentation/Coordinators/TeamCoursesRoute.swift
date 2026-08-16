//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public enum TeamCoursesRoute: Equatable, Hashable {
    case courseDetails(courseId: String)
    case addCourse
    case addEvent
}

extension TeamCoursesRoute: Identifiable {
    public var id: String {
        switch self {
        case .courseDetails(let id): return "course_\(id)"
        case .addCourse: return "addCourse"
        case .addEvent: return "addEvent"
        }
    }
}
