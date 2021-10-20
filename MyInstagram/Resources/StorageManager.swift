//
//  StorageManager.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 07/10/21.
//

import FirebaseStorage
import Foundation
import UIKit

public class StorageManager {
    
    static let shared = DatabaseManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum IGStorageManagerError: Error {
        case failedToDownload
    }
    
    
    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void) {
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(. failedToDownload))
                return
            }
            
            completion(.success(url))
            return
        })
    }
    
}

