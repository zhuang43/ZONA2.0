
import UIKit
import Firebase

var keyboardHeight = 0

class AddPostController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var attributedString :NSMutableAttributedString!
    
    private var categorieList: NSArray = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        titleTextfield.delegate = self
        contentTextfield.delegate = self
        titleTextfield.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        setupNavigationBar()
        setupView()
        fetchCategorieList()
    }
    
    private var categorieTableView: UITableView!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseCategorieButton.setTitle(categorieList[indexPath.row] as! String, for: .normal)
        categorieTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(categorieList[indexPath.row])"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel!.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.rgb(red: 249, green: 224, blue: 233, alpha: 1)
        let view = UIView()
        view.backgroundColor = UIColor.theme_color
        cell.selectedBackgroundView? = view
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func setupView(){
        
        //tableview
        categorieTableView = UITableView()
        categorieTableView.layer.cornerRadius = 10
        categorieTableView.backgroundColor = UIColor.rgb(red: 249, green: 224, blue: 233, alpha: 1)
        categorieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        categorieTableView.dataSource = self
        categorieTableView.delegate = self
        
        //ADD SUBVIEW
        view.addSubview(titleTextfield)
        view.addSubview(contentTextfield)
        navigationController?.view.addSubview(holdView)
        holdView.addSubview(holdMessage)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(addImageButton)
        bottomBarView.addSubview(chooseCategorieButton)
        view.addSubview(categorieTableView)
        categorieTableView.isHidden = true

        
       //add gesture recognize
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        holdView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        holdMessage.anchor(top: holdView.centerYAnchor, left: holdView.centerXAnchor, bottom: nil, right: nil, paddingTop: -30, paddingLeft: -100, paddingBottom: 0, paddingRight: 0, height: 20, width: 200)
        
        
        //ADD ANCHOR
        if #available(iOS 11.0, *) {
            titleTextfield.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 35, width: 0)
        } else {
            titleTextfield.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 35, width: 0)

        }
        contentTextfield.anchor(top: titleTextfield.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300, width: 0)
        
        bottomBarView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 40, width: 0)
        addImageButton.anchor(top: bottomBarView.centerYAnchor, left: nil, bottom: nil, right: bottomBarView.rightAnchor, paddingTop: -14, paddingLeft: 0, paddingBottom: 0, paddingRight: -10, height: 28, width: 28)
        chooseCategorieButton.anchor(top: bottomBarView.topAnchor, left: nil, bottom: nil, right: addImageButton.leftAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: -20, height: 34, width: 0)
        categorieTableView.anchor(top:nil, left:nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -43, paddingRight: -30, height: 120, width: 100)
    }
    
    func fetchCategorieList(){
        Firestore.firestore().collection("Configs").document("Variables").getDocument { (Document, Error) in
            if let error = Error {
                print("Failed to fetch categorie list, ", error)
                return
            }
            if let document = Document {
                self.categorieList = document["Categories"]! as! NSArray
            }
            DispatchQueue.main.async {
                self.categorieTableView.reloadData()
            }
        }
    }
    
    func setupNavigationBar(){
        navigationItem.title = "新的帖子"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(handleAddPost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if var originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{

            let compressedImage = originalImage.resizedTo1MB()
            let textAttachment = NSTextAttachment()
            textAttachment.image = compressedImage
            
            let oldWidth = (compressedImage?.size.width)!
            var scaleFactor: CGFloat = 1
            if oldWidth > (contentTextfield.frame.size.width - 10){
                scaleFactor = oldWidth / (contentTextfield.frame.size.width - 40)
            }
            textAttachment.image = UIImage(cgImage: (compressedImage?.cgImage)!, scale: scaleFactor, orientation: .up)
            
            attributedString = NSMutableAttributedString(attributedString:contentTextfield.attributedText)
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.append(attrStringWithImage)
            contentTextfield.attributedText = attributedString;
            contentTextfield.font = UIFont.systemFont(ofSize: 15)
            
        }
    
        
        self.dismiss(animated: true, completion: {
            self.contentTextfield.becomeFirstResponder()
        })
    }
    
    
    
    @objc func dismissView(){
        print("tapped")
        UIView.animate(withDuration: 0.4, animations: {
            self.fadeOut()
            self.categorieTableView.isHidden = true
        })

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "请输入您的内容" || textView.text == "请输入标题" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        self.categorieTableView.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == titleTextfield{
            textView.text = "请输入标题"
            }else{
                textView.text = "请输入您的内容"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    @objc func keyboardShown(notification: NSNotification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(keyboardFrame.height)
        bottomBarView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -keyboardFrame.height)
        categorieTableView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -keyboardFrame.height)
    }
    
    @objc func handleCancel(){
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func handleAddPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleChooseCategorieButton(){
        UIView.animate(withDuration: 0.5, animations: {
            self.categorieTableView.isHidden = false
            self.categorieTableView.isUserInteractionEnabled = true
        })
    }
    
    @objc func handleAddPost(){
        
        let alert = UIAlertController(title: "发现一个问题！", message: "👻👻👻👻", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "返回", style: UIAlertActionStyle.cancel) { (action) in
            self.dismissView()
        }
        alert.addAction(cancelAction)

        
        if titleTextfield.text == "" {
            alert.message = "标题不可以是空的 🙅‍♂️"
            self.present(alert, animated: true)
        }else{
            if (contentTextfield.text.count <= 10){
                alert.message = "字数不可以少于10字噢 🙅‍♂️"
                self.present(alert, animated: true)
            }else{
                if((chooseCategorieButton.titleLabel?.text)!=="选择板块"){
                    alert.message = "请选择发布板块 🤔"
                    self.present(alert, animated: true)
                    return
                }
                
                //animation
                UIView.animate(withDuration: 0.5, animations: {
                    self.holdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    self.holdMessage.isHidden = false
                    self.contentTextfield.endEditing(true)
                    self.titleTextfield.endEditing(true)
                })

                //Generate Attributed String Generate Attributed String Generate Attributed String
                var coverPhoto =  UIImage.init()
                attributedString = NSMutableAttributedString(attributedString:contentTextfield.attributedText)
                contentTextfield.attributedText = attributedString;
                let finalAttributedString = contentTextfield.attributedText
                
                //-----------------------------look for first image---------------------------------------------------
                finalAttributedString?.enumerateAttribute(NSAttributedStringKey.attachment, in: NSRange(location: 0, length: (finalAttributedString?.length)!), options: []) { (value, range, stop) in
                    if (value is NSTextAttachment){
                        let attachment: NSTextAttachment? = (value as? NSTextAttachment)
                        coverPhoto = (attachment?.image(forBounds: (attachment?.bounds)!, textContainer: nil, characterIndex: range.location))!
                        print(NSData(data: UIImageJPEGRepresentation(coverPhoto, 1)!).length)
                        //return
                    }
                }

                //--------------------------------------------------------------------------------------------------------------
                let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.rtfd]
                //_@#$%^&*()_(*&^%#$%^&*()_+
                let data: Data = try! finalAttributedString!.data(from: NSRange(location: 0, length: attributedString.length), documentAttributes: documentAttributes)
                print(data.count)
                let uid = String(Int(100000000000-Date().timeIntervalSince1970))+NSUUID().uuidString
                let newPost = Post.init(postId: uid, profileImage: currentUser.profileImage, title: titleTextfield.text, content: contentTextfield.text, poster: currentUser.socialName, categorie: (self.chooseCategorieButton.titleLabel?.text)!, addedBy: (Auth.auth().currentUser?.uid)!, numLikes: 0, numComments: 0, coverUrl: "123", contentUrl: "123", creationDate: Date())

               
                Firestore.firestore().collection("Posts").document(uid).setData(newPost.toAnyObject() as! [String: Any]) { (error) in
                    if let err = error{
                        print(err)
                        return
                    }else{
                        print("database")
                        self.uploadContent(uid:uid,data: data, coverPhoto: coverPhoto)
                    }
                }
            }
        }
    }
    
    func uploadCoverPhoto(uid: String, coverPhoto: UIImage){
        
        // upload coverPhoto
        let coverPhotoRef = Storage.storage().reference().child("nana-cover-photo").child("\(uid).jpeg")
        let coverData = UIImageJPEGRepresentation(coverPhoto, 0.2)
        if let uploadData = coverData{
            coverPhotoRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("\n Failed to upload \n")
                    print(error)
                }else{
                    print("Finish")
                    self.finishUploading()
                }
            }
        }
    }
    
    func uploadContent(uid: String, data: Data, coverPhoto: UIImage){
        let storageRef = Storage.storage().reference().child("nana-content").child("\(uid)")
        if let uploadData = data as? Data{
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("\n Failed to upload \n")
                    print(error)
                    return
                }else{
                    print("uploading content")
                    if(coverPhoto.size.width == 0){
                        self.finishUploading()
                    }else{
                        self.uploadCoverPhoto(uid: uid, coverPhoto: coverPhoto)
                    }
                }
            }
        }
    }
    
    func fadeIn(){
        self.holdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.holdView.isUserInteractionEnabled = true
    }
    
    func fadeOut(){
        self.holdView.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.holdView.isUserInteractionEnabled = false
    }
    
    func finishUploading(){
        self.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: {
            self.holdView.isHidden = true
        })
        holdMessage.isHidden = true
        self.tabBarController?.selectedIndex = 0
        titleTextfield.text = "请输入标题"
        titleTextfield.textColor = UIColor.lightGray
        contentTextfield.text = "请输入您的内容"
        contentTextfield.textColor = UIColor.lightGray
    }
    
    
    
    let holdView: UIView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let holdMessage: UILabel = {
        let label = UILabel()
        label.text = "正在努力上传💪..."
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    var titleTextfield: UITextView = {
        let tf = UITextView()
        tf.text = "请输入标题"
        tf.textColor = UIColor.lightGray
        tf.font = UIFont.boldSystemFont(ofSize: 19)
        tf.textContainer.maximumNumberOfLines = 1
        tf.contentInset = UIEdgeInsetsMake(0, 4, 0, 4)
        return tf
    }()
    
    var contentTextfield: UITextView = {
        let tf = UITextView()
        tf.text = "请输入您的内容"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.contentInset = UIEdgeInsetsMake(0, 4, 0, 4)
        tf.textColor = UIColor.lightGray
        return tf
    }()
    
    var bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayScale(percent: 0.04)
        return view
    }()
    
    var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "black_photo"), for: .normal)
        button.tintColor = .grayScale(percent: 0.55)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    var chooseCategorieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择板块", for: .normal)
        button.addTarget(self, action: #selector(handleChooseCategorieButton), for: .touchUpInside)
        button.tintColor = UIColor.grayScale(percent: 0.55)
        return button
    }()
    

}


