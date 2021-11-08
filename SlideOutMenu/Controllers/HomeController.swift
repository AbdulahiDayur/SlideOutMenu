//
//  ViewController.swift
//  SlideOutMenu
//
//  Created by Abdul Dayur on 11/7/21.
//

import UIKit

class HomeController: UITableViewController {
    
    let menuController = MenuController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = .red
    }
    
    @objc func handleOpen() {
        menuController.view.frame = CGRect(x: 0, y: 0, width: 300, height: self.view.frame.height)
        
        // Displaying Content on a Connected Screen
        let mainWindow = UIApplication.shared.windows.first {$0.isKeyWindow}
        mainWindow?.addSubview(menuController.view)
        
        // adding second viewcontroller to parent for display
        addChild(menuController)
    }
    
    @objc func handleeHide() {
        menuController.view.removeFromSuperview()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(handleOpen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(handleeHide))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        
        return cell
    }

}

