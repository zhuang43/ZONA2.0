//
//  post.swift
//  zona
//
//  Created by MacDouble on 2/22/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Post {
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
    
        
    init() {
        self.postId = ""
        self.profileImage = ""
        self.title = ""
        self.content = ""
        self.poster = ""
        self.categorie = ""
        self.addedBy = ""
        self.numLikes = 0
        self.numComments = 0
        self.coverUrl = ""
        self.contentUrl = ""
        self.creationDate = Date()
    }
    
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
    
    init (snapshot:DocumentSnapshot){

        if let snap = snapshot["content"] as? String{
            self.content = snap
        }else{
            content = ""
        }
        if let temppostId = snapshot["postId"] as? String{
            postId = temppostId
        }else{
            postId = ""
        }
        if let postAddedBy = snapshot["addedBy"] as? String{
            addedBy = postAddedBy
        }else{
            addedBy = ""
        }
        if let postPoster = snapshot["poster"] as? String{
            poster = postPoster
        }else{
            poster = ""
        }
        if let postCat = snapshot["cat"] as? String{
            categorie = postCat
        }else{
            categorie = ""
        }
        if let postImage = snapshot["profileImage"] as? String{
            profileImage = postImage
        }else{
            profileImage = ""
        }
        if let postTitle = snapshot["title"] as? String{
            title = postTitle
        }else{
            title = ""
        }
        if let postNumComments = snapshot["numComments"] as? Int{
            numComments = postNumComments
        }else{
            numComments = 0
        }
        if let postNumLikes = snapshot["numLikes"] as? Int{
            numLikes = postNumLikes
        }else{
            numLikes = 0
        }
        if let post = snapshot["coverUrl"] as? String{
            coverUrl = post
        }else{
            coverUrl = ""
        }
        if let post = snapshot["contentUrl"] as? String{
            contentUrl = post
        }else{
            contentUrl = ""
        }
        if let date = snapshot["creationDate"] as? Date{
            creationDate = date
        }else{
            creationDate = Date()
        }
    }
    
    func toAnyObject() -> Any{
        return ["postId": postId, "profileImage": profileImage, "title": title, "content": content, "cat": categorie,"poster": poster, "addedBy": addedBy, "numLikes": numLikes, "numComments": numComments,"coverUrl": coverUrl, "contentUrl":contentUrl, "creationDate":creationDate]
    }
   
}


class LocalPost{
    
    var profileImage: String!
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
    var profileimage: UIImage!
    var coverimage: UIImage!
    
    
    init (snapshot:DocumentSnapshot){
        
        if let snap = snapshot["content"] as? String{
            self.content = snap
        }else{
            content = ""
        }
        if let temppostId = snapshot["postId"] as? String{
            postId = temppostId
        }else{
            postId = ""
        }
        if let postAddedBy = snapshot["addedBy"] as? String{
            addedBy = postAddedBy
        }else{
            addedBy = ""
        }
        if let postPoster = snapshot["poster"] as? String{
            poster = postPoster
        }else{
            poster = ""
        }
        if let postCat = snapshot["cat"] as? String{
            categorie = postCat
        }else{
            categorie = ""
        }
        if let postImage = snapshot["profileImage"] as? String{
            profileImage = postImage
        }else{
            profileImage = ""
        }
        if let postTitle = snapshot["title"] as? String{
            title = postTitle
        }else{
            title = ""
        }
        if let postNumComments = snapshot["numComments"] as? Int{
            numComments = postNumComments
        }else{
            numComments = 0
        }
        if let postNumLikes = snapshot["numLikes"] as? Int{
            numLikes = postNumLikes
        }else{
            numLikes = 0
        }
        if let post = snapshot["coverUrl"] as? String{
            coverUrl = post
        }else{
            coverUrl = ""
        }
        if let post = snapshot["contentUrl"] as? String{
            contentUrl = post
        }else{
            contentUrl = ""
        }
        if let date = snapshot["creationDate"] as? Date{
            creationDate = date
        }else{
            creationDate = Date()
        }
        self.profileimage = UIImage.init()
        self.coverimage = UIImage.init()
    }
}
