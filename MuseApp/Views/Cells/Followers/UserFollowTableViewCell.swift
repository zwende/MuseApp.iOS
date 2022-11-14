//
//  UserFollowTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/11/22.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationship)
}

enum FollowState{
    case following
    case not_following
}

struct UserRelationship{
    let username: String
    let type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {
    
    private var model: UserRelationship?
    
    weak var delegate : UserFollowTableViewCellDelegate?
    
    static let identifier = "UserFollowTableViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(followButton)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    @objc private func didTapFollowButton(){
        guard let model = model else {
            return
        }

        delegate?.didTapFollowUnfollowButton(model: model)
    }
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let size = contentView.height - 6
        
        profileImageView.frame = CGRect(x: 3, y: 3, width: size, height: size)
        profileImageView.layer.cornerRadius = profileImageView.height/2.0
        
        let buttonWidth = contentView.width > 500 ? 250 : contentView.width/3
        followButton.frame = CGRect(x: contentView.width - 5 - buttonWidth, y: 5, width: buttonWidth, height: contentView.height - 10)
        nameLabel.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width-3-profileImageView.width - buttonWidth, height: contentView.height)
        
    }
    
    public func configure(with model: UserRelationship){
        self.model = model
        nameLabel.text = model.username
        switch model.type {
            case .following:
                followButton.setTitle("Unfollow", for: .normal)
                followButton.backgroundColor = UIColor(named: "AppDarkGray")
                followButton.layer.borderColor = CGColor(red: 255/255, green: 198/255, blue: 41/255, alpha: 1)
                followButton.layer.borderWidth = 1
                followButton.setTitleColor(UIColor(named: "AppYellow"), for: .normal)
            case .not_following:
                followButton.setTitle("Follow", for: .normal)
                followButton.backgroundColor = UIColor(named: "AppYellow")
                followButton.setTitleColor(UIColor(named: "AppDarkGray"), for: .normal)
        }
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
