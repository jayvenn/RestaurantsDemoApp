//
//  ARIntroductionViewController.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import AVFoundation
import ARKit
import SwiftSpinner

// MARK: IntroductionARViewController
class IntroductionARViewController: UIViewController {
    
    // MARK: IntroductionARViewController - Properties
    let scaleFactor: Float = 0.02
    let scaleFactorAlternative: Float = 0.20
    let eulerYAngle = 90
    let eulerXAngle = 0
    let eulerZAngle = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello there"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .darkGray
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you ready to plant a seed?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .lightGray
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var player: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "introduction", withExtension: "m4a")!)
        player.volume = 1
        player.prepareToPlay()
        return player
    }()
    
    lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "TAP TO BEGIN"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    @objc func didTapView(_ view: UIView) {
        DispatchQueue.main.async {
            guard ARConfiguration.isSupported,
                !Platform.isSimulator else {
                SwiftSpinner.show(duration: 2, title: "Device is AR incompatible")
                return
            }
            self.present(ARViewController(), animated: true)
        }
    }
}

// MARK: IntroductionARViewController - Life Cycles
extension IntroductionARViewController {

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setUpLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.stop()
    }
    
}

// MARK: IntroductionARViewController - UI, Layout, Overhead
extension IntroductionARViewController {
    fileprivate func setUpLayouts() {
        view.addSubviews(views: [
            titleLabel,
            subTitleLabel,
            instructionLabel
            ])
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        instructionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        animateText()
    }
    
    fileprivate func animateText() {
        let when = DispatchTime.now() + 2
        titleLabel.fadeIn()
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.subTitleLabel.fadeIn()
            let when = DispatchTime.now() + 3.3
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IntroductionARViewController.didTapView(_:)))
                self.view.addGestureRecognizer(tapGestureRecognizer)
                self.instructionLabel.fadeIn()
            })
        }
    }

}
