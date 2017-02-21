//
//  FacebookSdkAdapter.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 2/13/2560 BE.
//  Copyright © 2560 Kittisak Phetrungnapha. All rights reserved.
//

import Foundation
import FBSDKLoginKit

struct FacebookSdkAdapter {
    
    static let shared = FacebookSdkAdapter()
    
    private init() {
        
    }
    
    enum Permission: String {
        case public_profile = "public_profile"
        case email = "email"
    }
    
    enum LoginResult {
        case success(String)
        case error(String)
        case cancel()
    }
    
    // MARK: - Public
    
    func performLoginWith(viewController: UIViewController, permissions: [String] = [], completion: @escaping (LoginResult) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: permissions, from: viewController) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            
            if let error = error {                
                completion(.error(error.localizedDescription))
                return
            }
            
            guard let result = result else {
                completion(.error("Something went wrong with Facebook SDK."))
                return
            }
            
            if result.isCancelled {
                completion(.cancel())
                return
            }
            
            completion(.success(result.token.tokenString))
        }
    }
    
    func performLogout() {
        FBSDKLoginManager().logOut()
    }
    
}
