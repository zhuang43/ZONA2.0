//
//  UserProfileHeader.swift
//  MII
//
//  Created by MacDouble on 8/7/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import UIKit
import Firebase


let profileTabLeftButton : UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("我的发布", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    button.tintColor = .black
    button.imageView?.contentMode = .scaleAspectFit
    return button
}()
let profileTabRightButton : UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("我的收藏", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    button.tintColor = UIColor.grayScale(percent: 0.3)
    button.imageView?.contentMode = .scaleAspectFit
    return button
}()
class UserProfileHeader: UICollectionViewCell {
    private let profileImageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "boy")
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
  
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let bioLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        //fetch user
        if Auth.auth().currentUser != nil {
            fetchUser()
        }
        profileImageView.image = currentUser_profileImgeView.image

        //add subview
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        
        //Add Target

        //anchor-------------------------
        
        //profileImageView
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, height: 80, width: 80)
        profileImageView.clipsToBounds = true
        
        //labels
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 0, width: 0)
        bioLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 0, width: 0)

        
        //bottomToolBar
        setupBottomToolBar()
        
        
    }
    

    
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let ref = Firestore.firestore().collection("Users").document(uid)
        ref.getDocument { (snapshot, error) in
            if let err = error{
                print("Failed to fetch user, ",err)
            }
            if let snap = snapshot{
                let currentUser: User = User(snapshot: snap)
                self.setupView(user: currentUser)
            }
                
        }

    }
    //-----------header view ---------
    func setupView(user: User){
        usernameLabel.text = user.socialName
        bioLabel.text = user.bio

    }
    // -------tool bar-------
    func setupBottomToolBar(){
        let topDividerView : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.2)
            return view
        }()
        let bottomDividerView : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.2)
            return view
        }()
        
        let stackView = UIStackView(arrangedSubviews: [profileTabLeftButton,profileTabRightButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.layer.borderWidth = 0.8
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        //addSubView
        addSubview(stackView)
        addSubview(bottomDividerView)
        
        //addAnchor
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 40, width: 0)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0.6, width: 0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
