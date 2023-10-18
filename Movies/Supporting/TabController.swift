//
//  TabController.swift
//  Movies
//
//  Created by Нурдаулет on 28.06.2023.
//

import UIKit
import SnapKit

class CustomTabBar: UITabBar {
    // Set your desired tab bar height
    private let customHeight: CGFloat = 90

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
}


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

        // Create and set the custom tab bar
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")

        tabBar.addSubview(lineAboveTabBar)
        lineAboveTabBar.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.top)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        UITabBar.appearance().barTintColor = .clear
        tabBar.tintColor = UIColor(hex: "#0296E5")
        tabBar.backgroundColor = UIColor(hex: "#191919")
        viewControllers = [
            createNavController(for: HomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house")!),
            createNavController(for: SearchViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: WatchListViewController(), title: NSLocalizedString("Bookmarks", comment: ""), image: UIImage(systemName: "bookmark")!)
        ]
    }

    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        let titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        rootViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: titleFont]
        return navController
    }
}
