//
//  DatabaseManager.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 07/10/21.
//

import FirebaseDatabase
import FirebaseAuth

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()

    // check if username and email are avaiable
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    public func insertNewUser(email: String, username: String, completion: @escaping (Bool)-> Void) {
        //let user = Auth.auth().currentUser!
        //self.database.child("users").child(user.uid).setValue(["username": username])
        database.child(email.safeDabaseKey()).setValue([username:username]) { error, _ in
            if error == nil {
                //succeded
                completion(true)
                return
            }
            else {
                //failed
                completion(false)
                return
            }
        }
    }
    
    
}
