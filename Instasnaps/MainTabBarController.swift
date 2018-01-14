//
//  MainTabBarController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 31/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let loginNavController = UINavigationController(rootViewController: loginController)
                self.present(loginNavController, animated: true, completion: nil)
            }
        }
        
        setupTabBarControllers()
    }
    
    func setupTabBarControllers() {
        
        // Home Tab
        let homeNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), tabTitle: "Home", viewController: HomeFeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Search Tab
        let searchNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), tabTitle: "Search", viewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Select Photo Tab
        let selectSnapNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"), tabTitle: "Pick")
        
        // Select Like Tab
        let likeNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"), tabTitle: "Like")
        
        // UserProfile Tab
        let userProfileNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), tabTitle: "Profile", viewController:
            UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        viewControllers = [homeNavController, searchNavController, selectSnapNavController, likeNavController, userProfileNavController]
        
        tabBar.tintColor = .black
    }
    
    private func instantiateViewController(selectedImage: UIImage, unselectedImage: UIImage, tabTitle: String, viewController: UIViewController = UIViewController()) -> UINavigationController{
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.title = tabTitle
        return navController
    }
}

extension MainTabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
