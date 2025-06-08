////
////  HambJaeryoModalApp.swift
////  HambJaeryoModal
////
////  Created by coulson on 5/28/25.
////
//
import SwiftUI
import FirebaseCore
import SwiftData

class AppDelegateCoulson: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SoonsuAppCoulson: App {
    @UIApplicationDelegateAdaptor(AppDelegateCoulson.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainTabViewCoulson()
                .modelContainer(for: [
                    IngredientCoulson.self,
                    SoldItemModel.self,  // ✅ SwiftData에 새로 등록
                    DailySalesRecord.self,
                    MonthlyFixedCostRecord.self
                ])
        }
    }
}
