//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI

public struct TeamCourseDetailsCoordinatorView: View {
    @StateObject public var coordinator: TeamCourseDetailsCoordinator
    @StateObject public var viewModel: TeamCourseDetailsViewModel
    
    public init(coordinator: TeamCourseDetailsCoordinator, viewModel: TeamCourseDetailsViewModel) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        CourseDetailsView(viewModel: viewModel)
            .navigationDestination(for: TeamCourseDetailsRoute.self) { route in
                switch route {
                case .documentViewer(let url):
                    Text("Document Viewer: \(url)")
                }
            }
    }
}
