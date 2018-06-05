//
//  MainTabBarController.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 3/28/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

enum TabBarTitle: String {
    case restaurantListing = "Home"
    case account = "Account"
    case augmentedReality = "AR"
}

// MARK: MainTabBarController
class MainTabBarController: UITabBarController {
    
    fileprivate let restaurantListingController: UINavigationController = {
        let viewController = RestaurantListingViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "Home (Deselected)")
//        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "Home (Selected)")
        navigationController.tabBarItem.title = TabBarTitle.restaurantListing.rawValue
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.isTranslucent = false
        navigationController.view.backgroundColor = .white
        return navigationController
    }()
    
    fileprivate let userAccountNavigationController: UINavigationController = {
        let viewController = UserAccountViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "Account (Deselected)")
        navigationController.tabBarItem.title = TabBarTitle.account.rawValue
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.isTranslucent = false
        navigationController.view.backgroundColor = .white
        return navigationController
    }()
    
    fileprivate let introductionARNavigationController: UINavigationController = {
        let viewController = IntroductionARViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = StyleKit.imageOfAugmentedRealityCube()
        navigationController.tabBarItem.title = TabBarTitle.augmentedReality.rawValue
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.isNavigationBarHidden = true
        navigationController.view.backgroundColor = .white
        return navigationController
    }()
    
}

// MARK: MainTabBarController - Life cycles
extension MainTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViewControllers()
        setUpTabBar()
    }
}

// MARK: MainTabBarController - UI, Layout, Overhead
extension MainTabBarController {
    fileprivate func embedViewControllers() {
        viewControllers = [restaurantListingController,
                           introductionARNavigationController,
                           userAccountNavigationController]
    }
    
    fileprivate func setUpTabBar() {
        tabBar.tintColor = UIColor.TabBarItem.selected
        tabBar.barTintColor = UIColor.white
        tabBar.isTranslucent = false
    }
}
