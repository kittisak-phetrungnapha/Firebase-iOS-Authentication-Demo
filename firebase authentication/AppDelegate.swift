//
//  AppDelegate.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 9/26/2559 BE.
//  Copyright © 2559 Kittisak Phetrungnapha. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        FIRApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation:[:])
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return true
    }
    
    // MARK: - Helper method
    static func showAlertMsg(withViewController vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func setRootViewControllerWith(viewIdentifier: String) {
        let vc = UIViewController.getViewControllerWith(viewControllerIdentifier: viewIdentifier)
        window?.rootViewController = vc
    }
    
}

// MARK: - GIDSignInDelegate
extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            AppDelegate.showAlertMsg(withViewController: (window?.rootViewController)!, message: error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { [unowned self] (user: FIRUser?, error: Error?) in
            if let error = error {
                AppDelegate.showAlertMsg(withViewController: (self.window?.rootViewController)!, message: error.localizedDescription)
            }
        })
    }
    
}
