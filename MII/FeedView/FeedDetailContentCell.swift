import UIKit
import Firebase

protocol FeedDetailContentCellDelegate {
    func refreshCollectionView()
}


class FeedDetailContentCell: UICollectionViewCell{
    
    var delegate: FeedDetailContentCellDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = UIColor.white
        contentLabel.sizeThatFits(CGSize(width: frame.size.width, height: 1000))
        titleLabel.sizeThatFits(CGSize(width: frame.size.width, height: 1000))
    }

    let profileImageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.contentMode = UIViewContentMode.scaleAspectFill
        tempImageView.layer.masksToBounds = true
        tempImageView.layer.borderWidth = 0.5
        tempImageView.layer.borderColor = UIColor.darkGray.cgColor
        return tempImageView
    }()
    
    let nameLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "test"
        templabel.font = UIFont.boldSystemFont(ofSize: 15)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    
    let catLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "闲聊"
        templabel.font = UIFont.systemFont(ofSize: 13)
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    
    let titleLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "正在努力加载标题！！"
        templabel.font = UIFont.boldSystemFont(ofSize: 20)
        templabel.numberOfLines = 0
        templabel.sizeToFit()
        templabel.translatesAutoresizingMaskIntoConstraints = false
        return templabel
    }()
    
    let contentLabel: UILabel = {
        let templabel = UILabel()
        templabel.text = "正在努力加载文章内容！！"
        templabel.font = UIFont.systemFont(ofSize: 14)
        templabel.numberOfLines = 0
        templabel.sizeToFit()
        return templabel
    }()
    let creationDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textColor = UIColor.grayScale(percent: 0.5)
        return label
    }()
    
    var post: LocalPost?{
        didSet{
            guard let postId = post?.postId else {
                return
            }
            guard let poster = post?.poster else {
                return
            }
            guard let cat = post?.categorie else {
                return
            }
            guard let title = post?.title else {
                return
            }
            guard let content = post?.content else {
                return
            }
            guard let profileUrl = post?.profileImage else{
                return
            }
            guard let profileImage = post?.profileimage else{
                return
            }
            guard let creationDate = post?.creationDate else{
                return
            }

            nameLabel.text = poster
            catLabel.text = cat
            titleLabel.text = title
            contentLabel.text = content
            creationDateLabel.text = "\(creationDate)"
            profileImageView.image = profileImage

        }
    }

    
    func setupViews(){
        backgroundColor = . white
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(catLabel)
        addSubview(creationDateLabel)
        
        profileImageView.layer.cornerRadius = 23
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 46, width: 46)
        nameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 23, width: 0)
        catLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 23, width: 0)
        titleLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: -10, height: 0, width: 0)
        creationDateLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: -10, height: 0, width: 0)
        contentLabel.anchor(top: creationDateLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: -10, height: 0, width: 0)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

