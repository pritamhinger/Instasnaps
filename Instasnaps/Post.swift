//
//  Post.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 08/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import Foundation

struct Post {
    let postImageUrl: String
    let user: UserProfile
    let caption: String
    
    init(user: UserProfile, dictionary: [String: Any]) {
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
