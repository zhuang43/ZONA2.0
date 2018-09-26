//
//  FeedDetailCommentCell.swift
//  MII
//
//  Created by MacDouble on 9/5/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//
import UIKit
class FeedDetailCommentCell: UICollectionViewCell{
    
    var comment:localComment?{
        didSet{
            guard let commenter = comment?.commenter else{return}
            guard let commenterId = comment?.commenterId else{return}
            guard let content = comment?.content else{return}
            guard let commentId = comment?.commentId else{return}
            guard let creationDate = comment?.creationDate else{return}
            guard let profileImage = comment?.profileImage else {return}

            
            nameLabel.text = comment?.commenter
            contentLabel.text = comment?.content
            profileImageView.image = profileImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let profileImageViewWidth:CGFloat = 35
    
    let profileImageView: CustomImageView = {
        let tempImageView = CustomImageView()
        tempImageView.contentMode = UIViewContentMode.scaleAspectFill
        tempImageView.layer.masksToBounds = true
        tempImageView.layer.borderWidth = 0.5
        tempImageView.layer.borderColor = UIColor.darkGray.cgColor
        tempImageView.layer.cornerRadius = 17.5
        return tempImageView
    }()

    
    let nameLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "test"
        templabel.font = UIFont.systemFont(ofSize: 15)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let contentLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "test"
        templabel.font = UIFont.systemFont(ofSize: 14)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        templabel.sizeToFit()
        templabel.numberOfLines = 0
        return templabel
    }()
    func setupViews(){

        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(contentLabel)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: profileImageViewWidth, width: profileImageViewWidth)
        nameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 15, width: 0)
        contentLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: -10, height: 0, width: 0)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


//
//  FeedDetailAddCommentCell.swift
//  MII
//
//  Created by MacDouble on 9/5/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//
import UIKit
class FeedDetailAddCommentCell: UICollectionViewCell{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    
    let profileImageViewWidth:CGFloat = 35
    
    let profileImageView: CustomImageView = {
        let tempImageView = CustomImageView()
        tempImageView.contentMode = UIViewContentMode.scaleAspectFill
        tempImageView.layer.masksToBounds = true
        tempImageView.layer.borderWidth = 0.5
        tempImageView.layer.borderColor = UIColor.darkGray.cgColor
        tempImageView.layer.cornerRadius = 17.5
        return tempImageView
    }()
    

    let contentLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "  点击添加您的评论"
        templabel.textAlignment = .left
        templabel.textColor = UIColor.grayScale(percent: 0.4)
        templabel.font = UIFont.systemFont(ofSize: 14)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        templabel.layer.borderColor = UIColor.grayScale(percent: 0.3).cgColor
        templabel.layer.borderWidth = 1
        templabel.layer.cornerRadius = 17.5
        return templabel
    }()
    
    let touchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        return button
    }()

    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "heart_black"), for: .normal)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "bookmark_black"), for: .normal)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        return button
    }()
    func setupViews(){

        addSubview(profileImageView)
        addSubview(contentLabel)
        contentLabel.addSubview(touchButton)
        addSubview(likeButton)
        addSubview(bookmarkButton)

        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: profileImageViewWidth, width: profileImageViewWidth)
        
        bookmarkButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: profileImageViewWidth)

        likeButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: bookmarkButton.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: profileImageViewWidth)
        contentLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: likeButton.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: 0)
        
        touchButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0, width: 0)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
