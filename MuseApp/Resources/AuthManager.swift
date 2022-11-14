//
//  AuthManager.swift
//  MuseApp
//
//  Created by Zoe Wende on 3/6/22.
//

import FirebaseAuth
import UIKit

public class AuthManager{
    static let shared = AuthManager()
    
    //MARK - Public
    
    public func registerNewUser(username : String, email : String, password : String, completion: @escaping (Bool) -> Void){
        //Check if username is avaliable
        //Check if email is available
        //Create account and insert to database
        DatabaseManager.shared.canCreateNewUser(with: email, username: username){ canCreate in
            if canCreate{
                Auth.auth().createUser(withEmail: email, password: password){ result, error in
                    guard error == nil, result != nil else{
                        completion(false)
                        return
                    }
                    //Insert into database
                    let newUser = User(username: username, bio: " ", background: " ", profilePicture: " ", counts: UserCounts(following: 0, followers: 0, posts: 0), email: email, identifier: UserIdentifier(identifier: " "))
                    DatabaseManager.shared.insertNewUser(with: newUser) { success in
                        if success {
                            completion(true)
                            return
                        }
                        else{ completion(false)
                            return
                        }
                    }
                }
            }
            else{
                completion(false)
            }
        }
        
    }
    
    public  func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void){
        if let email = email {
            //email log in
            Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
                guard authResult != nil, error == nil else{
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        
        else if let username = username {
            //username log in
//            print(username)
        }
    }
    
    public func logOut(completion: (Bool) -> Void){
        do{
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch{
            print(error)
            completion(false)
            return
        }
    }
    
    //MARK - SPOTIFY
    
    struct Constants{
        static let clientID = "a88d849369a942ca8d3f26f40d696e45"
        static let clientSecret = "fc44fb0efcab41b682e3a4d51764821a"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let scope = "user-read-private"
        let redirectURI = "https://www.google.com"
        let base = "https://accounts.spotify.com/authorize?"
        let string = "\(base)response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSignedIn:Bool {
        return false
    }
    
    private var accessToken:String? {
        return nil
    }
    
    private var refreshToken:String? {
        return nil
    }
    
    private var tokenExp:Date? {
        return nil
    }
    
    private var shouldRetToken:Bool {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void){
        
    }
    
    private func cacheToken(){
        
    }
    
}
