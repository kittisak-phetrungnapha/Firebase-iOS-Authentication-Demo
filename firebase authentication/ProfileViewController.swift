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
        self.navigationItem.rightBarButtonItem = logoutBarButton
        
        if let user = FIRAuth.auth()?.currentUser {
            providerIDValueLabel.text = user.providerID
            uidValueLabel.text = user.uid
            emailValueLabel.text = user.email
            nameValueLabel.text = user.displayName
            photoUrlValueLabel.text = user.photoURL?.absoluteString
            
            if user.isAnonymous {
                AppDelegate.showAlertMsg(withViewController: self, message: "You are an Anonymous!")
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
    
    func logout() {
        try! FIRAuth.auth()!.signOut()
        let loginNav = self.storyboard?.instantiateViewController(withIdentifier: "NavLoginViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginNav
    }

}
