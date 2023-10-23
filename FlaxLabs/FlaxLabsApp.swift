//Created for FlaxLabs in 2023
// Using Swift 5.0

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
        
        // Checking if unit tests are running
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
          print("Setting up Firebase emulator localhost:8080")
          let settings = Firestore.firestore().settings
          settings.host = "localhost:8080"
          settings.isPersistenceEnabled = false
          settings.isSSLEnabled = false
          Firestore.firestore().settings = settings
        }

      return true
    }
}


@main
struct FlaxLabsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
