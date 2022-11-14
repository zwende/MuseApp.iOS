//
//  PostCollectionViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/3/22.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    //PART 8, PhotoCollectionViewCell
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "AppDarkGray")
        contentView.clipsToBounds = true
        addSubview(usernameLabel)
        addSubview(profileImageView)
        addSubview(postTextView)
    }
    
    private let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "AppDarkGray")
        textView.textColor = .white
//        textView.text = "Hello! This is my first post. I am from Argentina and I am a CS major"
        textView.font = .systemFont(ofSize: 17)
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
//        label.text = "zoewende"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bioSize = postTextView.sizeThatFits(frame.size)
        let size = (width/10) - 10
        postTextView.frame = CGRect(x: 10, y: profileImageView.bottom + size + 30, width: width - 10, height: bioSize.height)
        profileImageView.layer.cornerRadius = size/2.0
        profileImageView.frame = CGRect(x: 5, y: 10, width: size, height: size).integral
        usernameLabel.frame = CGRect(x: profileImageView.right + 5, y: 5, width: width - 10, height: 50)
    }
    
    public func configure(with model: User){
        usernameLabel.text = model.username
        profileImageView.image = UIImage(contentsOfFile: model.profilePicture ?? " ")
        //profileImageView.sd_setImage(with: model.profilePicture, completed: nil)
         
    }
//    func configure(with model: PostRenderViewModel)) {
//        usernameLabel.text = model.renderType.
//
//        if let data = viewModel.imageData {
//            postImageView.image = UIImage(data: data)
//        }
//        else if let url = viewModel.imageUrl {
//            // Fetch image & cache
//            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
//                guard let data = data else {
//                    return
//                }
//
//                viewModel.imageData = data
//                DispatchQueue.main.async {
//                    self?.postImageView.image = UIImage(data: data)
//                }
//            }
//            task.resume()
//        }
//    }
    
    
}
