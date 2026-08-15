//
//  MongezOrgApp.swift
//  MongezOrg
//
//  Created by mohamed sharaf on 14/08/2026.
//

import SwiftUI
import OrganizationAuth
import FirebaseCore

@main
struct MongezOrgApp: App {
    let persistenceController = PersistenceController.shared
    
    private let coordinator: OrganizationAuthCoordinator
    
    init() {
        FirebaseApp.configure()
        
        let networkService = OrganizationAuthNetworkServiceImpl()
        let repository = OrganizationAuthRepositoryImpl(networkService: networkService)
        let useCase = AuthUseCaseImpl(repository: repository)
        self.coordinator = OrganizationAuthCoordinator(useCase: useCase)
    }

    var body: some Scene {
        WindowGroup {
            OrganizationAuthCoordinatorView(
                coordinator: coordinator,
                dashboardContent: { AnyView(ContentView()) }
            )
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
