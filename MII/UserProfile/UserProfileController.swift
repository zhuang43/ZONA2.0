//
//  UserProfileController.swift
//  MII
//
//  Created by MacDouble on 8/6/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import UIKit
import Firebase


let profileHeading : UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.theme_color_alpha(percent: 0.3)
    return view
}()

let profileThumbnail : UIImageView = {
    let view = UIImageView()
    view.image = #imageLiteral(resourceName: "tab_profile")
    view.layer.cornerRadius = view.frame.height/2
    view.layer.masksToBounds = true
    return view
}()

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let refreshControl = UIRefreshControl()

    var localPosts: [LocalPost] = []
    var bookmarkedLocalPosts: [LocalPost] = []
    var tabSelected = 0
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? UserProfileHeader
        profileTabLeftButton.addTarget(self, action: #selector(handleLeftButton), for: .touchUpInside)
        profileTabRightButton.addTarget(self, action: #selector(handleRightButton), for: .touchUpInside)
        
        return header!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postId", for: indexPath) as? FeedCell
        cell?.button.tag = indexPath.row
        cell?.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        if(tabSelected == 0){
            cell?.post = localPosts[indexPath.row]
        }else{
            cell?.post = bookmarkedLocalPosts[indexPath.row]
        }
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(tabSelected == 0){
            return localPosts.count
        }else{
            return bookmarkedLocalPosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 160)
    }

    let loginController = LoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        fetchBookmarkedPosts()
        setupRefreshControl()

        collectionView?.backgroundColor = UIColor.grayScale(percent: 0.03)
        collectionView?.alwaysBounceVertical = true

        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true

        //register
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "postId")
        
        //navigation
        navigationItem.title = "个人资料"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUserStatus()
        tabBarController?.tabBar.isHidden = false

    }
    
    
    
    
    
    
    
    
    
    
    
    func fetchPosts(){
        print("Fetching post")
        Firestore.firestore().collection("Posts").whereField("addedBy", isEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments { (snapshots, error) in
            if let err = error{
                print("Failed to fetchPosts", err)
                return
            }else{
                for document in snapshots!.documents{
                    let post = LocalPost(snapshot: document)
                    self.fetchCoverImages(localPost: post)
                    self.fetchProfileImages(localPost: post)
                    self.localPosts.append(post)
                }
                DispatchQueue.main.async{
                    self.collectionView?.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func fetchBookmarkedPosts(){
        let refInteractedPosts = Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).collection("InteractedPosts")
        let refPosts = Firestore.firestore().collection("Posts")
            
        refInteractedPosts.whereField("bookmarked", isEqualTo: 1).getDocuments { (Snapshot, Error) in
            if let error = Error{
                print("Failed to locate bookmarked posts: ", error)
            }
            for document in Snapshot!.documents{
                guard let postId = document["postId"] as? String else{return}
                refPosts.whereField("postId", isEqualTo: postId).getDocuments(completion: { (Snapshot, Error) in
                    if let error = Error{
                        print("Failed to fetch bookmarked posts: ", error)
                    }
                    for document in Snapshot!.documents{
                        let post = LocalPost(snapshot: document)
                        self.fetchCoverImages(localPost: post)
                        self.fetchProfileImages(localPost: post)
                        self.bookmarkedLocalPosts.append(post)
                    }
                })
            }
            DispatchQueue.main.async{
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func fetchCoverImages(localPost: LocalPost) {
        guard let postId = localPost.postId else{return}
        
        var coverImage = UIImage.init()
        let storageRef = Storage.storage().reference().child("nana-cover-photo").child("\(postId).jpeg")
        storageRef.getData(maxSize: 1024*1024*1024*10) { (data, error) in
            if let error = error {
                print("Failed to fetch cover image, ", error)
            } else {
                if let imageData = data as Data? {
                    coverImage = UIImage(data: imageData)!
                }
            }
            localPost.coverimage = coverImage
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.collectionView?.layoutIfNeeded()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func fetchProfileImages(localPost: LocalPost) {
        guard let posterId = localPost.addedBy else{return}
        var profileImage = UIImage.init()
        let storageRef = Storage.storage().reference().child("ProfileImage").child("\(posterId).jpeg")
        storageRef.getData(maxSize: 1024*1024*1024*10) { (data, error) in
            if let error = error {
                print("Failed to fetch profile image")
            } else {
                if let imageData = data as Data? {
                    profileImage = UIImage(data: imageData)!
                }
            }
            localPost.profileimage = profileImage
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.collectionView?.layoutIfNeeded()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func setupRefreshControl(){
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView?.alwaysBounceVertical = true
    }
    
    @objc func refreshCollectionView(){
        localPosts = []
        bookmarkedLocalPosts = []
        fetchPosts()
        fetchBookmarkedPosts()
        collectionView?.reloadData()
    }
    
    @objc func buttonClicked(sender: UIButton){
        print(sender.tag)
        let feedDetailController = FeedDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        //_____________________
        if(tabSelected == 0){
            feedDetailController.tempPost = localPosts[sender.tag]
        }else{
            feedDetailController.tempPost = bookmarkedLocalPosts[sender.tag]

        }
        self.navigationController?.pushViewController(feedDetailController, animated: true)
    }
    
    
    func checkUserStatus(){
        if Auth.auth().currentUser == nil {
            print("nil user, forwarding to sigh in page")
            navigationController?.pushViewController(loginController, animated: true)
        }
    }

    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.navigationController?.pushViewController(self.loginController, animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleLeftButton(){
        profileTabRightButton.tintColor = UIColor.grayScale(percent: 0.3)
        profileTabLeftButton.tintColor = .black
        tabSelected = 0
        collectionView?.reloadData()
    }
    
    @objc func handleRightButton(){
        tabSelected = 1
        profileTabLeftButton.tintColor = UIColor.grayScale(percent: 0.3)
        profileTabRightButton.tintColor = .black
        collectionView?.reloadData()
    }
    
}
