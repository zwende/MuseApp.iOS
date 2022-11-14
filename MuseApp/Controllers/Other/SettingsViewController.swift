//
//  SettingsViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import SafariServices
import UIKit


struct SettingsCellModel{
    let title: String
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController {
    
    private let tableViews: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(named: "AppDarkGray")
        return tableView
    }()
    
    private var data = [[SettingsCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = UIColor(named: "AppDarkGray")
        view.addSubview(tableViews)
        tableViews.delegate = self
        tableViews.dataSource = self
    }
    
    private func configureModels(){
        data.append([
            SettingsCellModel(title: "Edit Profile"){ [weak self] in
                self?.didTapEditProfile()
            }
        ])
        data.append([
            SettingsCellModel(title: "Terms of Service"){ [weak self] in
                self?.openURL(type: .terms)
            },
            SettingsCellModel(title: "Privacy Policy"){ [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingsCellModel(title: "Help"){ [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        
        data.append([
            SettingsCellModel(title: "Log Out"){ [weak self] in
                self?.didTapLogOut()
            }
        ])
        
    }
    
    enum settingsURL{
        case help, terms, privacy
    }
    
    private func didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func openURL(type: settingsURL){
        let urlString: String
        switch type{
        case .terms: urlString = "https://www.google.com/?client=safari"
        case .privacy: urlString = "https://www.google.com/?client=safari"
        case .help: urlString = "https://www.google.com/?client=safari"
        }
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapLogOut(){
        let actionsheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: {success in
                DispatchQueue.main.async {
                    if success{
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        fatalError("Could not log out user")
                    }
                }
            })
            
        }))
        actionsheet.popoverPresentationController?.sourceView = tableViews
        actionsheet.popoverPresentationController?.sourceRect = tableViews.bounds

        present(actionsheet, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViews.frame = view.bounds
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
        
    }
}
