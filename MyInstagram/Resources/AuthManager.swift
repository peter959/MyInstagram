//
//  AuthManager.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 07/10/21.
//

import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        // check if username is avaiable
        // check if email is abaiable
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                //create account
                // insert account to database
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    
                    //insert into database
                    DatabaseManager.shared.insertNewUser(email: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                        else {
                            completion(false)
                            
                        }
                    }
                    
                        
                }
            }
            else {
                //either username or email does not exist
                completion(false)
            }
            
        }
        
    }
    
    public func LoginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { AuthResult, error in
                guard AuthResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            Auth.auth().signIn(withEmail: username, password: password) { AuthResult, error in
                guard AuthResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    public func LogOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            completion(false)
            print(error)
            return
        }
    }
}
