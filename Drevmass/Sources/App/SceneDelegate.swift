//
//  SceneDelegate.swift
//  Drevmass
//
//  Created by Aset Bakirov on 02.03.2024.
//

import UIKit
//import Reachability
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var currentScene: UIScene?
    

//    var notificationView = NotificationView()
//    
//    @objc func reachabilityChanged(note: Notification) {
//
//       let reachability = note.object as! Reachability
//
//        if reachability.connection == .wifi {
//            print("wifi wifi wifi wifi wifi")
//        }
//        if reachability.connection == .unavailable {
//           print("нет соединения!!!!!")
//            self.notificationView.show(viewController: (window?.rootViewController)!, notificationType: .attantion)
//        }
//    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        
//        let reachability = try? Reachability()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
//        try? reachability?.startNotifier()
////        do{
////            try reachability!.startNotifier()
////        }catch{
////          print("could not start reachability notifier")
////        }
        
        currentScene = scene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController = AuthenticationService.shared.isAuthorized ? TabBarController() : UINavigationController(rootViewController: OnboardingViewController())
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func setRootViewController(_ viewController: UIViewController){
        
        guard let scene = (currentScene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        
    }

   
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

