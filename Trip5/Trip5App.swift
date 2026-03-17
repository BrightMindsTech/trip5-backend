import SwiftUI

@main
struct Trip5App: App {
    @StateObject private var localization = LocalizationManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainFlowView()
                .environmentObject(localization)
        }
    }
}
