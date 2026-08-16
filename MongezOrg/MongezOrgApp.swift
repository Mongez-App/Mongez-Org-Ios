//
//  MongezOrgApp.swift
//  MongezOrg
//
//  Created by mohamed sharaf on 14/08/2026.
//

import SwiftUI
import Courses
import OrganizationAuth
import Common
import FirebaseCore

@main
struct MongezOrgApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var appCoordinator = AppCoordinator()
    @State private var showSplash = true

    private let authCoordinator: OrganizationAuthCoordinator

    init() {
        FirebaseApp.configure()

        let networkService = OrganizationAuthNetworkServiceImpl()
        let repository = OrganizationAuthRepositoryImpl(networkService: networkService)
        let useCase = AuthUseCaseImpl(repository: repository)
        self.authCoordinator = OrganizationAuthCoordinator(useCase: useCase)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView(
                        logoImageName: "logo",
                        sloganImageName: "slogan",
                        onSplashFinished: { showSplash = false }
                    )
                } else {
                    OrganizationAuthCoordinatorView(
                        coordinator: authCoordinator,
                        dashboardContent: { AnyView(AppCoordinatorView(coordinator: appCoordinator)) }
                    )
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
