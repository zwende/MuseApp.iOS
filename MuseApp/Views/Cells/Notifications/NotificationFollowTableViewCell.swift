//
//  NotificationFollowTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/12/22.
//

import UIKit

protocol NotificationFollowTableViewCellDelegate: AnyObject{
    func didTapNotificationFollowUnfollowButton(model:UserNotifications)
}

class NotificationFollowTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationFollowTableViewCell"
    //Part 11 - followbutton 31:30
    
    weak var delegate: NotificationFollowTableViewCellDelegate?
        
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
        label.text = "joesmith followed you"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "love"), for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(profileImageView)
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        selectionStyle = .none
        configureFollow()

    }
    
    @objc private func didTapFollowButton(){
        guard let model = model else {
            return
        }
        
        delegate?.didTapNotificationFollowUnfollowButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotifications ){
        self.model = model
        switch model.type {
        case .like(_):
            break
        case .comment(_):
            break
        case .follow(let state):
            switch state {
                case .following: //show unfollow
                    configureFollow()
                case .not_following: //show follow
                    followButton.setTitle("Follow", for: .normal)
                    followButton.backgroundColor = UIColor(named: "AppYellow")
                    followButton.setTitleColor(UIColor(named: "AppDarkGray"), for: .normal)
            }
        }
        label.text = model.text
        //profileImageView.sd_setImage(with: model.user.profilePicture, completed: nil)
    }
    
    private func configureFollow(){
        followButton.setTitle("Unfollow", for: .normal)
        followButton.backgroundColor = UIColor(named: "AppDarkGray")
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = CGColor(red: 255/255, green: 198/255, blue: 41/255, alpha: 1)
        followButton.setTitleColor(UIColor(named: "AppYellow"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        followButton.setBackgroundImage(nil, for: .normal)
        label.text = nil
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6).integral
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size = contentView.height - 4
        
        let buttonWidth = contentView.width > 500 ? 250 : contentView.width/4
        followButton.frame = CGRect(x: contentView.width - 5 - buttonWidth, y: 5, width: buttonWidth, height: contentView.height - 10)
        followButton.layer.cornerRadius = 2
        label.frame = CGRect(x: profileImageView.right + 5,
                             y: 0,
                             width: contentView.width-size-profileImageView.width - 16,
                             height: contentView.height)
    }

}
