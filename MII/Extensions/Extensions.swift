//
//  TextFieldExtensions.swift
//  MII
//
//  Created by MacDouble on 8/6/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//Global variables
var currentUser : User = User.init()
var currentUser_profileImgeView = CustomImageView()
func fetchUser(){
    guard let uid = Auth.auth().currentUser?.uid else{return}
    let ref = Firestore.firestore().collection("Users").document(uid)
    ref.getDocument { (snapshot, error) in
        if let err = error{
            print("Failed to fetch user, ",err)
        }
        if let snap = snapshot{
            currentUser = User(snapshot: snap)
            if let url = currentUser.profileImage{
                currentUser_profileImgeView.loadImage(urlString: url)
            }
        }
    }
}



extension UITextField {

}

extension UIColor {
    static var theme_color: UIColor { return UIColor.init(red: 217/255, green: 98/255, blue: 140/255, alpha: 1)}
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat,alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        
    }
    static func grayScale(percent: CGFloat) -> UIColor{
        let p = (1-percent)*255
        return UIColor.init(red: p/255, green: p/255, blue: p/255, alpha: 1)
    }
    static func theme_color_alpha(percent:CGFloat) -> UIColor{
        return UIColor.init(red: 217/255, green: 98/255, blue: 140/255, alpha: percent)
    }
    
}

extension UIView {
    func anchor(top:NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, height:CGFloat, width:CGFloat){
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1024 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.8),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1024.0 // ! Or devide for 1024 if you need KB but not kB
        }
        return resizingImage
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}


func getContentCellHeight(labeltext: String, labelWidth: CGFloat, fontSize: CGFloat, fontName: String, astring: NSMutableAttributedString) -> CGFloat{
    return getLabelHeight(labeltext: labeltext, labelWidth: labelWidth, fontSize: fontSize, fontName: fontName) + getAttributedStringHeight(astring: astring)
}

func getLabelHeight(labeltext: String, labelWidth: CGFloat, fontSize: CGFloat, fontName: String) -> CGFloat{
    let label = UILabel()
    label.text = labeltext
    label.translatesAutoresizingMaskIntoConstraints = false
    label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: 0)
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: fontSize)
    if(fontName == "bold"){
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    label.sizeToFit()
    return label.frame.height
}

func getAttributedStringHeight(astring: NSMutableAttributedString) -> CGFloat{
    let label = UILabel()
    label.attributedText = astring
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: 0)
    label.sizeToFit()
    return label.frame.height
}

