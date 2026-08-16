//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI
import Common

public class TeamCourseDetailsCoordinator: Coordinator, ObservableObject {
    public var id = UUID()
    @Published public var childCoordinators: [any Coordinator] = []
    @Published public var navigationPath = NavigationPath()
    
    public init() {}
    
    public func push(_ route: TeamCourseDetailsRoute) {
        navigationPath.append(route)
    }
    
    public func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}
