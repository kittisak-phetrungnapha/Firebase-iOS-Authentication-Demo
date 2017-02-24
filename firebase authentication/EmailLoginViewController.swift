//
//  EmailLoginViewController.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 9/26/2559 BE.
//  Copyright © 2559 Kittisak Phetrungnapha. All rights reserved.
//

import UIKit
import FirebaseAuth
import IQKeyboardManagerSwift

class EmailLoginViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var authListener: FIRAuthStateDidChangeListenerHandle?
    
    // MARK: - Action
    @IBAction func loginButtonTouch(_ sender: AnyObject) {
        // TODO: - Perform email sign in.
    }
    
    @IBAction func registerButtonTouch(_ sender: AnyObject) {
        // TODO: - Perform email register.
    }
    
    @IBAction func resetPasswordButtonTouch(_ sender: AnyObject) {
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: nil, preferredStyle: .alert)
        resetPasswordAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your email"
            textField.clearButtonMode = .whileEditing
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let textField = resetPasswordAlert.textFields![0]
            
            // TODO: - Reset password
        }
        
        resetPasswordAlert.addAction(cancelAction)
        resetPasswordAlert.addAction(confirmAction)
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login with Email"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Register auth listener
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let _ = IQKeyboardManager.sharedManager().resignFirstResponder()
        
        // TODO: - Unregister auth listener
    }

}
