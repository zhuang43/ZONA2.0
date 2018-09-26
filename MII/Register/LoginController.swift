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


let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.borderStyle = .roundedRect
    tf.backgroundColor = UIColor.grayScale(percent: 0.02)
    tf.autocapitalizationType = UITextAutocapitalizationType.none
    return tf
    
}()

let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor.grayScale(percent: 0.02)
    return tf
}()

let headingContainer: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.theme_color
    return view
}()

let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Login", for: .normal)
    
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.backgroundColor = UIColor.theme_color_alpha(percent: 0.9)
    return button 
}()

let signupButton: UIButton = {
    let button = UIButton(type: .system)
    let title = NSMutableAttributedString(string: "Don't have an account?", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.grayScale(percent: 0.3)])
    title.append(NSMutableAttributedString(string: " Sign Up!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14 ), NSAttributedStringKey.foregroundColor:UIColor.theme_color_alpha(percent: 1)]))
    button.setAttributedTitle(title, for: .normal)

    return button
}()



class LoginController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //add selector
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        //view setup
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true


        //add subview
        view.addSubview(headingContainer)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        //anchors
        headingContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200, width: 0)
        emailTextField.anchor(top: headingContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        loginButton.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: -30, height: 40, width: 0)
        signupButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: -30, paddingRight: -30, height: 0, width: 0)
    }
    
    
    @objc func handleSignup(){
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let err = error{
                print("Unable to signin, ", err)
            }else{
                let mainTabBarController = MainTabBarController()
                self.present(mainTabBarController, animated: true, completion: nil)
            }
        })
        
        
        
    }
    
    
    
}


