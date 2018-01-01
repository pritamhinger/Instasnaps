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
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        navController.tabBarItem.title = "Profile"
        viewControllers = [navController, UIViewController()]
        
        tabBar.tintColor = .black
    }
}
