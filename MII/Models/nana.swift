//
//  nana.swift
//  zona
//
//  Created by MacDouble on 2/22/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Nana {
    let key:String!
    let profileImage: String!
    let title: String!
    let content: String!
    let poster: String!
    let categorie: String!
    let addedBy:String!
    let nanaId:String!
    let numLikes: Int!
    let numComments: Int!
    let ref: DatabaseReference?
    
    init(nanaId: String, profileImage: String, title: String, content:String,poster: String, categorie: String, addedBy:String, numLikes: Int, numComments: Int, key:String = ""){
        self.key = key
        self.nanaId = nanaId
        self.profileImage = profileImage
        self.title = title
        self.content = content
        self.poster = poster
        self.categorie = categorie
        self.addedBy = addedBy
        self.numLikes = numLikes
        self.numComments = numComments
        self.ref = nil
    }
    
    init (snapshot:DataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        
        if let nanaValue = snapshot.value as? NSDictionary {
            content = nanaValue["content"] as? String
        }else{
            content = ""
        }
        if let tempNanaId = snapshot.value as? NSDictionary {
            nanaId = tempNanaId["nanaId"] as? String
        }else{
            nanaId = ""
        }
        if let nanaAddedBy = snapshot.value as? NSDictionary {
            addedBy = nanaAddedBy["addedBy"] as? String
        }else{
            addedBy = ""
        }
        if let nanaPoster = snapshot.value as? NSDictionary {
            poster = nanaPoster["poster"] as? String
        }else{
            poster = ""
        }
        if let nanaCat = snapshot.value as? NSDictionary {
            categorie = nanaCat["cat"] as? String
        }else{
            categorie = ""
        }
        if let nanaImage = snapshot.value as? NSDictionary {
            profileImage = nanaImage["profileImage"] as? String
        }else{
            profileImage = ""
        }
        if let nanaTitle = snapshot.value as? NSDictionary {
            title = nanaTitle["title"] as? String
        }else{
            title = ""
        }
        if let nanaNumComments = snapshot.value as? NSDictionary {
            numComments = nanaNumComments["numComments"] as? Int
        }else{
            numComments = 0
        }
        if let nanaNumLikes = snapshot.value as? NSDictionary {
            numLikes = nanaNumLikes["numLikes"] as? Int
        }else{
            numLikes = 0
        }
    }
    func toAnyObject() -> Any{
        return ["nanaId": nanaId, "profileImage": profileImage, "title": title, "content": content, "cat": categorie,"poster": poster, "addedBy": addedBy, "numLikes": numLikes, "numComments": numComments]
    }
   
}
