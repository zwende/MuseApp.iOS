//
//  FeedPostTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/26/22.
//

import UIKit

class FeedPostTableViewCellModel {
    let postText: String

    init(title: String) {
        self.postText = title
    }
}

final class FeedPostTableViewCell: UITableViewCell {
    
    static let identifier = "FeedPostTableViewCell"
    
    private let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "AppDarkGray")
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 17)
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "AppDarkGray")
        contentView.addSubview(postTextView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: FeedPostTableViewCellModel){
        postTextView.text = viewModel.postText
         
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bioSize = postTextView.sizeThatFits(frame.size)
        postTextView.frame = CGRect(x: 10, y: 5, width: width - 10, height: bioSize.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTextView.text = nil
    }



}
