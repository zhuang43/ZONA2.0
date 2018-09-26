//
//  user.swift
//  zona
//
//  Created by MacDouble on 2/22/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct User {
    
    //let key:String!
    let email:String!
    let profileImage: String!
    let nickName: String!
    let socialName: String!
    let bio:String!
    let age: String!
    let location: String!
    let tag: String!
    let sex: Int!
    
   // let ref: DatabaseReference?
    
    init(){
        self.nickName = ""
        self.socialName = ""
        self.profileImage = ""
        self.email = ""
        self.location = ""
        self.tag = ""
        self.age = ""
        self.bio = ""
        self.sex = 3
    }
    
    init(email: String, profileImage: String, nickName: String, socialName:String, bio:String,  age: String, location: String, tag: String, sex: Int, key:String = ""){
        //self.key = key
        self.nickName = nickName
        self.socialName = socialName
        self.profileImage = profileImage
        self.email = email
        self.location = location
        self.tag = tag
        self.age = age
        self.bio = bio
        self.sex = sex
        //self.ref = nil
    }
    
    init (snapshot:DocumentSnapshot){
        
        
        if let data = snapshot["nickName"] as? String{
            nickName = data
        }else{
            nickName = ""
        }
        if let data = snapshot["profileImage"] as? String{
            profileImage = data
        }else{
            profileImage = ""
        }
        if let data = snapshot["socialName"] as? String{
            socialName = data
        }else{
            socialName = ""
        }
        if let data = snapshot["email"] as? String{
            email = data
        }else{
            email = ""
        }
        if let data = snapshot["location"] as? String{
            location = data
        }else{
            location = ""
        }
        if let data = snapshot["tag"] as? String{
            tag = data
        }else{
            tag = ""
        }
        if let data = snapshot["age"] as? String{
            age = data
        }else{
            age = ""
        }
        if let data = snapshot["sex"] as? Int {
            sex = data
        }else{
            sex = 1
        }
        if let data = snapshot["bio"] as? String {
            bio = data
        }else{
            bio = ""
        }

    }

    func toAnyObject() -> Any{
        return ["email": email, "profileImage": profileImage, "nickName": nickName, "socialName": socialName, "bio": bio, "age": age, "sex": sex,"location": location, "tag": tag]
    }
    
}

