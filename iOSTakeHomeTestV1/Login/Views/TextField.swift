//
//  TextField.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setFont()
        setBorderStyle()
    }
    
    fileprivate func setFont() {
        font = Font(object: .textField).instance
    }
    
    fileprivate func setBorderStyle() {
        borderStyle = .roundedRect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
