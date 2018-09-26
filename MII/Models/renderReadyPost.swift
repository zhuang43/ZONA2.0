//
//  renderReadyPost.swift
//  MII
//
//  Created by MacDouble on 9/5/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation

struct renderReadyPost {
    let profileImage: String!
    let title: String!
    let content: String!
    let poster: String!
    let categorie: String!
    let addedBy:String!
    let postId:String!
    let numLikes: Int!
    let numComments: Int!
    let coverUrl: String!
    let contentUrl: String!
    let creationDate: Date!
    
    
    init(postId: String, profileImage: String, title: String, content:String,poster: String, categorie: String, addedBy:String, numLikes: Int, numComments: Int, coverUrl: String, contentUrl: String, creationDate: Date){
        self.postId = postId
        self.profileImage = profileImage
        self.title = title
        self.content = content
        self.poster = poster
        self.categorie = categorie
        self.addedBy = addedBy
        self.numLikes = numLikes
        self.numComments = numComments
        self.coverUrl = coverUrl
        self.contentUrl = contentUrl
        self.creationDate = creationDate
    }
}
