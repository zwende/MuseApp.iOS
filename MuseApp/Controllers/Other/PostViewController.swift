//
//  PostViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit
import FirebaseAuth

enum PostRenderedType{
    case header(provider: User)
    case primaryContent(provider: UserPost)
    case actions(provider: String)
    case comments(comments: [PostComment])
}

struct PostRenderViewModel{
    let renderType: PostRenderedType
}

class PostViewController: UIViewController {
    
    private let isOwnedByCurrentUser: Bool
    
    private let model: UserPost
    
    private var renderModels = [PostRenderViewModel]()
    
    let currentEmail: String = Auth.auth().currentUser?.email ?? "wende_zoe_gmail_com"
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: FeedPostTableViewCell.identifier)
        tableView.register(FeedPostActionsTableViewCell.self, forCellReuseIdentifier: FeedPostActionsTableViewCell.identifier)
        tableView.register(FeedUsernameHeaderTableViewCell.self, forCellReuseIdentifier: FeedUsernameHeaderTableViewCell.identifier)
        tableView.register(FeedPostInteractionsTableViewCell.self, forCellReuseIdentifier: FeedPostInteractionsTableViewCell .identifier)
        tableView.backgroundColor = UIColor(named: "AppDarkGray")
        return tableView
    }()
    
    init(model: UserPost, isOwnedByCurrentUser: Bool = false){
        self.model = model
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    var comments = [PostComment]()
    
    private func configureModels(){
        let userPostModel = self.model 
        //header
//        renderModels.append(PostRenderViewModel(renderType: .header(provider: user)))
        //post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: " ")))
        fetchComments()
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))

    }
    
    private func fetchComments(){
        DatabaseManager.shared.getComments(for: currentEmail, postID: model.identifier) { [weak self] comments in
            self?.comments = comments
            print("Found \(comments.count) comments")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                }
            }
    }
    
    var x = 0
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType{
        case .actions(provider: _): return 1
        case .comments(_): return comments.count
        case .primaryContent(provider: _): return 1
        case .header(provider: _): return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        print("1")
        switch model.renderType{
            
        case .actions(let actions):
            print("2")
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostActionsTableViewCell.identifier, for: indexPath) as! FeedPostActionsTableViewCell
            cell.delegate = self
            return cell
        case .comments(_):
                print("3")
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostInteractionsTableViewCell.identifier, for: indexPath) as! FeedPostInteractionsTableViewCell
            let thisComment = comments[x].comment
            let owner = comments[x].username
            cell.configure(with: .init(comment: thisComment, owner: owner, picture: "profile_pictures/wende_zoe_gmail_com/photo.png"))
            x = x + 1
            return cell
        case .primaryContent(let post):
            print("4")
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.identifier, for: indexPath) as! FeedPostTableViewCell
            cell.configure(with:.init(title: post.postText))
            return cell
        case .header(let user):
                        print("5")
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedUsernameHeaderTableViewCell.identifier, for: indexPath) as! FeedUsernameHeaderTableViewCell
            cell.configure(with: .init(title: user.username, imageUrl: user.profilePicture))
            return cell
        }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        
        switch model.renderType{
        case .actions(_):
            return 50
        case .comments(_):
            let x = UITableView.automaticDimension
            if x < 60{
                return 60}
            else{
                return x
            }
        case .primaryContent(_):
            return 100
        case .header(_):
            return 60
        }
    }
}

extension PostViewController: FeedPostActionsTableViewCellDelegate{
    func didTapLikeButton() {
        print("LIKE")
    }
    
    func didTapCommentButton() {
        let vc = CommentViewController(post: model)
        vc.modalPresentationStyle = .fullScreen
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
    func didTapShareButton() {
        print("SHARE")
    }
    
    
}
