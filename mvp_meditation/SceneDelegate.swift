import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Create a window for the scene and set the root view
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: ContentView())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is about to transition to the background.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene becomes active.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene moves to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from background to foreground.
    }
}
