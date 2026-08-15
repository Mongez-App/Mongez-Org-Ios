//
//  MongezOrgApp.swift
//  MongezOrg
//
//  Created by mohamed sharaf on 14/08/2026.
//

import SwiftUI
import Courses

@main
struct MongezOrgApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: appCoordinator)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
