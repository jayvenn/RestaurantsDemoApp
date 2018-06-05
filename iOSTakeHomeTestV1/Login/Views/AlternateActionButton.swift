//
//  AlternateActionButton.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

class AlternateActionButton: ActionButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBorder()
    }
    
    internal override func setColorScheme() {
        super.setColorScheme()
        backgroundColor = UIColor.white
        setTitleColor(.black, for: .normal)
    }
    
    fileprivate func setBorder() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
