//struct SearchRenderViewModel{
//    let header: PostRenderViewModel
//}
//
//class SearchViewController: UIViewController {
//    
//    private var searchViewModel = [SearchRenderViewModel]()
//    
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.backgroundColor = UIColor(named: "AppGray")
//        searchBar.placeholder = "Search"
//        return searchBar
//    }()
//    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(FeedUsernameHeaderTableViewCell.self, forCellReuseIdentifier: FeedUsernameHeaderTableViewCell.identifier)
//        return tableView
//    }()
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(named: "AppDarkGray")
//        navigationController?.navigationBar.topItem?.titleView = searchBar
//        let scrollEdgeAppearance = UINavigationBarAppearance()
//        scrollEdgeAppearance.backgroundColor = UIColor(named: "AppGray")
//        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
//        
//        searchBar.delegate = self
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = UIColor(named: "AppDarkGray")
//        
//        fetchAllUsers()
//    }
//    
//    override func viewDidLayoutSubviews(){
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
//    
//    private var emails: [String] = []
//    
//    private var users: [String] = []
//    
//    private func fetchAllUsers() {
//        print("Fetching search...")
//
//        DatabaseManager.shared.getAllUsers { [weak self] emails in
//            self?.emails = emails
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                print(emails)
//                self?.fetchProfileData()
//            }
//        }
//    }
//    
//    private var user: User?
//    private var profilePic: [String] = []
//    
//    private func fetchProfileData() {
//        print("fetch profile")
//        var i = emails.count - 1
//        for x in 0...i{
//            print("user \(x) : \(emails[x])")
//        DatabaseManager.shared.getUser(email: emails[i]) { [weak self] user in
//            guard let user = user else {
//                return
//            }
//            self?.user = user
//            DispatchQueue.main.async { [self] in
//                self?.tableView.reloadData()
//                self?.users.append(user.username)
//                self?.profilePic.append(user.profilePicture!)
//                    }
//                }
//            i = i - 1
//            }
//        }
//    
//    var i = 0
//    
//}
//
//extension SearchViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        didCancelSearch()
//        guard let text = searchBar.text, !text.isEmpty else{
//            return
//        }
//        
//        query(text)
//        
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
//    }
//    
//    @objc private func didCancelSearch(){
//        searchBar.resignFirstResponder()
//        navigationItem.rightBarButtonItem = nil
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//    }
//    
//    private func query(_ text: String){
//        
//    }
//}
//
//extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let x = indexPath.section
//        let model : SearchRenderViewModel
//        
//        if x == 0 {
//            model = searchViewModel[0]
//        }
//        else{
//            let position = x % 3 == 0 ? x/3 : ((x - (x % 3)) / 3)
//            model = searchViewModel[position]
//        }
//            let headerModel = model.header
//            switch headerModel.renderType{
//                case .header(_):
//                while !users.isEmpty && !profilePic.isEmpty{
//                    let username = users[indexPath.section/3]
//                    let profile = profilePic[indexPath.section/3]
//                    let cell = tableView.dequeueReusableCell(withIdentifier: FeedUsernameHeaderTableViewCell.identifier, for: indexPath) as! FeedUsernameHeaderTableViewCell
//                cell.configure(with: .init(title: username, imageUrl: profile))
//                    i = indexPath.section
//                    return cell }
//                
//                print(profilePic)
//            case .primaryContent(_):
//                break
//            case .actions(_):
//                break
//            case .comments(_):
//                break
//    }
//        return UITableViewCell()
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//}
//
