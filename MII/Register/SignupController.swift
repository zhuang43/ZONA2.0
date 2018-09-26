//
//  SignupController.swift
//  MII
//
//  Created by MacDouble on 8/6/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import UIKit
import Firebase


fileprivate let addPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
    button.tintColor = UIColor.darkGray
    button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
    button.imageView?.layer.masksToBounds = true
    return button
}()




let loginbackButton: UIButton = {
    let button = UIButton(type: .system)
    let title = NSMutableAttributedString(string: "Already have an account?", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.grayScale(percent: 0.3)])
    title.append(NSMutableAttributedString(string: " Login!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14 ), NSAttributedStringKey.foregroundColor:UIColor.theme_color_alpha(percent: 1)]))
    button.setAttributedTitle(title, for: .normal)
    return button
}()

let confirmPasswordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Confirm password"
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor.grayScale(percent: 0.02)
    return tf
}()


let heading: UILabel = {
    let label = UILabel()
    label.attributedText = NSMutableAttributedString(string: "Register", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 50), NSAttributedStringKey.foregroundColor:UIColor.theme_color_alpha(percent: 1)])
    return label
}()

let signupNextButton: UIButton = {
    let button = UIButton()
    button.setTitle("Next", for: .normal)
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.backgroundColor = UIColor.theme_color_alpha(percent: 0.9)
    return button
}()

let whiteBoard:UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
}()
let congratulation: UILabel = {
    let label = UILabel()
    label.text = "🎉 Congratulation 🎉"
    label.font = label.font.withSize(35)
    label.textAlignment = .center
    return label
}()

//-------class begin-------------
class SignupController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //view setup
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        //addTarget
        loginbackButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signupNextButton.addTarget(self, action: #selector(handleSignupNextButton), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(handleAddPhotoButton), for: .touchUpInside)
        
        //add subviews
        view.addSubview(addPhotoButton)
        view.addSubview(loginbackButton)
        view.addSubview(heading)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signupNextButton)
        view.addSubview(whiteBoard)
        view.addSubview(congratulation)
        whiteBoard.isHidden = true
        whiteBoard.alpha = 0
        
        //anchors
        loginbackButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: -30, paddingRight: -30, height: 0, width: 0)
        heading.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, height: 0, width: 0)
        addPhotoButton.anchor(top: heading.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: -65, paddingBottom: 0, paddingRight: -30, height: 130, width: 130)
        emailTextField.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        confirmPasswordTextField.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        signupNextButton.anchor(top: confirmPasswordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        
        //animations setup
        whiteBoard.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        congratulation.frame = CGRect(x: UIScreen.main.bounds.width/2-100, y: UIScreen.main.bounds.height, width: 200, height: 200)
        
  
    }
    @objc func handleLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddPhotoButton(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        addPhotoButton.imageView?.layer.cornerRadius = 65
        addPhotoButton.imageView?.layer.borderWidth = 2
        addPhotoButton.imageView?.layer.borderColor = UIColor.darkGray.cgColor
        
        self.dismiss(animated: true, completion: nil)
    }
    func updateUserCount(){
        Firestore.firestore().collection("Configs").document("Variables").getDocument(completion: { (Snapshot, Error) in
            if let err = Error {
                print("Listening failed, ", err)
                return
            }
            if let snapshot = Snapshot {
                let userCount = (snapshot.get("userCount"))! as! Int
                Firestore.firestore().collection("Configs").document("Variables").updateData(["userCount": userCount+1], completion: { (Error) in
                    if let error = Error{
                        print(error)
                    }
                    Firestore.firestore().collection("Users").document((Auth.auth().currentUser?.uid)!).updateData(["index": userCount+1], completion: { (Error) in
                        if let error = Error{
                            print(error)
                        }
                    })
                })
            }
        })
    }
    @objc func handleSignupNextButton(){
        
        guard let email = emailTextField.text else{return}
        guard let password = confirmPasswordTextField.text else{return}

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user,error) in
            if let err = error {
                print("Failed",err)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let image = addPhotoButton.imageView?.image else {return}
            guard let imageData = UIImageJPEGRepresentation(image, 0.3) else {return}
            Storage.storage().reference().child("ProfileImage").child("\(uid).jpeg").putData(imageData, metadata: nil, completion: { (metaData, error) in
                if let error = error {
                    print("Failed to upload photo")
                    return
                }
                if let uid = Auth.auth().currentUser?.uid {
                    Storage.storage().reference().child("ProfileImage").child("\(uid).jpeg").downloadURL(completion: { (url, error) in
                        guard let url = url else {return}
                        let metaDataUrl = url.absoluteString
                        let user = User.init(email: email, profileImage: metaDataUrl, nickName: "", socialName: "", bio: "", age: "", location: "", tag: "", sex: 3)
                        Firestore.firestore().collection("Users").document(uid).setData(user.toAnyObject() as! [String : Any], completion: { (error) in
                            if let err = error {
                                print("Failed to store user data ",err)
                                return
                            }
                            self.updateUserCount()
                        })
                    })
                }else{return}
            })
            
            whiteBoard.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                whiteBoard.alpha = 1
                congratulation.frame = CGRect(x: UIScreen.main.bounds.width/2-200, y: UIScreen.main.bounds.height/2-100, width: 400, height: 200)
            })
            
        })

        
    }
}

