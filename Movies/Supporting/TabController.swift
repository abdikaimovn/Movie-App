//
//  TabController.swift
//  Movies
//
//  Created by Нурдаулет on 28.06.2023.
//

import UIKit
import SnapKit

class TabController: UITabBarController {
    private let lineAboveTabBar: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hex: "#0296E5")
        return line
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs()
    }
    
    func setupVCs() {
        view.backgroundColor = .clear
        tabBar.addSubview(lineAboveTabBar)
        lineAboveTabBar.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.top)
            make.height.equalTo(2)
            make.width.equalToSuperview()
        }
        UITabBar.appearance().barTintColor = .clear
        tabBar.tintColor = UIColor(hex: "#0296E5")
        viewControllers = [
            createNavController(for: HomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house")!),
            createNavController(for: SearchViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: WatchListViewController(), title: NSLocalizedString("Watch list", comment: ""), image: UIImage(systemName: "bookmark")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        let titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        rootViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: titleFont]
        return navController
    }
    
}
