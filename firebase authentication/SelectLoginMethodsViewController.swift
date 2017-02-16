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
            FacebookSdkAdapter.shared.performLoginWith(viewController: self, completion: { [unowned self] (loginResult :FacebookSdkAdapter.LoginResult) in
                switch loginResult {
                case .success(let facebookToken):
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: facebookToken)
                    FIRAuth.auth()?.signIn(with: credential, completion: { [unowned self] (user: FIRUser?, error: Error?) in
                        if let error = error {
                            AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                        }
                    })
                    
                case .error(let errorMessage):
                    AppDelegate.showAlertMsg(withViewController: self, message: errorMessage)
                case .cancel():
                    break
                }
            })
            
        case LoginMethods.google.rawValue:
            GIDSignIn.sharedInstance().signIn()
            
        case LoginMethods.twitter.rawValue:
            TwitterSdkAdapter.shared.performLogin(completion: { [unowned self] (loginResult: TwitterSdkAdapter.LoginResult) in
                switch loginResult {
                case .success(let authToken, let authTokenSecret):
                    let credential = FIRTwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
                    FIRAuth.auth()?.signIn(with: credential, completion: { [unowned self] (user: FIRUser?, error: Error?) in
                        if let error = error {
                            AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                        }
                    })
                    
                case .error(let errorMessage):
                    AppDelegate.showAlertMsg(withViewController: self, message: errorMessage)
                }
            })
            
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

extension SelectLoginMethodsViewController: GIDSignInUIDelegate {
    
}
