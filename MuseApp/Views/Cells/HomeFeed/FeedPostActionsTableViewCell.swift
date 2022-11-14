//
//  FeedPostActionsTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/26/22.
//

import UIKit

protocol FeedPostActionsTableViewCellDelegate: AnyObject{
    func didTapLikeButton()
    func didTapCommentButton()
    func didTapShareButton()
}

///actions
class FeedPostActionsTableViewCell: UITableViewCell {

    weak var delegate : FeedPostActionsTableViewCellDelegate?
    
    var post: UserPost?{
        didSet{ configure()}
    }
    
    static let identifier = "FeedPostActionsTableViewCell"
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "AppDarkGray")
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "bubble.left.and.bubble.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(){
        let viewModel = delegate?.didTapLikeButton()
//        guard if let post = post else { return }
//        let viewModel = PostRenderViewModel(renderType: PostRenderedType)
//
//        likeButton.tintColor = viewModel.likeButtonTintColor
//        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height - 20
        let buttons = [likeButton, commentButton, shareButton]
        
        for x in 0..<buttons.count{
            let button = buttons[x]
            button.frame = CGRect(x: (CGFloat(x)*size) + (CGFloat(x+1)*20), y: 5, width: size+5, height: size)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc private func didTapLikeButton(){
        delegate?.didTapLikeButton()
    }
    
    @objc private func didTapCommentButton(){
        delegate?.didTapCommentButton()
    }
    
    @objc private func didTapShareButton(){
        delegate?.didTapShareButton()
    }

}
