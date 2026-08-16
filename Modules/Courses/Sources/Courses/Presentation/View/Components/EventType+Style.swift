//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

extension EventType {
    public var color: Color {
        switch self {
        case .midterm: return AppTheme.Colors.green100
        case .project: return AppTheme.Colors.orange100
        case .quiz: return AppTheme.Colors.purple100
        case .assignment: return AppTheme.Colors.blue100
        case .exam: return AppTheme.Colors.red100
        }
    }
}
