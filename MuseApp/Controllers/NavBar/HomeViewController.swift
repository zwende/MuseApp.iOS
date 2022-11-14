//
//  ViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import FirebaseAuth
import UIKit

struct HomeFeedRenderViewModel{
    let header: PostRenderViewModel
    let primaryContent: PostRenderViewModel
    let actions: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: FeedPostTableViewCell.identifier)
        tableView.register(FeedPostActionsTableViewCell.self, forCellReuseIdentifier: FeedPostActionsTableViewCell.identifier)
        tableView.register(FeedUsernameHeaderTableViewCell.self, forCellReuseIdentifier: FeedUsernameHeaderTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppDarkGray")
        view.addSubview(tableView)
        fetchAllPosts()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "AppDarkGray")
        createMockModels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func handleNotAuth(){
        //Check auth status
        if Auth.auth().currentUser == nil{
            //Show log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    private var posts: [UserPost] = []
    
    private var users: [String] = []
    
    private func fetchAllPosts() {
        print("Fetching home feed...")

        DatabaseManager.shared.getAllPosts { [weak self] posts, users in
            self?.posts = posts
            self?.users = users
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                print(users)
                self?.fetchProfileData()
            }
        }
    }
    
    private var user: User?
    
    private var usernameList : [String] = []
    private var profileList : [String] = []
    
    
    private func fetchProfileData() {
        print("fetch profile")
        var i = users.count - 1
        for x in 0...i{
            print("user \(x) : \(users[x])")
        DatabaseManager.shared.getUser(email: users[i]) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            DispatchQueue.main.async { [self] in
                self?.tableView.reloadData()
                self?.usernameList.append(user.username)
                self?.profileList.append(user.profilePicture!)
                    }
                }
            i = i - 1
            }
        }
        
    var i = 0
    
    
    private func createMockModels(){
        let user = User(username: "Test",
                        bio: "I am a test",
                        background: " ",
                        profilePicture: " ",
                       counts: UserCounts(following: 0, followers: 0, posts: 0),
                        email: "test@gmail.com",
                        identifier: UserIdentifier(identifier: " "))
        let post = UserPost(identifier: " ",
                            postText: "Hello! This is a test.",
                            likeCount: [],
                            comments: [],
                            owner: UserIdentifier(identifier: " "))
        for x in 0..<15 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    primaryContent: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: " ")))
            feedRenderModels.append(viewModel)
        }
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count * 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model : HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else{
            let position = x % 3 == 0 ? x/3 : ((x - (x % 3)) / 3)
            model = feedRenderModels[position]
        }
        let subSection = x % 3
        if subSection == 0{
            //header
            return 1
        }
        else if subSection == 1{
            //post
            return 1
        }
        else if subSection == 2{
            //actions
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model : HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else{
            let position = x % 3 == 0 ? x/3 : ((x - (x % 3)) / 3)
            model = feedRenderModels[position]
        }
        let subSection = x % 3
        if subSection == 0{
            //header
            let headerModel = model.header
            switch headerModel.renderType{
                case .header(_):
                while !usernameList.isEmpty && !profileList.isEmpty && indexPath.section/3 < usernameList.count{
                    let username = usernameList[indexPath.section/3]
                    let profilePic = profileList[indexPath.section/3]
                    let cell = tableView.dequeueReusableCell(withIdentifier: FeedUsernameHeaderTableViewCell.identifier, for: indexPath) as! FeedUsernameHeaderTableViewCell
                cell.configure(with: .init(title: username, imageUrl: profilePic))
                    i = indexPath.section
                    return cell
                }
                
                //print(profilePic)
            case .primaryContent(_):
                break
            case .actions(_):
                break
            case .comments(_):
                break
            }
        }
        else if subSection == 1{
            //post
            let postModel = model.primaryContent
            switch postModel.renderType {
                case .primaryContent(let post):
                let id = indexPath.section/3
                let post = posts[id]
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.identifier, for: indexPath) as! FeedPostTableViewCell
                cell.configure(with: .init(title: post.postText))
                
                return cell
            case .header(_):
                break
            case .actions(_):
                break
            case .comments(_):
                break
            }
        }
        else if subSection == 2{
            //actions
            let actionsModel = model.actions
            switch actionsModel.renderType {
                case .actions(let provider ):
                    let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostActionsTableViewCell.identifier, for: indexPath) as! FeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .header(_):
                break
            case .primaryContent(_):
                break
            case .comments(_):
                break
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let x = indexPath.section
        let subSection = x % 3
        if subSection == 0{
            HapticsManager.shared.vibrateForSelection()
            
            let vc = ProfileViewController()
            vc.navigationItem.largeTitleDisplayMode = .never
//            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)
        }
         else if subSection == 1{
            HapticsManager.shared.vibrateForSelection()
            
            let vc = PostViewController(
                model: posts[indexPath.section/3],
                isOwnedByCurrentUser: true
            )
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)
            //post
        }
//        else if subSection == 2{
//            //actions
//
//        }
//        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 3
        //let model = feedRenderModels[subSection]
        if subSection == 0{
            return 60
        }
        else if subSection == 1{
            return 100
        }
        else if subSection == 2{
            return 50
        }
        return 0
    }
    
}

extension HomeViewController: FeedPostActionsTableViewCellDelegate{
    func didTapLikeButton() {
        print("LIKE")
        }
    
    func didTapCommentButton() {
//        DatabaseManager.shared.getPosts(for: "wende.zoe@gmail.com") { [weak self] posts in
//            self?.posts = posts
//            print("Found \(posts.count) posts")
//            DispatchQueue.main.async {
//                let post = UserPost(identifier: " ",
//                                    postText: "test",
//                                    likeCount: [],
//                                    comments: [],
//                                    owner: UserIdentifier(identifier: "zoewende"))
//                let vc = PostViewController(model: .init(identifier: post.identifier,
//                                                         postText: post.postText,
//                                                         likeCount: post.likeCount,
//                                                         comments: post.comments,
//                                                         owner: post.owner))
//                self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        guard let post = cell.post else {return}
        
    }
    
    
    func didTapShareButton() {
        print("SHARE")
    }
    
    
}
