//
//  FeedPostInteractionsTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/26/22.
//

import UIKit
class FeedInteractionTableViewCellModel {
    let commentText: String
    let username: String
    let profilePic: String?

    init(comment: String, owner: String, picture: String?) {
        self.commentText = comment
        self.username = owner
        self.profilePic = picture
    }
}

///comments
class FeedPostInteractionsTableViewCell: UITableViewCell {

    static let identifier = "FeedPostInteractionsTableViewCell"
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "AppDarkGray")
        textView.text = "I like your post! "
        textView.font = .systemFont(ofSize: 17)
        return textView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Joe Smith"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "AppDarkGray")
        contentView.addSubview(commentTextView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(profileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: FeedInteractionTableViewCellModel){
        usernameLabel.text = viewModel.username
        commentTextView.text = viewModel.commentText
        if let ref = viewModel.profilePic {
            // Fetch image
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data:data)
                    }
                }
                task.resume()
            }
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bioSize = commentTextView.sizeThatFits(frame.size)
        let size = (width/7) - 10
        profileImageView.layer.cornerRadius = size/2.0
        profileImageView.frame = CGRect(x: 5, y: 10, width: size, height: size).integral
        usernameLabel.frame = CGRect(x: profileImageView.right + 5, y: 5, width: width - 10, height: size/2)
        commentTextView.frame = CGRect(x: profileImageView.right + 5, y: usernameLabel.bottom, width: width - 20, height: bioSize.height)
    }

}
