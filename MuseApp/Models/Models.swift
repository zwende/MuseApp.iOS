//
//  Models.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/3/22.
//

import Foundation


struct User{
    let username: String
    let bio: String
   // let joinDate: Date
    let background : String
    let profilePicture: String?
    let counts : UserCounts
    let email : String
    let identifier : UserIdentifier
}

struct UserCounts{
    let following: Int
    let followers: Int
    let posts: Int
}

struct UserIdentifier{
    let identifier : String
}


public struct UserPost{
    let identifier : String
    let postText: String
   // let postURL: URL
    let likeCount: [PostLike]
    let comments : [PostComment]
   // let createdDate: Date
    let owner : UserIdentifier
}

struct PostLike{
    let username: String
    let postIdentifier: String
}

struct PostComment{
    let username: String
    let comment: String
 //   let createdAt: Date
    let identifier : String
}
