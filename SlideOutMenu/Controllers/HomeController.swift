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
    let velocityOpenThreshold: CGFloat = 500
    var isMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .red
        
        setupNavigationItems()
        
        setupPanGesture()
        setupDarkCoverView()
    }
    
    override func viewDidLayoutSubviews() {
        setupMenuController()
//        setupDarkCoverView()
    }
    
    let darkCoverView = UIView()
    fileprivate func setupDarkCoverView() {
        darkCoverView.alpha = 0
        darkCoverView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        darkCoverView.isUserInteractionEnabled = false
        
        let mainWindow = UIApplication.shared.windows.first {$0.isKeyWindow}
        mainWindow?.addSubview(darkCoverView)
        
        darkCoverView.frame = mainWindow?.frame ?? .zero
    }
    
    fileprivate func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            var x = translation.x
            
            if isMenuOpen {
                x += menuWidth
            }
            
//            x = min(menuWidth, x)
            x = max(0,x)
            
            // drag out menuVC with panGesture
            let transform = CGAffineTransform(translationX: x, y: 0)
            menuController.view.transform = transform
            navigationController?.view.transform = transform
            darkCoverView.alpha = x / menuWidth
        } else if gesture.state == .ended {
           handleEnded(gesture: gesture)
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        print(velocity.x)
        if isMenuOpen {
            if velocity.x > abs(velocityOpenThreshold) {
                handleHide()
                return
            }

            if abs(translation.x) < menuWidth / 2 {
                handleOpen()
            } else {
                handleHide()
            }
        } else {
            if velocity.x > velocityOpenThreshold {
                handleOpen()
                return
            }
            
            if translation.x < menuWidth / 2 {
                handleHide()
            } else {
                handleOpen()
            }
        }
    }
    
    fileprivate func performAnimations(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut,
           animations: {
            self.menuController.view.transform = transform
//            self.view.transform = transform
            self.navigationController?.view.transform = transform
            self.darkCoverView.alpha = transform == .identity ? 0 : 1
           })
    }
    
    @objc func handleOpen() {
        isMenuOpen = true
        performAnimations(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleHide() {
        isMenuOpen = false
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

