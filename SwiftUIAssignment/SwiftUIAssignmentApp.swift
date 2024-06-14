//
//  SwiftUIAssignmentApp.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/14/24.
//

import SwiftUI

@main
struct SwiftUIAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
