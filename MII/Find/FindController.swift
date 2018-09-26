//
//  MateFinderVC.swift
//  zona
//
//  Created by MacDouble on 6/1/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import UIKit
import Firebase

class FindController: UIViewController {
    
    var localUsers: [User] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "发现"
        view.backgroundColor = .white
        setupInitView()
        setupCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupInitView() {
        view.addSubview(cardButton)
        view.addSubview(hint)
        cardButton.anchor(top: view.centerYAnchor, left: view.centerXAnchor, bottom: nil, right: nil, paddingTop: -150, paddingLeft: -100, paddingBottom: 0, paddingRight: 0, height: 200, width: 200)
        hint.anchor(top: cardButton.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: -50, paddingBottom: 0, paddingRight: 0, height: 20, width: 100)
    }
    
    func setupCardView(){
        cardView.isHidden = true
        blackView.isHidden = true
        view.addSubview(blackView)
        view.addSubview(cardView)
        cardView.addSubview(profileImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(bioLabel)
        cardView.addSubview(acceptButton)
        cardView.addSubview(cardHintLabel)
        blackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0, width: 0)
        
        let cardWidth:CGFloat = UIScreen.main.bounds.width-60
        let cardHeight = cardWidth*4/3
        if #available(iOS 11.0, *) {
            cardView.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, left: view.centerXAnchor, bottom: nil, right: nil, paddingTop: -cardHeight/2, paddingLeft: -cardWidth/2, paddingBottom: 0, paddingRight: 0, height: cardHeight, width: cardWidth)
        } else {
            cardView.anchor(top: view.centerYAnchor, left: view.centerXAnchor, bottom: nil, right: nil, paddingTop: -cardHeight/2, paddingLeft: -cardWidth/2, paddingBottom: 0, paddingRight: 0, height: cardHeight, width: cardWidth)
        }
        nameLabel.anchor(top: cardView.centerYAnchor, left: cardView.leftAnchor, bottom: nil, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: -30, paddingBottom: 0, paddingRight: 30, height: 0, width: 0)
        bioLabel.anchor(top: nameLabel.bottomAnchor, left: cardView.leftAnchor, bottom: nil, right: cardView.rightAnchor, paddingTop: 15, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 0, width: 0)
        let profileImageWidth: CGFloat = cardHeight/2-30*2
        profileImageView.anchor(top: nil, left: cardView.centerXAnchor, bottom: nameLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: -profileImageWidth/2, paddingBottom: -30, paddingRight: 0, height: profileImageWidth, width: profileImageWidth)
        profileImageView.layer.cornerRadius = profileImageWidth/2
        acceptButton.anchor(top: bioLabel.bottomAnchor, left: cardView.centerXAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: -60, paddingBottom: 0, paddingRight: 0, height: 36, width: 120)
        cardHintLabel.anchor(top: nil, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: -8, paddingRight: -30, height: 0, width: 0)
    }

    
    @objc func handleCardButton(){
        
        Firestore.firestore().collection("Configs").document("Variables").getDocument(completion: { (Snapshot, Error) in
            if let err = Error {
                print("Listening failed, ", err)
                return
            }
            if let snapshot = Snapshot {
                let userCount = (snapshot.get("userCount"))! as! Int
                let randomUserIndex = Int(arc4random_uniform(UInt32(userCount)))+1
                Firestore.firestore().collection("Users").whereField("index", isEqualTo: randomUserIndex).getDocuments(completion: { (Snapshot, Error) in
                    if let error = Error{
                        print("Failed to fetch user, ",error)
                        return
                    }
                    self.localUsers = []
                    if let snapshot = Snapshot{
                        for document in snapshot.documents{
                            let user = User(snapshot: document)
                            self.localUsers.append(user)
                        }
                    }
                    DispatchQueue.main.async {
                        self.nameLabel.text = self.localUsers[0].socialName
                        self.bioLabel.text = self.localUsers[0].bio
                        self.profileImageView.loadImage(urlString: self.localUsers[0].profileImage)
                    }
                })
                
            }
        })
        
        cardView.center.x -= view.bounds.width
        UIView.animate(withDuration: 0.6, animations: {
                self.cardView.isHidden = false
                self.blackView.isHidden = false
                self.cardView.center.x += self.view.bounds.width
        })
        
    }
    
    
    let cardButton: UIButton = {
       let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "card-2"), for: .normal)
        view.addTarget(self, action: #selector(handleCardButton), for: .touchUpInside)
        return view
    }()
    let hint: UILabel = {
       let label = UILabel()
        label.text = "Tap card"
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    let profileImageView: CustomImageView = {
        let view = CustomImageView()
        view.image = #imageLiteral(resourceName: "tab_profile")
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "用户名"
        label.textAlignment = .center
        return label
    }()
    let bioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.text = "个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介"
        label.numberOfLines = 2
        return label
    }()
    let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.theme_color
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("了解一下", for: .normal)
        button.addTarget(self, action: #selector(handleCardButton), for: .touchUpInside)
        button.titleLabel?.textColor = UIColor.white
        return button
    }()
    let cardHintLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "每天只可认识一名同学噢"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    
}
