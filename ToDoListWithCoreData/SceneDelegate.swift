//
//  SceneDelegate.swift
//  ToDoListWithCoreData
//
//  Created by sss on 22.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let vc = ViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .clear
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

