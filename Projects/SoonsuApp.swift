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
    @StateObject var tabBarState = TabBarState()
    
    var body: some Scene {
        WindowGroup {
            SplashView() // Soonsu->View->Launch
//            MainTabViewCoulson()
                .modelContainer(for: [
                    Ingredient.self,
                    SoldItemModel.self,  // ✅ SwiftData에 새로 등록
                    DailySalesRecord.self,
                    MonthlyFixedCostRecord.self,
                    FixedCostTemporary.self,
                    LaborCost.self,
                    // 여기부터
                    OverheadCost.self,
                    BasicCost.self,
                    UtilityCost.self,
                    InsuranceCost.self,
                    DepreciationCost.self,
                    RentalCost.self,
                    TaxCost.self
                    // 여기까지 간접비 관련 모델
                ])
                .environmentObject(tabBarState)
        }
    }
}
