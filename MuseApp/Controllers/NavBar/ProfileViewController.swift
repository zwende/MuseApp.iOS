//
//  ProfileViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct ProfileViewControllerModel{
    let header: PostRenderViewModel
    let primaryContent: PostRenderViewModel
    let actions: PostRenderViewModel
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    private var profileRenderModels = [ProfileViewControllerModel]()
    
    private var user: User?
    
    var currentUser: [String] = ["username", "profile_picture"]
    
    let currentEmail: String = Auth.auth().currentUser?.email ?? " "

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
        configureNavigationBar()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.width, height: view.width/2)
        layout.collectionView?.backgroundColor = UIColor(named: "AppDarkGray")


        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = UIColor(named: "AppGray")
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        setUpTable()
        fetchPosts()
        createMockModels()
    }

    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "AppDarkGrat")
        fetchProfileData()
        setUpTableHeader(profilePicture: nil, username: nil, bio: nil, background: nil)
    }

    private func setUpTableHeader(profilePicture: String?, username: String? , bio: String?, background: String?) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.height/2) - 10))
        headerView.backgroundColor = UIColor(named: "AppDarkGray")
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView

        let backgroundView = UIImageView()
        headerView.addSubview(backgroundView)
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.width, height: (view.width/1.5)/2)
        backgroundView.clipsToBounds = true
        backgroundView.isUserInteractionEnabled = true
        backgroundView.image = UIImage(named: "test")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        backgroundView.addGestureRecognizer(tap)
        
        
        let profileView = UIView(frame: CGRect(x: 0, y: backgroundView.bottom, width: view.width, height: (view.width/2) ))
        profileView.backgroundColor = UIColor(named: "AppDarkGray")
        profileView.clipsToBounds = true
        profileView.isUserInteractionEnabled = false
        headerView.addSubview(profileView)
        
        // Profile picture
        let profilePhoto = UIImageView()
        profilePhoto.backgroundColor = .systemBlue
        profilePhoto.tintColor = .white
        profilePhoto.clipsToBounds = true
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(x: 5, y: 10, width: view.width/5, height: view.width/5)
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        profilePhoto.image = UIImage(systemName: "person.circle")
        profilePhoto.isUserInteractionEnabled = true
        profileView.addSubview(profilePhoto)

        // Email
        let usernameLabel = UILabel(frame: CGRect(x: 10, y: profilePhoto.bottom, width: view.width - 10, height: 50))
        profileView.addSubview(usernameLabel)
        usernameLabel.text = username
        usernameLabel.textColor = .white
        usernameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        let bioText = UITextView(frame: CGRect(x: 10, y: usernameLabel.bottom, width: view.width, height: 100))
        profileView.addSubview(bioText)
        bioText.isEditable = false
        bioText.textColor = .white
        bioText.text = bio
        bioText.font = .systemFont(ofSize: 18)
        bioText.textContainer.maximumNumberOfLines = 3
        bioText.backgroundColor = UIColor(named: "AppDarkGray")

        if let username = username {
            navigationItem.title = username
    
        }
        
        if let ref = profilePicture {
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
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
        if let back = background {
            // Fetch image
            StorageManager.shared.downloadUrlForBackground(path: back) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        backgroundView.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    
    @objc private func didTapBackground(){
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else {
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    private func fetchProfileData() {
        print("fetch profile")
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user

            DispatchQueue.main.async { [self] in
//                print(user.username)
                self?.setUpTableHeader(profilePicture: user.profilePicture, username: user.username, bio: user.bio, background: user.background)
                self?.tableView.reloadData()
                self?.currentUser[0] = user.username
                self?.currentUser[1] = user.profilePicture ?? ""
                
            }
        }
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func configureNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))
        navigationItem.titleView?.backgroundColor = UIColor(named: "AppGray")
    }

    @objc private func didTapSettingsButton(){
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private var posts: [UserPost] = []

    private func fetchPosts() {
        print("Fetching posts...")

        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            }
        }
    
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
        for x in 0..<10 {
            let viewModel = ProfileViewControllerModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    primaryContent: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: " ")))
            profileRenderModels.append(viewModel)
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadUserBackground(
            email: currentEmail,
            image: image
        ) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                // Update database
                DatabaseManager.shared.updateBackground(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
        func numberOfSections(in tableView: UITableView) -> Int {
            return posts.count * 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let x = section
            let model : ProfileViewControllerModel
            if x == 0 {
                model = profileRenderModels[0]
            }
            else{
                let position = x % 3 == 0 ? x/3 : ((x - (x % 3)) / 3)
                model = profileRenderModels[position]
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
            let model : ProfileViewControllerModel
            if x == 0 {
                model = profileRenderModels[0]
            }
            else{
                let position = x % 3 == 0 ? x/3 : ((x - (x % 3)) / 3)
                model = profileRenderModels[position]
            }
            let subSection = x % 3
            if subSection == 0{
                //header
                let headerModel = model.header
                switch headerModel.renderType{
                case .header(let user):
                    let username = currentUser[0]
                    let profilePic = currentUser[1]
                        let cell = tableView.dequeueReusableCell(withIdentifier: FeedUsernameHeaderTableViewCell.identifier, for: indexPath) as! FeedUsernameHeaderTableViewCell
                    cell.configure(with: .init(title: username, imageUrl: profilePic))
                    return cell
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
                case .primaryContent(_):
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

extension ProfileViewController: FeedPostActionsTableViewCellDelegate{
    
        func didTapLikeButton() {

        }
        
    func didTapCommentButton() {
        
        DatabaseManager.shared.getPosts(for: "wende.zoe@gmail.com") { [weak self] posts in
            self?.posts = posts
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
                let post = UserPost(identifier: "",
                                    postText: "test",
                                    likeCount: [],
                                    comments: [],
                                    owner: UserIdentifier(identifier: "zoewende"))
                let vc = PostViewController(model: .init(identifier: post.identifier,
                                                         postText: post.postText,
                                                         likeCount: post.likeCount,
                                                         comments: post.comments,
                                                         owner: post.owner))
                self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        func didTapShareButton() {
            print("SHARE")
        }
        
        
    }

extension ProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell( _ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        print(updatedModel.value ?? "nil")
    }
}

