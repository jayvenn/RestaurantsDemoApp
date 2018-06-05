//
//  UserAccountViewController.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import SnapKit

// MARK: UserAccountViewController
class UserAccountViewController: UIViewController {
    
    // MARK: UserAccountViewController - Properties
    lazy var logOutButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(UserAccountViewController.logOutButtonDidTouch(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func logOutButtonDidTouch(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: UserAccountViewController - Life Cycle
extension UserAccountViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        setUpLayout()
    }
}

// MARK: UserAccountViewController - UI, Layout, Overhead
extension UserAccountViewController {
    fileprivate func setUpLayout() {
        view.addSubviews(views: [logOutButton])
        logOutButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leadingMargin.equalTo(view.snp.leadingMargin).offset(40)
            make.trailingMargin.equalTo(view.snp.trailingMargin).offset(-40)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
        }
    }
}
