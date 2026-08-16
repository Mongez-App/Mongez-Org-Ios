//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public enum EventType: String, CaseIterable, Identifiable, Equatable {
    case midterm = "Midterm"
    case project = "Project"
    case quiz = "Quiz"
    case assignment = "Assignment"
    case exam = "Exam"

    public var id: String { rawValue }
}
