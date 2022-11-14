//
//  StorageManager.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/6/22.
//

import FirebaseStorage
import UIKit

public class StorageManager{
    static let shared = StorageManager()

    private let container = Storage.storage()
    
    private init() {}
    
    //MARK - Public
    
    public func uploadUserPhotoPost(model: UserPost, completion: (Result<URL, Error>) -> Void){
        
    }
    
    public func downloadUrlForPost(email: String, postId: String,completion: @escaping (URL?) -> Void) {
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        container
            .reference(withPath: "post_url/\(emailComponent)/\(postId).txt")
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func uploadUserProfilePicture(email: String,image: UIImage?,completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        guard let pngData = image?.pngData() else {
            return
        }

        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func uploadUserBackground(email: String,image: UIImage?,completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")

        guard let pngData = image?.pngData() else {
            return
        }

        container
            .reference(withPath: "background/\(path)/background.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadUrlForProfilePicture(path: String, completion: @escaping (URL?) -> Void) {
        container.reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }

    
    public func downloadUrlForBackground(path: String, completion: @escaping (URL?) -> Void) {
        container.reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }
}

