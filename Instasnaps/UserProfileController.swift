//
//  UserProfileController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 31/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot.value ?? "Value is nil or empty")
            guard let userProfileDictionary = snapshot.value as? [String: Any] else {return}
            
            let username = userProfileDictionary["username"] as? String
            self.navigationItem.title = username
            
        }, withCancel: {(error) in
            print("Error occred while reading user profile")
        })
    }
}
