//
//  PostCreateViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class PostCreateViewController: UITabBarController {
    
    static let shared = DatabaseManager()

    private let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(named: "AppGray")
        view.addSubview(header)
        view.addSubview(textView)
        configureButtons()
    }
    
    private let header: UILabel = {
        let label = UILabel()
        label.text = "NEW POST"
        label.font = UIFont(name: "Arial", size: 20)
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "AppDarkGray")
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 20)
        return textView
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width-20
        header.frame = CGRect(x: view.width/2 - 50, y: view.safeAreaInsets.top, width: size, height: 50)
        textView.frame = CGRect(x: 10, y: header.bottom+10, width: view.width-20, height: view.height-50-view.safeAreaInsets.top)
    }
    
    private func configureButtons() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
        
    }
    
    private func configure(){
        
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }


    @objc private func didTapPost() {
        // Check data and post
        guard let body = textView.text,
              let user = Auth.auth().currentUser,
              let email = user.email,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {

            let alert = UIAlertController(title: "Enter Post Details",
                                          message: "Post cannot be empty.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("Starting post...")

        let newPostId = UUID().uuidString


                let post = UserPost(identifier: newPostId,
                                    postText: body,
                                    likeCount: [],
                                    comments: [],
                                    owner: UserIdentifier(identifier: " "))

                DatabaseManager.shared.insert(userPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.textView.text = " "
                        let alert = UIAlertController(title: "Post", message: "Your post has been successfully posted", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                        let systemSoundID: SystemSoundID = 1013
//                        AudioServicesPlaySystemSound(systemSoundID)
                        self?.present(alert, animated: true)
                        //self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
    }
}

// Upload header Image
