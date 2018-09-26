//
//  FeedDetailToolBarCell.swift
//  MII
//
//  Created by MacDouble on 9/5/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//
import UIKit

class FeedDetailToolBarCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let label: UILabel = {
        let templabel = UILabel()
        templabel.text = "评论"
        templabel.font = UIFont.boldSystemFont(ofSize: 13)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let label2: UILabel = {
        let templabel = UILabel()
        templabel.text = "喜欢"
        templabel.font = UIFont.boldSystemFont(ofSize: 13)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let numCommentLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "0"
        templabel.font = UIFont.systemFont(ofSize: 13)
        templabel.sizeToFit()
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    let numLikeLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "0"
        templabel.font = UIFont.systemFont(ofSize: 14)
        templabel.sizeToFit()
        
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()

    func setupViews(){
        addSubview(label)
        addSubview(label2)
        addSubview(numCommentLabel)
        addSubview(numLikeLabel)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 35, paddingLeft: 15, paddingBottom: 10, paddingRight: 0, height: 15, width: 0)
        numCommentLabel.anchor(top: label.topAnchor, left: label.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 0, height: 15, width: 0)
        label2.anchor(top: label.topAnchor, left: numCommentLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 0, height: 15, width: 0)
        numLikeLabel.anchor(top: label.topAnchor, left: label2.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 10, paddingRight: 0, height: 15, width: 0)

        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
