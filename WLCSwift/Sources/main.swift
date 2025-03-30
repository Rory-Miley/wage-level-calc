import SwiftUI

struct WageLevelCalcApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 500, height: 500)
    }
}

WageLevelCalcApp.main() 