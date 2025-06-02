//
//  SoonsuApp.swift
//  Soonsu
//
//  Created by coulson on 6/2/25.
//

import SwiftUI
import SwiftData

@main
struct SoonsuApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SSContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
