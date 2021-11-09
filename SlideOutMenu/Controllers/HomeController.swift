//
//  ViewController.swift
//  SlideOutMenu
//
//  Created by Abdul Dayur on 11/7/21.
//

import UIKit

class HomeController: UITableViewController {
    
    let menuController = MenuController()
    let menuWidth: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .red
        setupNavigationItems()
    }
    
    override func viewDidLayoutSubviews() {
        setupMenuController()
    }
    
    fileprivate func performAnimations(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut,
           animations: {
            self.menuController.view.transform = transform
            self.view.transform = transform
//            self.navigationController?.view.transform = transform
           })
    }
    
    @objc func handleOpen() {
        performAnimations(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleHide() {
        performAnimations(transform: .identity)
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(handleOpen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(handleHide))
    }
    
    fileprivate func setupMenuController() {
        // initial position of menuController (before animation)
        menuController.view.frame = CGRect(x: -menuWidth, y: 0, width: 300, height: self.view.frame.height)
        let mainWindow = UIApplication.shared.windows.first {$0.isKeyWindow}
        mainWindow?.addSubview(menuController.view) 
        addChild(menuController) // adding second viewcontroller to parentVC for display
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

