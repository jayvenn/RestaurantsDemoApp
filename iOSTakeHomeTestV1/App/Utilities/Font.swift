//
//  FontBook.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 3/28/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

enum UIObject {
    case titleLabel, subTitleLabel, textField, button
}

struct Font {
    
    enum FontName: String {
        case robotoBlack = "Roboto-Black"
        case robotoBlackItalic = "Roboto-BlackItalic"
        case robotoBold = "Roboto-Bold"
        case robotoBoldItalic = "Roboto-BoldItalic"
        case robotoItalic = "Roboto-Italic"
        case robotoLight = "Roboto-Light"
        case robotoLightItalic = "Roboto-LightItalic"
        case robotoMedium = "Roboto-Medium"
        case robotoMediumItalic = "Roboto-MediumItalic"
        case robotoRegular = "Roboto-Regular"
        case robotoThin = "Roboto-Thin"
        case robotoThinItalic = "Roboto-ThinItalic"
    }
    
    enum StandardSize: Double {
        case h1 = 36
        case h2 = 16
        case h3 = 14
    }
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    var type: FontType
    var size: FontSize
    
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
    
    init(object: UIObject) {
        switch object {
        case .titleLabel:
            type = FontType.installed(.robotoMedium)
            size = FontSize.standard(.h1)
        case .subTitleLabel:
            type = FontType.installed(.robotoLight)
            size = FontSize.standard(.h3)
        case .textField:
            type = FontType.installed(.robotoRegular)
            size = FontSize.standard(.h2)
        case .button:
            type = FontType.installed(.robotoBold)
            size = FontSize.standard(.h2)
//        default:
//            type = FontType.installed(.robotoRegular)
//            size = FontSize.standard(.h3)
        }
    }
    
    static func logAvailableFonts() {
        UIFont.familyNames.forEach { (familyName) in
            print("Font Family:", familyName)
            UIFont.fontNames(forFamilyName: familyName).forEach({ (fontName) in
                print("Font Name:", familyName)
            })
        }
    }
    
}

extension Font {
    var instance: UIFont {
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it is added in Info.plist and logged with FontBook.logAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it is added in Info.plist and logged with FontBook.logAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}


