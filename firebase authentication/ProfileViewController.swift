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
        } else {
            let alert = UIAlertController(title: "Message", message: "No user is signed in", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                self.logout()
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Method
    
    func setUserDataToView(withFIRUser user: FIRUser) {
        providerIDValueLabel.text = user.providerID
        uidValueLabel.text = user.uid
        emailValueLabel.text = user.email
        nameValueLabel.text = user.displayName
        photoUrlValueLabel.text = user.photoURL?.absoluteString
    }
    
    func logout() {
        try! FIRAuth.auth()!.signOut()
        let loginNav = self.storyboard?.instantiateViewController(withIdentifier: "NavLoginViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginNav
    }
    
    func manageProfile() {
        let manageActionSheet = UIAlertController(title: "Select menu", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let changeUserInfoAction = UIAlertAction(title: "Change name and image", style: .default) { (action: UIAlertAction) in
            self.changeUserInfo()
        }
        let changeEmailAction = UIAlertAction(title: "Change Email", style: .default) { (action: UIAlertAction) in
            
        }
        let changePasswordAction = UIAlertAction(title: "Change Password", style: .default) { (action: UIAlertAction) in
            
        }
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .default) { (action: UIAlertAction) in
            
        }
        
        manageActionSheet.addAction(changeUserInfoAction)
        manageActionSheet.addAction(changePasswordAction)
        manageActionSheet.addAction(changeEmailAction)
        manageActionSheet.addAction(deleteAccountAction)
        manageActionSheet.addAction(cancelAction)
        
        self.present(manageActionSheet, animated: true, completion: nil)
    }
    
    func changeUserInfo() {
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
                changeRequest.commitChanges { error in
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

}
