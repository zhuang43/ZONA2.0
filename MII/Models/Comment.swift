//
//  Comment.swift
//  MII
//
//  Created by MacDouble on 9/5/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Firebase

struct Comment {
    
    let commenter: String!
    let commenterId: String!
    let content: String!
    let commentId: String!
    let creationDate: Date!
    
    init() {
        commenter = ""
        commenterId = ""
        content = ""
        commentId = ""
        creationDate = Date()
    }
    
    init(commenter: String, commenterId: String, content: String, commentId:String, creationDate:Date){
        self.commenter = commenter
        self.commenterId = commenterId
        self.content = content
        self.commentId = commentId
        self.creationDate = creationDate
    }
    init(snapshot: DocumentSnapshot){
        
        if let tempCommenter = snapshot["commenter"] as? String{
            commenter = tempCommenter
        }else{
            commenter = ""
        }
        if let tempCommenterId = snapshot["commenterId"] as? String{
            commenterId = tempCommenterId
        }else{
            commenterId = ""
        }
        if let tempContent = snapshot["content"] as? String{
            content = tempContent
        }else{
            content = ""
        }
        if let tempCommentId  = snapshot["commentId"] as? String{
            commentId = tempCommentId
        }else{
            commentId = ""
        }
        if let tempCreationDate = snapshot["creationDate"] as? Date{
            creationDate = tempCreationDate
        }else{
            creationDate = Date()
        }
    }
    
    func toAnyObject() -> Any{
        return ["commenter": commenter, "commenterId": commenterId, "content": content, "commentId":commentId, "creationDate":creationDate]
    }
    
}


class localComment {
    
    let commenter: String!
    let commenterId: String!
    let content: String!
    let commentId: String!
    let creationDate: Date!
    var profileImage: UIImage!
    
    init(snapshot: DocumentSnapshot){
        
        if let tempCommenter = snapshot["commenter"] as? String{
            commenter = tempCommenter
        }else{
            commenter = ""
        }
        if let tempCommenterId = snapshot["commenterId"] as? String{
            commenterId = tempCommenterId
        }else{
            commenterId = ""
        }
        if let tempContent = snapshot["content"] as? String{
            content = tempContent
        }else{
            content = ""
        }
        if let tempCommentId  = snapshot["commentId"] as? String{
            commentId = tempCommentId
        }else{
            commentId = ""
        }
        if let tempCreationDate = snapshot["creationDate"] as? Date{
            creationDate = tempCreationDate
        }else{
            creationDate = Date()
        }
        profileImage = UIImage.init()
    }
}
