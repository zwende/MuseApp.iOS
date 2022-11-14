//
//  NotificationLikeTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/7/22.
//

import SDWebImage
import UIKit

protocol NotificationLikeTableViewCellDelegate: AnyObject{
    func didTapNotificationPostButton(model:UserNotifications)
}

class NotificationLikeTableViewCell: UITableViewCell {
    
    //Part 11 - followbutton 31:30

    static let identifier = "NotificationLikeTableViewCell"
    
    weak var delegate: NotificationLikeTableViewCellDelegate?
    
    private var model: UserNotifications?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "contact")
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "UserTest liked your post"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let new: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "UserTest liked your post"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "love"), for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(profileImageView)
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    @objc private func didTapPostButton(){
        guard let model = model else {
            return
        }
        
        delegate?.didTapNotificationPostButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotifications ){
        self.model = model
        switch model.type {
        case .like(let post):
            let postNotification = post.identifier
//            guard !postNotification.absoluteString.contains("google.com") else {
//                return
//            }
//            postButton.sd_setBackgroundImage(with: postNotification, for: .normal, completed: nil)
            break
        case .comment(_):
            break
        case .follow:
            break
        }
        label.text = model.text
       // profileImageView.sd_setImage(with: model.user.profilePicture, completed: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postButton.setBackgroundImage(nil, for: .normal)
        label.text = nil
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6).integral
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size = contentView.height - 4
        
        postButton.frame = CGRect(x: contentView.width - size - 5, y: 2, width: size, height: size)
        postButton.layer.cornerRadius = 4
        label.frame = CGRect(x: profileImageView.right + 5,
                             y: 0,
                             width: contentView.width-size-profileImageView.width - 16,
                             height: contentView.height)
    }

}
