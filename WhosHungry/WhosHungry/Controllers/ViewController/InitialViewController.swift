//
//  InitialViewController.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 4/15/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    // Mark: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var findFriendsButton: UIButton!
    
    // Mark: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    let findFriendsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lets Find Your Friends!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "Rockwell", size: 30)
        return button
    }()
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activateButton()
        self.titleLabel.UILabelTextShadow(color: UIColor.cyan)
        UIView.animate(withDuration: 3.0, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: {
            self.titleLabel.center = CGPoint(x: self.view.frame.maxX / 2, y: self.view.frame.maxY)
        }, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        addAllSubviews()
        findFriendsButton.anchor(top: nil, trailing: safeArea.trailingAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: -75, paddingLeft: 0, width: 100, height: 50)
    }
    
    func addAllSubviews() {
        view.addSubview(findFriendsButton)
    }
    
    private func activateButton() {
        findFriendsButton.addTarget(self, action: #selector(findFriendsButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func findFriendsButtonTapped(sender: UIButton) {
        switch sender {
        case findFriendsButton:
            segueToUserList()
        default:
            print("How did we even get here?")
        }
    }
    
    fileprivate func segueToUserList() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: "userListVC") as? UserListViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension UILabel {
    func UILabelTextShadow(color: UIColor) {
        self.textColor = .cyan
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
    }
}
