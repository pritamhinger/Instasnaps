//
//  Comment.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 21/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import Foundation

struct Comment {
    let user: UserProfile
    let text: String
    let uid: String
    
    init(user: UserProfile, commentJSON: [String : Any]) {
        self.text = commentJSON["commentText"] as? String ?? ""
        self.uid = commentJSON["commentedByUserId"] as? String ?? ""
        self.user = user
    }
}
