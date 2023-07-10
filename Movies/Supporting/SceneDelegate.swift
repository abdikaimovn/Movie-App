//
//  SceneDelegate.swift
//  Movies
//
//  Created by Нурдаулет on 27.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        let home = TabController()
        self.window?.rootViewController = home
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }
}

