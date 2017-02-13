//
//  SelectLoginMethodsViewController.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 2/13/2560 BE.
//  Copyright © 2560 Kittisak Phetrungnapha. All rights reserved.
//

import UIKit
import FirebaseAuth

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
                      LoginMethods.github.rawValue,
                      LoginMethods.anonymous.rawValue]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authListener = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let _ = user {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setRootViewControllerWith(viewIdentifier: ViewIdentifiers.profile.rawValue)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAuth.auth()?.removeStateDidChangeListener(authListener!)
    }
    
}

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

extension SelectLoginMethodsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginMethods = dataSource[indexPath.row]
        
        switch loginMethods {
        case LoginMethods.email.rawValue:
            let vc = UIViewController.getViewControllerWith(viewControllerIdentifier: ViewIdentifiers.login.rawValue)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case LoginMethods.facebook.rawValue:
            print("Facebook")
            
        case LoginMethods.google.rawValue:
            print("Google")
            
        case LoginMethods.twitter.rawValue:
            print("Twitter")
            
        case LoginMethods.github.rawValue:
            print("Github")
            
        case LoginMethods.anonymous.rawValue:
            FIRAuth.auth()?.signInAnonymously() { [unowned self] (user, error) in
                if let error = error {
                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                }
            }
            
        default:
            print("default")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
