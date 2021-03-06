//
//  Post.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 08/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import Foundation

struct Post {
    var postId: String?
    let postImageUrl: String
    let user: UserProfile
    let caption: String
    let creationDate: Date
    var hasLiked = false
    
    init(user: UserProfile, dictionary: [String: Any]) {
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        let timeElapsedSince1970 = dictionary["createdOn"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: timeElapsedSince1970)
    }
}
