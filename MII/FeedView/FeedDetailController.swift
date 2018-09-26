//
//  FeedDetailController.swift
//  MII
//
//  Created by MacDouble on 8/24/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"




class FeedDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedDetailContentCellDelegate {

    
    
    var tempPost: LocalPost!
    var comments:[localComment] = []
    
    var numLikes = 0
    var numComments = 0
    
    var liked = false
    var bookmarked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(FeedDetailContentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(FeedDetailToolBarCell.self, forCellWithReuseIdentifier: "ToolBarCell")
        collectionView?.register(FeedDetailCommentCell.self, forCellWithReuseIdentifier: "CommentCell")
        collectionView?.register(FeedDetailAddCommentCell.self, forCellWithReuseIdentifier: "AddCommentCell")
        collectionView?.backgroundColor = UIColor.white
        tabBarController?.tabBar.isHidden = true
        checkInteraction() // check if liked /bookmarked
        setupBottomBarView() //setup bottom add comment view
        fetchContent() // fetch content
        fetchComments()
        listeningToLikes()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "文章"

        collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        view.addSubview(bottomBarView)

        if #available(iOS 11.0, *) {
            bottomBarView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 50, width: 0)
        } else {
            bottomBarView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 50, width: 0)
        }
        

    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0){
            return CGSize(width: self.view.frame.width, height: feedDetailCellContentHeight)
        }else if(indexPath.row == 1){
            return CGSize(width: self.view.frame.width, height: 50)
        }else{
            let commentHeight = getLabelHeight(labeltext: comments[indexPath.row-2].content, labelWidth: self.view.frame.width-20, fontSize: 12, fontName: "System")
                return CGSize(width: view.frame.width, height: commentHeight+25+5)
        }

    }

    //VARIABLES FOR REDERING CELLS
    var feedDetailCellContent: NSMutableAttributedString?
    var feedDetailCellContentHeight: CGFloat = 50
    var imageHeight: CGFloat = 0
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedDetailContentCell
        let toolbarcell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolBarCell", for: indexPath) as? FeedDetailToolBarCell
        let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as? FeedDetailCommentCell

        cell?.post = self.tempPost
        cell?.delegate = self
        cell?.contentLabel.attributedText = feedDetailCellContent
        if(indexPath.row == 0){
            return cell!
        }else if(indexPath.row == 1){
            toolbarcell?.numLikeLabel.text = "\(numLikes)"
            toolbarcell?.numCommentLabel.text = "\(numComments)"
            return toolbarcell!
        }else{
            commentCell?.comment = self.comments[indexPath.row-2]
            return commentCell!
        }
    }
    
    
    
    
    
    
    
    
    
    // funcs
    func refreshComments(){
        self.comments = []
        fetchComments()
    }
    
    func setupBottomBarView(){
        
        if liked {
            likeButton.isEnabled = false
        }
        if bookmarked{
            bookmarkButton.isEnabled = false
        }
        
        bottomBarView.addSubview(maskView)
        bottomBarView.addSubview(profileImageView)
        bottomBarView.addSubview(textfieldLabel)
        bottomBarView.addSubview(button)
        bottomBarView.addSubview(likeButton)
        bottomBarView.addSubview(bookmarkButton)
        
        let profileImageViewWidth:CGFloat = 35
        
        
        profileImageView.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: profileImageViewWidth, width: profileImageViewWidth)
        
        bookmarkButton.anchor(top: bottomBarView.topAnchor, left: nil, bottom: bottomBarView.bottomAnchor, right: bottomBarView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: profileImageViewWidth)
        
        likeButton.anchor(top: bottomBarView.topAnchor, left: nil, bottom: bottomBarView.bottomAnchor, right: bookmarkButton.leftAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: profileImageViewWidth)
        textfieldLabel.anchor(top: bottomBarView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: likeButton.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: 0)
        button.anchor(top: bottomBarView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: likeButton.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: -10, paddingRight: -10, height: profileImageViewWidth, width: 0)
        
        maskView.anchor(top: bottomBarView.topAnchor, left: bottomBarView.leftAnchor, bottom: nil, right: bottomBarView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 100, width: 0)
        
    }
    
    func checkInteraction(){
        guard let postId = tempPost.postId else{return}
        Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).collection("InteractedPosts").document(postId).getDocument { (Snapshot, Error) in
            if Error != nil{
                print("Failed to check interaction")
                return
            }
        if let snap = Snapshot{
            self.liked = (snap["liked"] as? Int == 1)
            self.bookmarked = (snap["bookmarked"] as? Int == 1)
            print(self.liked, self.bookmarked)
        }
        DispatchQueue.main.async {
            self.setupBottomBarView()
        }
        }
    }
    
    func listeningToLikes(){
        Firestore.firestore().collection("Posts").document(tempPost.postId!).addSnapshotListener { (Snapshot, Error) in
            if let err = Error {
                print("Listening failed, ", err)
                return
            }
            let temp = Post(snapshot: Snapshot!)
            guard let numLikes = temp.numLikes else{return}
            guard let numComments = temp.numComments else{return}
            self.numComments = numComments
            self.numLikes = numLikes
            DispatchQueue.main.async {
                self.setupBottomBarView()
                self.collectionView?.reloadData()
            }
        }
    }

    func refreshCollectionView() {
        collectionView?.reloadData()
    }
    
    func fetchContent(){
        guard let postId = tempPost?.postId else{return}
        let dataRef = Storage.storage().reference().child("nana-content").child(postId)
        dataRef.getData(maxSize: 1024*1024*10) { (data, error) in
            if let error = error {
                print(error)
            } else {
                print("looping in getDate")
                let attributedString = try? NSMutableAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
                
                attributedString?.enumerateAttribute(NSAttributedStringKey.attachment, in: NSRange(location: 0, length: (attributedString?.length)!), options: []) { (value, range, stop) in
                    if (value is NSTextAttachment){
                        let attachment: NSTextAttachment? = (value as? NSTextAttachment)
                        print("attachment detected")
                        let fac = (attachment?.image(forBounds: (attachment?.bounds)!, textContainer: nil, characterIndex: range.location)?.size.height)!/(attachment?.image(forBounds: (attachment?.bounds)!, textContainer: nil, characterIndex: range.location)?.size.width)!
                        
                        attachment?.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: (UIScreen.main.bounds.width-20)*fac).integral
                        if ((attachment?.image) != nil) {
                            print("1 image attached")
                        }else{
                            print("No image attched")
                        }
                        self.imageHeight += (UIScreen.main.bounds.width)*fac
                    }
                }
                
                DispatchQueue.main.async {
                    self.feedDetailCellContent = attributedString
                    guard let contentText = self.tempPost.content else{return}
                    guard let titleText = self.tempPost.title else{return}
                    self.feedDetailCellContentHeight = getLabelHeight(labeltext: contentText, labelWidth: self.view.frame.width-20, fontSize: 14, fontName: "system") + self.imageHeight + getLabelHeight(labeltext: titleText, labelWidth: self.view.frame.width-20, fontSize: 18, fontName: "bold")+10+46+10+5+10
                    //-10-profilmaeIge(46)-10-title-5-content
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func fetchComments(){
    Firestore.firestore().collection("Posts").document(tempPost.postId).collection("Comments").getDocuments { (Snapshot, Error) in
            if let error = Error{
                print("Failed to load comments: ",error)
            }
            guard let snapshot = Snapshot else{return}
            for document in snapshot.documents{
                let comment = localComment(snapshot: document)
                self.fetchProfileImages(comment: comment)
                self.comments.append(comment)
            }
            DispatchQueue.main.async{
                self.collectionView?.reloadData()
            }
        }
    }
    
    func fetchProfileImages(comment: localComment) {
        guard let posterId = comment.commenterId else{return}
        var profileImage = UIImage.init()
        let storageRef = Storage.storage().reference().child("ProfileImage").child("\(posterId).jpeg")
        storageRef.getData(maxSize: 1024*1024*1024*10) { (data, error) in
            if error != nil {
                print("Failed to fetch profile image")
            } else {
                if let imageData = data as Data? {
                    profileImage = UIImage(data: imageData)!
                }
            }
            comment.profileImage = profileImage
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.collectionView?.layoutIfNeeded()
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    
    
    
    
    
    //OBJC FUNCTIONS
    //OBJC FUNCTIONS
    //OBJC FUNCTIONS

    
    @objc func handleLike(sender: UIButton){
        guard let postId = tempPost.postId else{return}
        
        let ref = Firestore.firestore().collection("Posts").document(postId)
        
        ref.updateData(["numLikes" : numLikes+1]) { (Error) in
            if let error = Error{
                print("Failed to like this post, ", error)
                return
            }
            Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).collection("InteractedPosts").document(postId).setData(["liked":1, "postId": postId], merge: true, completion: { (err) in
                if err != nil{
                    print("Failed to like post, ", err!)
                }
                self.likeButton.isEnabled = false
            })
            
            
        }

    }
    @objc func handleBookmark(sender: UIButton){
        guard let postId = tempPost.postId else{return}
        Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).collection("InteractedPosts").document(postId).setData(["bookmarked":1, "postId": postId], merge: true, completion: { (err) in
            if err != nil{
                print("Failed to bookmarl post, ", err!)
            }
            self.bookmarkButton.isEnabled = false
        })
        
        
    }
    @objc func addComment(){
        blackout.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        blackout.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blackout.addGestureRecognizer(tap)
        blackout.isHidden = false
        textView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.layer.cornerRadius = 10
        textView.becomeFirstResponder()
        send.setImage(UIImage(named: "send"), for: .normal)
        send.frame = CGRect(x: self.view.frame.width-40, y: self.view.frame.height, width: 30, height: 30)
        send.addTarget(self, action: #selector(uploadComment), for: .touchUpInside)
        self.view.addSubview(blackout)
        self.view.addSubview(textView)
        self.view.addSubview(send)
        UIView.animate(withDuration: 0.45, animations: {
            self.blackout.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.textView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
            self.send.frame = CGRect(x: self.view.frame.width-40, y: 160, width: 30, height: 30)
        })
    }
    
    @objc func dismissView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.textView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
            self.send.frame = CGRect(x: self.view.frame.width-40, y: self.view.frame.height, width: 30, height: 30)
        })
        UIView.animate(withDuration: 0.4, animations: {
            self.blackout.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        })
        blackout.isHidden = true
        self.view.endEditing(true)
    }
    
    @objc func uploadComment(){
        
        let uid = String(Int(100000000000-Date().timeIntervalSince1970))+NSUUID().uuidString
        let comment = Comment(commenter: currentUser.socialName, commenterId: (Auth.auth().currentUser?.uid)!, content: textView.text, commentId: uid, creationDate: Date())
        Firestore.firestore().collection("Posts").document(tempPost.postId).collection("Comments").document(uid).setData(comment.toAnyObject() as! [String : Any])
        
        guard let postId = tempPost.postId else{return}
        let ref = Firestore.firestore().collection("Posts").document(postId)
        
        ref.updateData(["numComments" : numComments+1]) { (error) in
            if error != nil{
                print("Failed to update comments count")
            }
            DispatchQueue.main.async {
                self.refreshComments()

            }
        }
        
        dismissView()
    }


    
    //Components
    //Components
    //Components

    let blackout = UIView()
    let textView = UITextView()
    let send = UIButton()
    
    let profileImageView: CustomImageView = {
        let profileImageView = CustomImageView()
        profileImageView.contentMode = UIViewContentMode.scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.layer.cornerRadius = 17.5
        profileImageView.image = currentUser_profileImgeView.image
        return profileImageView
    }()
    
    let textfieldLabel: UILabel = {
        let textfieldLabel = UILabel()
        textfieldLabel.text = "  点击添加您的评论"
        textfieldLabel.textAlignment = .left
        textfieldLabel.textColor = UIColor.grayScale(percent: 0.4)
        textfieldLabel.font = UIFont.systemFont(ofSize: 14)
        textfieldLabel.translatesAutoresizingMaskIntoConstraints = false
        textfieldLabel.layer.borderColor = UIColor.grayScale(percent: 0.3).cgColor
        textfieldLabel.layer.borderWidth = 1
        textfieldLabel.layer.cornerRadius = 17.5
        return textfieldLabel
    }()
    
    let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(#imageLiteral(resourceName: "heart_black"), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "heart_pink"), for: .disabled)
        likeButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return likeButton
    }()
    let button: UIButton = {
            let button = UIButton()
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(addComment), for: .touchUpInside)
            return button
    }()
    let bookmarkButton:UIButton = {
        let bookmarkButton = UIButton()
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_black"), for: .normal)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_pink"), for: .disabled)
        bookmarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        bookmarkButton.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        return bookmarkButton
    }()
    let maskView: UIView = {
        let maskView = UIView()
        maskView.backgroundColor = .white
       return maskView
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
        
    }()

}


