//
//  FeedUsernameHeaderTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/26/22.
//
import SDWebImage
import UIKit

class FeedUsernameHeaderTableViewCellModel {
    let title: String
    let imageUrl: String?

    init(title: String, imageUrl: String?) {
        self.title = title
        self.imageUrl = imageUrl
    }
}

///Header with Username and Profile Picture 
class FeedUsernameHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "FeedUsernameHeaderTableViewCell"
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "AppDarkGray")
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        prepareForReuse() 
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: FeedUsernameHeaderTableViewCellModel) {
//        print(viewModel.imageUrl)
        usernameLabel.text = viewModel.title
        
        if let ref = viewModel.imageUrl {
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
        let size = (width/7) - 10
        profileImageView.layer.cornerRadius = size/2.0
        profileImageView.frame = CGRect(x: 5, y: 10, width: size, height: size).integral
        usernameLabel.frame = CGRect(x: profileImageView.right + 5, y: 10, width: width - 10, height: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profileImageView.image = nil
        
    }


}
