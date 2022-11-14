//
//  ProfileInfoHeaderCollectionReusableView.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/3/22.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderdidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderdidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)

}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    static let identifier = "ProfileInfoHeaderCollectionReusableView"

    //BACKGROUND IMAGE TEST - PART 8 5:52
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
//        label.text = "Test"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
//        label.text = "I am a test; this is my bio"
        label.numberOfLines = 0
        return label
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("Following", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonFunctions()
        backgroundColor = UIColor(named: "AppDarkGray")
        clipsToBounds = false
    }
    
    private func addButtonFunctions(){
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    @objc private func didTapFollowersButton(){
        delegate?.profileHeaderdidTapFollowersButton(self)
    }
    
    @objc private func didTapFollowingButton(){
        delegate?.profileHeaderdidTapFollowingButton(self)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = width/5
        profileImageView.layer.cornerRadius = size/2.0
        let bioSize = bioLabel.sizeThatFits(frame.size)
        let buttonWidth = (width - size) / 3
        
        profileImageView.frame = CGRect(x: 5, y: 10, width: size, height: size).integral
        followingButton.frame = CGRect(x:profileImageView.right + size, y: profileImageView.bottom - 30, width: buttonWidth, height: 20).integral
        followersButton.frame = CGRect(x:followingButton.right + 10, y: profileImageView.bottom - 30, width: buttonWidth, height: 20).integral
        usernameLabel.frame = CGRect(x: 10, y: profileImageView.bottom + 5, width: width - 10, height: 50)
        bioLabel.frame = CGRect(x: 10, y: usernameLabel.bottom + 5, width: width - 10, height: bioSize.height)
    }
    
    private func addSubviews(){
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(followersButton)
        addSubview(followingButton)
        
    }

}
