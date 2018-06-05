//
//  ActionButton.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFont()
        setColorScheme()
        setCornerRadius()
    }
    
    fileprivate func setFont() {
        titleLabel?.font = Font(object: .button).instance
    }
    
    fileprivate func setCornerRadius() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    func setColorScheme() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .selected)
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
