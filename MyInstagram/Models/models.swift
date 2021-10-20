//
//  models.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 15/10/21.
//

import Foundation

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

public enum Gender {
    case male, female, other
}

public struct User {
    let username: String
    let bio: String
    let profilePhoto: URL
    let counts : UserCount
    let name: (first: String, last: String)
    let birthDate: Date
    let Gender: Gender
    let joinDate: Date
}

public struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
    
}

/// Represents a user post
public struct UserPost {
    let Identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let owner: User
}


struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

