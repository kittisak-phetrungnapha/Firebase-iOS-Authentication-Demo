//
//  SelectLoginMethodsViewController.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 2/13/2560 BE.
//  Copyright © 2560 Kittisak Phetrungnapha. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SelectLoginMethodsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    fileprivate let cellIdentifier = "cell"
    fileprivate var dataSource: [String]!
    
    private var authListener: FIRAuthStateDidChangeListenerHandle?
    
    // MARK: - View controller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [LoginMethods.email.rawValue,
                      LoginMethods.facebook.rawValue,
                      LoginMethods.google.rawValue,
                      LoginMethods.twitter.rawValue,
                      LoginMethods.anonymous.rawValue]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.isScrollEnabled = false
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: - Register auth listener.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // TODO: - Unregister auth listener.
    }
    
}

// MARK: - UITableViewDataSource
extension SelectLoginMethodsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else { return UITableViewCell() }
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SelectLoginMethodsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginMethods = dataSource[indexPath.row]
        UserDefaults.standard.set(loginMethods, forKey: UserDefaultsKey.loginMethod.rawValue)
        
        switch loginMethods {
        case LoginMethods.email.rawValue:
            let vc = UIViewController.getViewControllerWith(viewControllerIdentifier: ViewIdentifiers.email.rawValue)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case LoginMethods.facebook.rawValue:
            // TODO: - Perform Facebook login with Firebase.
            break
            
        case LoginMethods.google.rawValue:
            // TODO: - Perform Google sign in with Firebase.
            break
            
        case LoginMethods.twitter.rawValue:
            // TODO: - Perform Twitter login with Firebase.
            break
            
        case LoginMethods.anonymous.rawValue:
            // TODO: - Perform anonymous sign in.
            break
            
        default:
            print("default")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SelectLoginMethodsViewController: GIDSignInUIDelegate {
    
}
