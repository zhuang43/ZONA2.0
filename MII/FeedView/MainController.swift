//
//  MainController.swift
//  MII
//
//  Created by MacDouble on 8/7/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import Firebase
import UIKit





// change to local post
class MainController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{
    
    
    var localPosts: [LocalPost] = []
    var postTag = -1
    let refreshControl = UIRefreshControl()
    private var categorieTableView: UITableView!
    private var categorieList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.grayScale(percent: 0.03)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "cellId")

        self.navigationItem.title = "社区"
        print(UIDevice.current.systemVersion)
        
        setupTopBar()

        checkUserStatus()
        
        setupRefreshControl()


    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.localPosts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? FeedCell
        if indexPath.row < localPosts.count {
            cell?.post = localPosts[indexPath.row]
        }
        cell?.button.tag = indexPath.row
        cell?.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorie = categorieList[indexPath.row] as! String
        topBarCategorieButton.setTitle(categorie, for: .normal)
        fetchPosts(categorie: categorie, newhot: "new")
        categorieTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(categorieList[indexPath.row])"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel!.backgroundColor = UIColor.clear
        let view = UIView()
        view.backgroundColor = UIColor.theme_color
        cell.selectedBackgroundView? = view
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    

    
    
    
    
    
    
    
    func setupTopBar(){
        fetchCategorieList()
        categorieTableView = UITableView()
        categorieTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        categorieTableView.delegate = self
        categorieTableView.dataSource = self
        categorieTableView.layer.cornerRadius = 10
        categorieTableView.layer.borderWidth = 1
        categorieTableView.isHidden = true
        
        view.addSubview(categorieTableView)
        view.addSubview(topBarView)
        topBarView.addSubview(topBarCategorieButton)
        topBarView.addSubview(topBarNewButton)
        topBarView.addSubview(topBarHotButton)
        topBarView.addSubview(topBarArrowImageView)
        categorieTableView.anchor(top: topBarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right:nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 150, width: 80)
        topBarView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 40, width: 0)
        topBarCategorieButton.anchor(top: topBarView.topAnchor, left: topBarView.leftAnchor, bottom: topBarView.bottomAnchor, right: nil, paddingTop: 3, paddingLeft: 20, paddingBottom: -3, paddingRight: 0, height: 0, width: 0)
        topBarArrowImageView.anchor(top: topBarCategorieButton.centerYAnchor, left: topBarCategorieButton.rightAnchor, bottom: nil, right: nil, paddingTop: -7, paddingLeft: 1, paddingBottom: 0, paddingRight: 0, height: 14, width: 14)
        topBarHotButton.anchor(top: topBarView.topAnchor, left: nil, bottom: topBarView.bottomAnchor, right: topBarView.rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: -3, paddingRight: -10, height: 0, width: 0)
        topBarNewButton.anchor(top: topBarView.topAnchor, left: nil, bottom: topBarView.bottomAnchor, right: topBarHotButton.leftAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: -3, paddingRight: -10, height: 0, width: 0)
        if (collectionView?.contentInset.top == 0){
            collectionView?.contentInset = UIEdgeInsets.init(top: 40, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func checkUserStatus(){
        if Auth.auth().currentUser == nil {
            print("nil user, forwarding to sigh in page")
            navigationController?.pushViewController(LoginController(), animated: true)
        }else{
            fetchPosts(categorie: "综合", newhot: "new")
            fetchUser()
        }
    }
    
    func fetchPosts(categorie: String, newhot: String){
        self.localPosts = []
        var ref: Query
        print("Fetching posts in \(categorie)")
        if(categorie == "综合"){
            if(newhot == "new"){
                ref = Firestore.firestore().collection("Posts").order(by: "creationDate", descending: true)
            }else{
                ref = Firestore.firestore().collection("Posts").order(by: "numLikes", descending: true)
            }
        }else{
            if(newhot == "new"){
                ref = Firestore.firestore().collection("Posts").whereField("cat", isEqualTo: categorie)
            }else{
                ref = Firestore.firestore().collection("Posts").whereField("cat", isEqualTo: categorie).order(by: "numLikes", descending: true)
            }
        }
        ref.getDocuments { (snapshots, error) in
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
                    self.collectionView?.layoutIfNeeded()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func fetchCoverImages(localPost: LocalPost) {
        guard let postId = localPost.postId else{return}
        var coverImage = UIImage.init()
        let storageRef = Storage.storage().reference().child("nana-cover-photo").child("\(postId).jpeg")
        storageRef.getData(maxSize: 1024*1024*1024*10) { (data, Error) in
            if let error = Error {
                print("Failed to fetch cover image")
            } else {
                if let imageData = data as Data? {
                    coverImage = UIImage(data: imageData)!
                }
            }
            localPost.coverimage = coverImage
            DispatchQueue.main.async {
            //    self.collectionView?.reloadData()
            }
        }
    }
    
    func fetchProfileImages(localPost: LocalPost) {
        guard let posterId = localPost.addedBy else{return}
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
            localPost.profileimage = profileImage
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func fetchCategorieList(){
        Firestore.firestore().collection("Configs").document("Variables").getDocument { (Document, Error) in
            if let error = Error {
                print("Failed to fetch categorie list, ", error)
                return
            }
            if let document = Document {
                self.categorieList = document["Categories"]! as! Array
                self.categorieList.insert("综合", at: 0)
            }
            DispatchQueue.main.async {
                self.categorieTableView.reloadData()
            }
        }
    }

    func setupRefreshControl(){
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.alwaysBounceVertical = true
    }
    
    
    
    
    
    @objc func refreshCollectionView(){
        localPosts = []
        fetchPosts(categorie: (topBarCategorieButton.titleLabel?.text)!, newhot: "new")
    }
    
    @objc func handleTopBarCategorieButton(){
        categorieTableView.isHidden = false
    }

    @objc func buttonClicked(sender: UIButton){
        print(sender.tag)
        postTag = sender.tag
        let feedDetailController = FeedDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        //_____________________
        feedDetailController.tempPost = localPosts[sender.tag]
        self.navigationController?.pushViewController(feedDetailController, animated: true)
    }
    
    
    
    
    let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.2
        return view
    }()
    let topBarCategorieButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("综合", for: .normal)
        button.addTarget(self, action: #selector(handleTopBarCategorieButton), for: .touchUpInside)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        return button
    }()
    let topBarArrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "arrow_down")
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    let topBarNewButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("最新", for: .normal)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    let topBarHotButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("最热", for: .normal)
        button.tintColor = UIColor.lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    
}



