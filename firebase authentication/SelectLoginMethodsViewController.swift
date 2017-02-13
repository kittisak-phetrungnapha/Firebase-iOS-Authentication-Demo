//
//  SelectLoginMethodsViewController.swift
//  firebase authentication
//
//  Created by Kittisak Phetrungnapha on 2/13/2560 BE.
//  Copyright © 2560 Kittisak Phetrungnapha. All rights reserved.
//

import UIKit

class SelectLoginMethodsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    fileprivate let cellIdentifier = "cell"
    fileprivate var dataSource: [String]!
    
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
        
    }
    
}
