//
//  Extensions.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 3/28/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import SceneKit

// UIColor Extension
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    open class var darkBlue: UIColor {
        return UIColor.rgb(red: 29, green: 36, blue: 46)
    }
    
    open class var seperatorGray: UIColor {
        return UIColor.lightGray
    }
    
    struct TabBarItem {
        static let selected = UIColor.black
        static let unselected = UIColor.rgb(red: 106, green: 113, blue: 123)
    }
}

// UIView Extension
extension UIView {
    func addSubviews(views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    // UIView Extension - Animation
    func fadeAndAway() {
        self.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        }) { (complete) in
            UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseOut, animations: {
                self.alpha = 0
            }, completion: nil)
        }
    }
    
    func fadeIn() {
        self.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    func fadeOut() {
        self.alpha = 1
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }, completion: nil)
    }
    
    func fadeOutAndRemove(view: UIView) {
        UIView.animate(withDuration: 1, animations: {
            view.alpha = 0
        }) { (_) in
            view.removeFromSuperview()
        }
    }
}

// String Extension
extension String  {
    func replaceWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func replacePunctuationCharacters() -> String {
        return components(separatedBy: .punctuationCharacters).joined()
    }
}


// float4x5 Extension
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

// SCNNode Extension
extension SCNNode {
    func getSphereNode(withPosition position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        sphereNode.position.y += Float(sphere.radius) + 1
        
        return sphereNode
    }
    
    func update(withGeometry geometry: SCNGeometry, type: SCNPhysicsBodyType) {
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: type, shape: shape)
        self.physicsBody = physicsBody
    }
}

public func getNode(named name: String) -> SCNNode {
    guard let scene = SCNScene(named: "\(name).scn"),
        let node = scene.rootNode.childNode(withName: name, recursively: true)  else { return SCNNode() }
    return node
}


