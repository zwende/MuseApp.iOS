//
//  CommentViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/28/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommentViewController: UIViewController {
    
    let post : UserPost?
    
    init(post: UserPost?){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppGray")
        view.addSubview(header)
        view.addSubview(textView)
        configureButtons()
        // Do any additional setup after loading the view.
    }
    
    private let header: UILabel = {
        let label = UILabel()
        label.text = "New Comment"
        label.font = .boldSystemFont(ofSize: 20)
//        label.font = UIFont(name: "Arial", size: 20)
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
        header.frame = CGRect(x: view.width/2 - 60, y: view.safeAreaInsets.top, width: size, height: 50)
        textView.frame = CGRect(x: 10, y: header.bottom+10, width: view.width-20, height: view.height-150)
    }
    
    private func configureButtons() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Comment",
            style: .done,
            target: self,
            action: #selector(didTapComment)
        )

    }
    
    @objc private func didTapComment(){
        guard let body = textView.text,
              let user = Auth.auth().currentUser,
              let email = user.email,
              let thisPost = post,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {

            let alert = UIAlertController(title: "Enter Comment Details",
                                          message: "Comment cannot be empty.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("Starting comment...")

        let newCommentId = UUID().uuidString


        let comment = PostComment(username: "zoewende", comment: body, identifier: newCommentId)

        DatabaseManager.shared.insert(userPost: thisPost, email: email, userComment: comment) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.textView.text = " "
                        let alert = UIAlertController(title: "Comment", message: "You have successfully commented on this post", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
    }
}
