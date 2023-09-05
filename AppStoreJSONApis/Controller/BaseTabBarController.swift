//
//  BaseTabBarController.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 13.02.23.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createViewController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
            createViewController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
            createViewController(viewController: AppsSearchController(), title: "Search", imageName: "search"),
            createViewController(viewController: MusicController(), title: "Music", imageName: "music")
        ]
    }
    
    fileprivate func createViewController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
