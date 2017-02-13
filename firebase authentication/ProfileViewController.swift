//
//  ProfileViewController.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 9/27/2559 BE.
//  Copyright © 2559 Kittisak Phetrungnapha. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var providerIDValueLabel: UILabel!
    @IBOutlet weak var uidValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var photoUrlValueLabel: UILabel!
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let manageProfileBarButton = UIBarButtonItem(title: "Manage", style: .plain, target: self, action: #selector(manageProfile))
        self.navigationItem.leftBarButtonItem = logoutBarButton
        self.navigationItem.rightBarButtonItem = manageProfileBarButton
        
        if let user = FIRAuth.auth()?.currentUser {
            setUserDataToView(withFIRUser: user)
            
            if user.isAnonymous {
                AppDelegate.showAlertMsg(withViewController: self, message: "You are an Anonymous. If you want to update the profile, you have to login first.")
                manageProfileBarButton.isEnabled = false
            }
            else if !user.isEmailVerified {
                AppDelegate.showAlertMsg(withViewController: self, message: "Your account is not verified. Please select manage to verify it.")
            }
        } else {
            let alert = UIAlertController(title: "Message", message: "No user is signed in", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action: UIAlertAction) in
                self.logout()
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Method
    private func setUserDataToView(withFIRUser user: FIRUser) {
        providerIDValueLabel.text = UserDefaults.standard.value(forKey: UserDefaultsKey.loginMethod.rawValue) as! String?
        uidValueLabel.text = user.uid
        emailValueLabel.text = user.email
        nameValueLabel.text = user.displayName
        photoUrlValueLabel.text = user.photoURL?.absoluteString
    }
    
    func logout() {
        switch providerIDValueLabel.text! {
        case LoginMethods.facebook.rawValue:
            FacebookSdkAdapter.shared.performLogout()
        default:
            break
        }
        
        try! FIRAuth.auth()!.signOut()
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.loginMethod.rawValue)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setRootViewControllerWith(viewIdentifier: ViewIdentifiers.login.rawValue)
    }
    
    func manageProfile() {
        let manageActionSheet = UIAlertController(title: "Select menu", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let changeUserInfoAction = UIAlertAction(title: "Change name and image", style: .default) { [unowned self] (action: UIAlertAction) in
            self.changeUserInfo()
        }
        
        let changeEmailAction = UIAlertAction(title: "Change Email", style: .default) { [unowned self] (action: UIAlertAction) in
            self.changeEmail()
        }
        
        let changePasswordAction = UIAlertAction(title: "Change Password", style: .default) { [unowned self] (action: UIAlertAction) in
            self.changePassword()
        }
        
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .default) { [unowned self] (action: UIAlertAction) in
            self.deleteAccount()
        }
        
        manageActionSheet.addAction(changeUserInfoAction)
        manageActionSheet.addAction(changePasswordAction)
        
        if let user = FIRAuth.auth()?.currentUser, !user.isEmailVerified {
            let verifyAccountAction = UIAlertAction(title: "Verify Account", style: .default) { [unowned self] (action: UIAlertAction) in
                self.sentVerifiedEmail()
            }
            manageActionSheet.addAction(verifyAccountAction)
        }
        
        manageActionSheet.addAction(changeEmailAction)
        manageActionSheet.addAction(deleteAccountAction)
        manageActionSheet.addAction(cancelAction)
        
        self.present(manageActionSheet, animated: true, completion: nil)
    }
    
    private func changeUserInfo() {
        let alert = UIAlertController(title: "Change name and image", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your name"
            textField.clearButtonMode = .whileEditing
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your image url"
            textField.clearButtonMode = .whileEditing
            textField.text = "https://example.com/user/user-uid/profile.jpg"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let nameTextField = alert.textFields![0]
            let imageTextField = alert.textFields![1]
            
            if let user = FIRAuth.auth()?.currentUser {
                let changeRequest = user.profileChangeRequest()
                
                changeRequest.displayName = nameTextField.text
                changeRequest.photoURL = NSURL(string: imageTextField.text!) as? URL
                changeRequest.commitChanges { [unowned self] error in
                    if let error = error {
                        AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                    } else {
                        AppDelegate.showAlertMsg(withViewController: self, message: "Your profile was updated")
                        self.setUserDataToView(withFIRUser: user)
                    }
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changePassword() {
        let alert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your new password"
            textField.clearButtonMode = .whileEditing
            textField.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let textField = alert.textFields![0]
            
            let user = FIRAuth.auth()?.currentUser
            user?.updatePassword(textField.text!) { [unowned self] error in
                if let error = error {
                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                } else {
                    AppDelegate.showAlertMsg(withViewController: self, message: "Password was updated")
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeEmail() {
        let alert = UIAlertController(title: "Change Email", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your new email"
            textField.clearButtonMode = .whileEditing
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let textField = alert.textFields![0]
            
            let user = FIRAuth.auth()?.currentUser
            user?.updateEmail(textField.text!) { [unowned self] error in
                if let error = error {
                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                } else {
                    AppDelegate.showAlertMsg(withViewController: self, message: "Email was updated. You have to login again.")
                    self.logout()
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteAccount() {
        if let user = FIRAuth.auth()?.currentUser {
            let alert = UIAlertController(title: "Delete Account", message: "[\(user.email!)] will be deleted. This operation can not undo. Are you sure?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
                user.delete { [unowned self] error in
                    if let error = error {
                        AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                    } else {
                        AppDelegate.showAlertMsg(withViewController: self, message: "[\(user.email!)] was deleted")
                        self.logout()
                    }
                }
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func sentVerifiedEmail() {
        if let user = FIRAuth.auth()?.currentUser {
            user.sendEmailVerification() { [unowned self] error in
                if let error = error {
                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                } else {
                    AppDelegate.showAlertMsg(withViewController: self, message: "Email verification has been sent to [\(user.email!)]. Please check your email and verify it. Then login again.")
                    self.logout()
                }
            }
        }
    }

}
