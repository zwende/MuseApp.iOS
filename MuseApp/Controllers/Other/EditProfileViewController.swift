//
//  EditProfileViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct EditProfileFormModel{
    let label: String
    let placeholder: String
    var value: String?
}

class EditProfileViewController: UIViewController, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private var user: User?
    
    let currentEmail: String = Auth.auth().currentUser?.email ?? " "

//    init(currentEmail: String) {
//        self.currentEmail = currentEmail
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "AppDarkGray")
        return tableView
    }()

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        cell.backgroundColor = .black
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        configureModels()
        tableView.dataSource = self
        createHeaderView()
        fetchProfileData()
        view.addSubview(tableView)
        view.backgroundColor = UIColor(named: "AppDarkGray")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapCancel))
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.addSubview(spotifyButton)
        // Do any additional setup after loading the view.
    }
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2.0
        button.backgroundColor = UIColor(named: "AppYellow")
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2.0
        button.backgroundColor = UIColor(named: "AppYellow")
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spotifyButton.frame = CGRect(x: 8, y: view.height - 140, width: view.width - 20, height: 40)
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
                    }
            self?.user = user

            DispatchQueue.main.async {
                self?.createHeaderView(profilePhotoRef: user.profilePicture, username: user.username, bio: user.bio)
            }
        }
    }
    
    private let spotifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:(29.0 / 255.0), green:(185.0 / 255.0), blue:(84.0 / 255.0), alpha:1.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 20.0
            button.setTitle("Connect Spotify", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            button.sizeToFit()
            button.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
            return button
    }()
    
    @objc private func didTapConnect(){
        let SpotifyClientID = "a88d849369a942ca8d3f26f40d696e45"
        let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

        lazy var configuration = SPTConfiguration(
          clientID: SpotifyClientID,
          redirectURL: SpotifyRedirectURL
        )
        let vc = SpotifySignInViewController()
        vc.completionHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool){
        
    }
    
    private var models = [[EditProfileFormModel]]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    private var field = UITextView()
    private var bioField = UITextView()

    private func createHeaderView(profilePhotoRef: String? = nil, username: String? = nil, bio: String? = nil) {
        let size = (view.height/4)/1.4
        let profilepictureButton = UIImageView(image: UIImage(systemName: "person.circle"))
        
        view.addSubview(profilepictureButton)
        profilepictureButton.layer.masksToBounds = true
        profilepictureButton.layer.cornerRadius = size/2
        profilepictureButton.frame = CGRect(x: (view.width-size)/2, y: ((view.height/4))/2, width: size, height: size)
        profilepictureButton.tintColor = .label
        profilepictureButton.layer.borderWidth = 3
        profilepictureButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePictureButton))
        profilepictureButton.addGestureRecognizer(tap)
        profilepictureButton.isUserInteractionEnabled = true
        
        let usernameLabel = UILabel()
        usernameLabel.text = "Username: "
        usernameLabel.frame = CGRect(x: 5, y: profilepictureButton.bottom + 20, width: view.width - 20, height: size/4)
        view.addSubview(usernameLabel)
        
        field.isEditable = true
        field.returnKeyType = .next
        field.autocapitalizationType = .none
        field.text = username
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
//        field.delegate = self
        field.backgroundColor = UIColor(named: "AppGray")
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(named: "AppYellow")?.cgColor
        field.frame = CGRect(x: 5, y: usernameLabel.bottom + 10, width: view.width - 20, height: size/4)
        field.font = UIFont(name: "Arial", size: 15)
        view.addSubview(field)
        
        let bioLabel = UILabel()
        bioLabel.text = "Bio: "
        bioLabel.frame = CGRect(x: 5, y: field.bottom + 20, width: view.width - 20, height: size/4)
        view.addSubview(bioLabel)
        

        bioField.returnKeyType = .next
        bioField.autocapitalizationType = .none
        bioField.text = bio
        bioField.autocorrectionType = .no
        bioField.layer.masksToBounds = true
        bioField.backgroundColor = UIColor(named: "AppGray")
        bioField.layer.borderWidth = 1.0
//        bioField.delegate = self
        bioField.font = UIFont(name: "Arial", size: 15)
        bioField.isEditable = true
        bioField.layer.borderColor = UIColor(named: "AppYellow")?.cgColor
        bioField.isUserInteractionEnabled = true
        bioField.frame = CGRect(x: 5, y: bioLabel.bottom + 5, width: view.width - 20, height: size)
        view.addSubview(bioField)
        
        
        if let ref = profilePhotoRef {
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
                        profilepictureButton.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
        
        
        
        
//        func textFieldShouldReturn(_ textField:UITextField) ->Bool{
//            if textField == field{
//                bioField.becomeFirstResponder()
//            }
//
//            else if textField == bioField{
//                print("textFieldShouldReturn")
//                didTapSave()
//                bioField.resignFirstResponder()
//            }
//            return true
//        }
//        return header
    }
    
    
    @objc private func didTapProfilePictureButton(){
        
//        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
//              
//              myEmail == currentEmail else {
//                  print(currentEmail)
//            return
//        }

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func didTapSave(){

        guard let username = field.text, !username.isEmpty,
              let bio = bioField.text, !bio.isEmpty else{
                  return
              }
        print("didTapSave")

        //Save info to database
        DatabaseManager.shared.getUser(email: currentEmail){ [weak self] user in
            guard let user = user else {
                return
            }
            print("getUser")
            self?.user = user
            DispatchQueue.main.async {
                let documentId = self?.currentEmail
                    .replacingOccurrences(of: "@", with: "_")
                    .replacingOccurrences(of: ".", with: "_")
                self?.database.collection("Users").document(documentId ?? " ").updateData([
                    "username" : username, "bio" : bio])
            }
        }
            
        
        
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePicture(){
        let actionsheet = UIAlertController(title: "Profile Picture", message: "Change profile picture", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        actionsheet.popoverPresentationController?.sourceView = view
        actionsheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionsheet, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image
        ) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                // Update database
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
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
}

extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell( _ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        print(updatedModel.value ?? "nil")
    }
}


