
//////
//////  HambJaeryoModalApp.swift
//////  HambJaeryoModal/System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch
//////
//////  Created by coulson on 5/28/25.
//////

//
import SwiftUI
import FirebaseCore
import SwiftData

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
            MainTabViewCoulson()
                .modelContainer(for: [
                    Ingredient.self,
                    SoldItemModel.self,  // ✅ SwiftData에 새로 등록
                    DailySalesRecord.self,
                    MonthlyFixedCostRecord.self
                ])
        }
    }
}
