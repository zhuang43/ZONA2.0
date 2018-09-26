//
//  FeedCell.swift
//  MII
//
//  Created by MacDouble on 8/22/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class FeedCell: UICollectionViewCell {

    var post: LocalPost?{
        didSet{
            guard let poster = post?.poster else {
                return
            }
            guard let cat = post?.categorie else {
                return
            }
            guard let title = post?.title else {
                return
            }
            guard let content = post?.content else {
                return
            }
            guard let numLike = post?.numLikes else {
                return
            }
            guard let numComment = post?.numComments else {
                return
            }
            guard let profileImageUrl = post?.profileImage else {
                return
            }
            guard let coverImageUrl = post?.coverUrl else {
                return
            }
            guard let coverImage = post?.coverimage else{
                return
            }
            guard let profileImage = post?.profileimage else{
                return
            }
            print(profileImageUrl)
            nameLabel.text = poster
            catLabel.text = cat
            titleLabel.text = title
            contentLabel.text = content
            likeLabel.text = "\(numLike)"
            commentLabel.text = "\(numComment)"
            coverImageView.image = coverImage
            profileImageView.image = profileImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(catLabel)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(cellBar)
        addSubview(likeIV)
        addSubview(commentIV)
        addSubview(likeLabel)
        addSubview(commentLabel)
        addSubview(coverImageView)
        addSubview(button)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 36, width: 36)
        profileImageView.layer.cornerRadius = 18
        nameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, height: 18, width: 100)
        catLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, height: 18, width: 100)
        titleLabel.anchor(top: catLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 0, paddingRight: -75, height: 20, width: 0)
        contentLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 10, paddingBottom: 0, paddingRight: -75, height: 20, width: 0)
        cellBar.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 1, paddingRight: -3, height: 1, width: 0)
        coverImageView.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: -8, height: 60, width: 60)
        commentIV.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: -8, height: 12, width: 12)
        commentLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: commentIV.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: -3, height: 12, width: 20)
        likeIV.anchor(top: topAnchor, left: nil, bottom: nil, right: commentLabel.leftAnchor, paddingTop: 13, paddingLeft: 0, paddingBottom: 0, paddingRight: -0.5, height: 12, width: 12)
        likeLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: likeIV.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: -3, height: 12, width: 20)
        button.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0, width: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    


    
    let profileImageView : CustomImageView = {
        let view = CustomImageView()
        view.image = #imageLiteral(resourceName: "boy")
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    let nameLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "大兄弟"
        templabel.font = UIFont.boldSystemFont(ofSize: 13)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let catLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "闲聊"
        templabel.font = UIFont.systemFont(ofSize: 13)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let titleLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "小心！已经有人中毒！在Costco买的鱼里竟然有活虫"
        templabel.font = UIFont.boldSystemFont(ofSize: 16)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    
    let contentLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "这只是一个测试用的信息，costco的热狗真的又便宜又好吃"
        templabel.font = UIFont.systemFont(ofSize: 14)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let cellBar: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.backgroundColor = UIColor.gray
        tempImageView.alpha = 0.3
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        //tempImageView.contentMode = UIViewContentMode.scaleAspectFit
        return tempImageView
    }()
    let likeIV: UIImageView = {
        let tempImageView = UIImageView.init(image:#imageLiteral(resourceName: "heart_black"))
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        //tempImageView.contentMode = UIViewContentMode.scaleAspectFit
        return tempImageView
    }()
    let likeLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "394"
        templabel.font = UIFont.systemFont(ofSize: 10)
        templabel.textAlignment = .right
        return templabel
    }()
    let commentIV: UIImageView = {
        let tempImageView = UIImageView.init(image: #imageLiteral(resourceName: "comment"))
        //tempImageView.contentMode = UIViewContentMode.scaleAspectFit
        return tempImageView
    }()
    let commentLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "544"
        templabel.font = UIFont.systemFont(ofSize: 10)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        templabel.textAlignment = .right
        return templabel
    }()
    let coverImageView: CustomImageView = {
        let tempImageView = CustomImageView()
        tempImageView.contentMode = UIViewContentMode.scaleAspectFill
        tempImageView.layer.cornerRadius = 5
        tempImageView.layer.masksToBounds = true
        return tempImageView
    }()
    let button: UIButton = {
        let button = UIButton()
        button.imageView?.backgroundColor = .clear
        return button
    }()
}



