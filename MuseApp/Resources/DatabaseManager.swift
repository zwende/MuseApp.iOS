//
//  DatabaseManager.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/6/22.
//


//CanCreateUser
//Insert UserPost
//Insert User
//getPosts
//getAllPosts
//getUser
//updateProfilePicture

import FirebaseFirestore

public class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    ///check if username and email is available
    ///-Parameters
    ///        -email: string representing email
    ///        -username: string representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)-> Void){
        completion(true)
    }
    
    func updateProfilePhoto(email: String,completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        let photoReference = "profile_pictures/\(path)/photo.png"

        let dbRef = database
            .collection("Users")
            .document(path)

        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["profilePicture"] = photoReference

            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }

    }
    
    func updateBackground(email: String,completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        let photoReference = "background/\(path)/background.png"

        let dbRef = database
            .collection("Users")
            .document(path)

        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["background"] = photoReference

            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }

    }
    
    func getUser(email: String, completion: @escaping (User?) -> Void){
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("Users")
            .document(documentId)
            .getDocument { (doc, err) in
                guard let user = doc else{return}
                
                let username = user.data()?["username"] as? String ?? "No Username"
                let pic = user.data()?["profilePicture"] as? String ?? "No image URL"
                let background = user.data()?["background"] as? String ?? "No image URL"
                let bio = user.data()?["bio"] as? String ?? "No bio"
                let uid = user.data()?["uid"] as? String ?? "No uid"
                let email = user.data()?["email"] as? String ?? "No email"

                DispatchQueue.main.async {
                    completion(User(username: username, bio: bio, background: background, profilePicture: pic, counts: UserCounts(following: 0, followers: 0, posts: 0), email: email, identifier: UserIdentifier(identifier: uid)))
                }
            }
    }
    
     func insert(userPost: UserPost, email: String, userComment: PostComment, completion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String: Any] = [
            "id": userComment.identifier,
            "body": userComment.comment,
            "owner": userComment.username
        ]

        database
            .collection("Users")
            .document(userEmail)
            .collection("posts")
            .document(userPost.identifier)
            .collection("comments")
            .document(userComment.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
    }

    
    public func insert(userPost: UserPost,email: String,completion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String: Any] = [
            "id": userPost.identifier,
            "body": userPost.postText,
        ]

        database
            .collection("Users")
            .document(userEmail)
            .collection("posts")
            .document(userPost.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    func insertNewUser(with user: User, completion: @escaping (Bool)-> Void){
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let uid = UUID().uuidString
        
        let data = [
            "email": user.email,
            "username": user.username,
            "uid" : uid,
            "profilePicture" : "/profile_pictures/",
            "bio" :user.bio,
            "background" : " ",
            "followers" : user.counts.followers,
            "following" : user.counts.following,
            "posts" : user.counts.posts
        ] as [String : Any]

        database
            .collection("Users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
        }
    
    public func getAllUsers(completion: @escaping ([String]) -> Void
    ) {
        database
            .collection("Users")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }

                let emails: [String] = documents.compactMap({ $0["email"] as? String })
                guard !emails.isEmpty else {
                    completion([])
                    return
                }
                print(emails)
                completion(emails)
            }
    }
    
    
    
    
    public func getAllPosts(completion: @escaping ([UserPost],[String]) -> Void) {
        database
            .collection("Users")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }

                let emails: [String] = documents.compactMap({ $0["email"] as? String })
                guard !emails.isEmpty else {
                    completion([],[])
                    return
                }

                let group = DispatchGroup()
                var result: [UserPost] = []
                var users: [String] = []
                for email in emails {
                    group.enter()
                    self?.getPosts(for: email) { userPosts in
                        defer {
                            for x in 0..<userPosts.count{
                                users.append(email)}
                            group.leave()
                        }
                        result.append(contentsOf: userPosts)
                    }
                }
                print("emails: \(users.count)")
                group.notify(queue: .global()) {
                    print("Feed posts: \(result.count)")
                    completion(result,users)
                }
            }
        }

    public func getPosts(for email: String, completion: @escaping ([UserPost]) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
                    .collection("Users")
                    .document(userEmail)
                    .collection("posts")
                    .getDocuments {
                        snapshot, error in
                        guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                              error == nil else {
                            return
                        }

                        let posts: [UserPost] = documents.compactMap({ dictionary in
                            guard let body = dictionary["body"] as? String,
                                  let id = dictionary["id"] as? String
                                   else {
                                print("Invalid post fetch conversion")
                                return nil
                            }
                            let owner = "zoewende"
                            let post = UserPost(
                                identifier: id,
                                postText: body,
                                likeCount: [],
                                comments: [],
                                owner: UserIdentifier(identifier: owner)
                            )
                            return post
                        })
                        completion(posts)
                    }
            }
     func getComments(for email: String, postID: String, completion: @escaping ([PostComment]) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
                    database
                    .collection("Users")
                    .document(userEmail)
                    .collection("posts")
                    .document(postID)
                    .collection("comments")
                    .getDocuments {
                        snapshot, error in
                        guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                              error == nil else {
                            return
                        }

                        let comments: [PostComment] = documents.compactMap({ dictionary in
                            guard let body = dictionary["body"] as? String,
                                  let id = dictionary["id"] as? String,
                                  let owner = dictionary["owner"] as? String
                                   else {
                                print("Invalid comment fetch conversion")
                                return nil
                            }
                            let comment = PostComment(username: owner, comment: body, identifier: id
                            )
                            return comment
                        })
                        completion(comments)
                    }
            }
    }
    



