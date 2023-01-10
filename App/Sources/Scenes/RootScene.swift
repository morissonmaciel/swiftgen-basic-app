//
//  RootScene.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 23/12/22.
//

import UIKit

final class RootScene: UITabBarController {
    private func setupVC(_ viewController: UIViewController, title: String, systemImage: String) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = UIImage(systemName: systemImage)
        navVC.tabBarItem.selectedImage = UIImage(systemName: "\(systemImage).fill")
        navVC.navigationBar.prefersLargeTitles = true

        viewController.title = title
        viewController.view.backgroundColor = .systemBackground
        return navVC
    }
    
    private func setupTabs() {        
        viewControllers = [
            setupVC(HeadlinesViewController(), title: "Headlines", systemImage: "square.text.square"),
            setupVC(SourcesViewController(), title: "Sources", systemImage: "list.bullet.rectangle"),
            setupVC(FavoritesViewController(), title: "Favorites", systemImage: "heart.text.square"),
            setupVC(UIViewController(), title: "Settings", systemImage: "gear.circle")
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
}
