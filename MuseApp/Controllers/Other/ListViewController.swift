//
//  ListViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit

class ListViewController: UIViewController {
    
    private let data: [UserRelationship]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserFollowTableViewCell.self, forCellReuseIdentifier: UserFollowTableViewCell.identifier)
        return tableView
    }()
    
    init(data: [UserRelationship]){
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor(named: "AppDarkGray")
        //PART 10 - 11:50
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor(named: "AppDarkGray")
    }
    
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserFollowTableViewCell.identifier) as! UserFollowTableViewCell
        cell.backgroundColor = UIColor(named: "AppDarkGray")
        cell.configure(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model  = data[indexPath.row]
    }
}

extension ListViewController: UserFollowTableViewCellDelegate {
    func didTapFollowUnfollowButton(model: UserRelationship) {
        switch model.type{
            case .following:
                //database update unfollow
                break
            case .not_following:
                //database update to follow
                break
        }
    }

}
