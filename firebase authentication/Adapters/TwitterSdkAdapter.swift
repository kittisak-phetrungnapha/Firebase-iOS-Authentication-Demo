//
//  TwitterSdkAdapter.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 2/14/2560 BE.
//  Copyright © 2560 Kittisak Phetrungnapha. All rights reserved.
//

import Foundation
import TwitterKit

struct TwitterSdkAdapter {
    
    static let shared = TwitterSdkAdapter()
    
    private init() {
        
    }
    
    enum LoginResult {
        case success(String, String)
        case error(String)
    }
    
    // MARK: - Public method
    
    func performLogin(completion: @escaping (LoginResult) -> Void) {
        Twitter.sharedInstance().logIn { (session: TWTRSession?, error: Error?) in
            if let error = error {
                completion(.error(error.localizedDescription))
                return
            }
            
            guard let session = session else {
                completion(.error("Something went wrong with Twitter SDK."))
                return
            }
            
            completion(.success(session.authToken, session.authTokenSecret))
        }
    }
    
    func performLogout() {
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }
    
}
