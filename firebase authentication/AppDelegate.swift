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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        FIRApp.configure()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        return true
    }

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

