//
//  MongezOrgApp.swift
//  MongezOrg
//
//  Created by mohamed sharaf on 14/08/2026.
//

import SwiftUI

@main
struct MongezOrgApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
