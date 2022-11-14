//
//  NotificationViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit

enum NotificationType{
    case like(post: UserPost)
    case comment(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotifications{
    let type : NotificationType
    let text : String
    let user: User
     
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(named:"AppDarkGray")
        tableView.register(NotificationLikeTableViewCell.self, forCellReuseIdentifier: NotificationLikeTableViewCell.identifier)
        tableView.register(NotificationCommentTableViewCell.self, forCellReuseIdentifier: NotificationCommentTableViewCell.identifier)
        tableView.register(NotificationFollowTableViewCell.self, forCellReuseIdentifier: NotificationFollowTableViewCell.identifier)
        return tableView
    }()
 
    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        view.backgroundColor = UIColor(named: "AppDarkGray")
        navigationItem.title = "Notifications"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = UIColor(named: "AppGray")
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.clipsToBounds = true
    }
    
    private func fetchNotifications(){
        for x in 0...2{
            let user = User(username: "Test",
                            bio: "I am a test",
                            background: " ",
                            profilePicture: " ",
                           counts: UserCounts(following: 0, followers: 0, posts: 0),
                            email: "test@gmail.com",
                            identifier: UserIdentifier(identifier: " "))
            let post = UserPost(identifier: "",
                                postText: " ",
                                likeCount: [],
                                comments: [],
                                owner: UserIdentifier(identifier: " "))
            let model = UserNotifications(type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following), //.comment(post: post)
                                          text: "joesmith commented on your post",
                                          user: user)
            models.append(model)
        }
    }
    
    private func addNoNotificationsView(){
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type{
        case .like(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeTableViewCell.identifier, for: indexPath) as! NotificationLikeTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            cell.backgroundColor = UIColor(named: "AppDarkGray")
            return cell
        case .comment(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCommentTableViewCell.identifier, for: indexPath) as! NotificationCommentTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            cell.backgroundColor = UIColor(named: "AppDarkGray")
            return cell
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowTableViewCell.identifier, for: indexPath) as! NotificationFollowTableViewCell
          //  cell.configure(with: model)
            cell.delegate = self
            cell.backgroundColor = UIColor(named: "AppDarkGray")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

}

extension NotificationViewController: NotificationLikeTableViewCellDelegate{
    func didTapNotificationPostButton(model: UserNotifications){
        switch model.type{
        case .like(let post):
            print("Tapped Post")
            //IF IT DOESNT WORK GO BACK TO PART 12
            let vc = PostViewController(model: post)
            vc.title = " post"
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .comment(_):
            fatalError("Wrong")
        case .follow:
            fatalError("Wrong")
        }
    }
}

extension NotificationViewController: NotificationCommentTableViewCellDelegate{
    func didTapNotificationCommentButton(model: UserNotifications){
        switch model.type{
        case .like(_):
            fatalError("Wrong")
        case .comment(let post):
            print("Tapped Post")  
            let vc = PostViewController(model: post)
            vc.title = " post"
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow:
            fatalError("Wrong")
        }
    }
}

extension NotificationViewController: NotificationFollowTableViewCellDelegate{
    func didTapNotificationFollowUnfollowButton(model: UserNotifications) {
        print("Tapped Button")
    }
}

