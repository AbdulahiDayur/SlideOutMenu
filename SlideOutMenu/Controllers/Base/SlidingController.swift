//
//  SlidingController.swift
//  SlideOutMenu
//
//  Created by Abdul Dayur on 11/13/21.
//

import UIKit

class SlidingController: UIViewController {
    
    var redViewLeadingConstraint: NSLayoutConstraint!
    let menuWidth: CGFloat = 300
    var isMenuOpen = false
    
    let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let darkCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        setupViews()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var x = translation.x
        
        if isMenuOpen {
            x += menuWidth
        }
        x = min(menuWidth, x) // min drag of menuSlide left to right
        x = max(0,x)
        
        redViewLeadingConstraint.constant = x
        darkCoverView.alpha = x / menuWidth
//        print("\(x) / \(menuWidth) = \(darkCoverView.alpha)")
        if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if isMenuOpen {
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        }
        
        if translation.x < menuWidth / 2 {
            closeMenu()
        } else {
            openMenu()
        }
    }
    
    fileprivate func openMenu() {
        isMenuOpen = true
        redViewLeadingConstraint.constant = menuWidth
        performAnimations()
    }
    
    fileprivate func closeMenu() {
        isMenuOpen = false
        redViewLeadingConstraint.constant = 0
        performAnimations()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.darkCoverView.alpha = self.isMenuOpen ? 1 : 0
        })
    }
    
    fileprivate func setupViews() {
        view.addSubview(redView)
        view.addSubview(blueView)
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blueView.topAnchor.constraint(equalTo: view.topAnchor),
            blueView.trailingAnchor.constraint(equalTo: redView.leadingAnchor),
            blueView.widthAnchor.constraint(equalToConstant: menuWidth),
            blueView.bottomAnchor.constraint(equalTo: redView.bottomAnchor)
        ])
        
        redViewLeadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        redViewLeadingConstraint.isActive = true
        
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        let homeController = HomeController()
        let menuController = MenuController()
        
        let homeView = homeController.view!
        let menuView = menuController.view!
        
        redView.addSubview(homeView)
        redView.addSubview(darkCoverView)
        blueView.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            darkCoverView.topAnchor.constraint(equalTo: redView.topAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: redView.trailingAnchor)
        ])
        
        addChild(homeController)
        addChild(menuController)
        
    }
    
}
