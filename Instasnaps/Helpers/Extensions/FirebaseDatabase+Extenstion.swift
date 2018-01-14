//
//  FirebaseDatabase+Extenstion.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 14/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    static func fetchUserWithUID(uid: String, onCompletionHandler: @escaping (_ user: UserProfile) -> ()){
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionay = snapshot.value as? [String: Any] else{ return }
            let user = UserProfile(uid: uid, dictionary: userDictionay)
            onCompletionHandler(user)
        }) { (error) in
            print("Error occured while fetching user", error)
        }
    }
}
