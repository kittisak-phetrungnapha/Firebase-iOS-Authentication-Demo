//
//  MyViewControllerExtension.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 2/13/2560 BE.
//  Copyright © 2560 Kittisak Phetrungnapha. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func getViewControllerWith(storyboardName: String = "Main", viewControllerIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
    
}
