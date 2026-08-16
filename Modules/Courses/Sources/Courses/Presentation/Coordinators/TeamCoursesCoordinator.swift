//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Combine
import Common

public class TeamCoursesCoordinator: Coordinator, ObservableObject {
    public var id = UUID()
    @Published public var childCoordinators: [any Coordinator] = []
    @Published public var navigationPath = NavigationPath()
    @Published public var sheetRoute: TeamCoursesRoute?
    
    public let teamId: String
    public let teamName: String
    public let organizationId: String
    public var onFinish: (() -> Void)?
    
    public init(teamId: String, organizationId: String, teamName: String) {
        self.teamId = teamId
        self.teamName = teamName
        self.organizationId = organizationId
    }
    
    public func push(_ route: TeamCoursesRoute) {
        navigationPath.append(route)
    }
    
    public func presentSheet(_ route: TeamCoursesRoute) {
        sheetRoute = route
    }
    
    public func dismissSheet() {
        sheetRoute = nil
    }
}
