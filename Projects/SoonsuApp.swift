////
////  HambJaeryoModalApp.swift
////  HambJaeryoModal
////
////  Created by coulson on 5/28/25.
////
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SoonsuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .modelContainer(for: [IngredientEntity.self, LaborCost.self])
        }
    }
}
