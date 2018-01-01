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
        
        let homeNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), tabTitle: "Home")
        let searchNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), tabTitle: "Search")
        let selectSnapNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"), tabTitle: "Pick")
        let likeNavController = instantiateViewController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"), tabTitle: "Like")
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        userProfileNavController.tabBarItem.title = "Profile"
        viewControllers = [homeNavController, searchNavController, selectSnapNavController, likeNavController, userProfileNavController]
        
        tabBar.tintColor = .black
    }
    
    private func instantiateViewController(selectedImage: UIImage, unselectedImage: UIImage, tabTitle: String) -> UINavigationController{
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.title = tabTitle
        return navController
    }
}
