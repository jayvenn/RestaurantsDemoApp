//
//  ARViewController.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import ARKit

private let scaleFactor: Float = 0.02
private let scaleFactorAlternative: Float = 0.20
private let eulerYAngle = 90
private let eulerXAngle = 0
private let eulerZAngle = 0

// MARK: ARViewController
final class ARViewController: UIViewController {
    
    // MARK: ARViewController - Properties
    let sceneView = ARSCNView(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 600.0))
    
    let rainParticleSystem = SCNParticleSystem.rain
    
    let rainView: UIView = {
        let view = UIView()
        view.backgroundColor = .transparentTextBackgroundBlack
        return view
    }()
    
    let seedNode = SCNNode.seed
    let hole1Node = SCNNode.hole1
    let hole2Node = SCNNode.hole2
    let hole3Node = SCNNode.hole3
    let floorPlaneNode = SCNNode.floorPlane
    let treeNode = SCNNode.tree
    let applesNode = SCNNode.apples
    let cloudNode = SCNNode.cloud
    
    let seedYDistance: Float = 0.2
    
    let alphaToZeroAction = SCNAction.fadeOpacity(to: 0, duration: 0.5)
    let alphaToOneAction = SCNAction.fadeOpacity(to: 1, duration: 0)
    
    let holeNodeYAllevation: Float = 2 * scaleFactor
    
    lazy var appleNames: [String] = {
        var names = [String]()
        for node in applesNode.childNodes {
            if let name = node.name {
                names.append(name)
            }
        }
        return names
    }()
    
    lazy var sunnyWeatherPlayer: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "SunnyWeather", withExtension: "m4a")!)
        player.numberOfLoops = -1
        player.volume = 1
        player.prepareToPlay()
        return player
    }()
    
    lazy var rainyWeatherPlayer: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "RainyWeather", withExtension: "m4a")!)
        player.volume = 1
        player.numberOfLoops = -1
        player.prepareToPlay()
        return player
    }()
    
    lazy var rainPlayer: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Rain", withExtension: "m4a")!)
        player.volume = 0.5
        player.numberOfLoops = -1
        player.prepareToPlay()
        return player
    }()
    
    lazy var postIntroduction1Player: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "name", withExtension: "m4a")!)
        player.volume = 1
        player.prepareToPlay()
        return player
    }()
    
    lazy var postIntroduction2Player: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "oxygen", withExtension: "m4a")!)
        player.volume = 1
        player.prepareToPlay()
        return player
    }()
    
    lazy var postIntroduction3Player: AVAudioPlayer = {
        let player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "thanks", withExtension: "m4a")!)
        player.volume = 1
        player.prepareToPlay()
        return player
    }()
    
    lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "MOVE AROUND TO FIND A SURFACE\nTO PLANT YOUR SEED!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.backgroundColor = .white
        label.backgroundColor = .transparentTextBackgroundWhite
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    var instructionLabelHeightConstraint: NSLayoutConstraint?
    
    lazy var plantButton: UIButton = {
        let button = UIButton()
        button.setTitle("TAP HERE TO PLANT SEED", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(ARViewController.plantSeedButtonDidTouch(_:)), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .plantButtonBackground
        return button
    }()
    
    var foundSurface = false
    var gameStarted = false
    var gamePosition = SCNVector3(0,0,0)
    
    override func loadView() {
        super.loadView()
        setUpSceneView()
        resetTrackingConfiguration()
        setUpLayouts()
        animateIntroductionScene()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sunnyWeatherPlayer.stop()
    }
    
    func computeHolePosition(vector3: SCNVector3) -> SCNVector3 {
        var position = vector3
        position.y -= holeNodeYAllevation
        return vector3
    }
    
    func computeGamePosition(vector3: SCNVector3) -> SCNVector3 {
        var position = vector3
        position.y += holeNodeYAllevation
        return vector3
    }
}

// MARK: ARViewController - Animation
extension ARViewController {
    
    func seedPlacementAnimation() {
        postIntroduction2Player.play()
        UIView.animate(withDuration: 1, animations: {
            self.instructionLabel.alpha = 0
            self.plantButton.alpha = 0
        }) { (_) in
            self.instructionLabel.isHidden = true
            self.plantButton.isHidden = true
            //            self.instructionLabel.removeFromSuperview()
            
            self.openHoleAnimation()
        }
    }
    
    var fadeInAndOutSequenceAction: SCNAction {
        return .sequence([
            .fadeOpacity(to: 1, duration: 1),
            .wait(duration: 2),
            .fadeOpacity(to: 0, duration: 0)
            ])
    }
    
    var fadeInSequenceAction: SCNAction {
        return .sequence([
            .fadeOpacity(to: 1, duration: 1),
            .wait(duration: 2),
            ])
    }
    
    var fadeOutSequenceAction: SCNAction {
        return .sequence([
            .fadeOpacity(to: 0, duration: 1),
            ])
    }
    
    var waitSequenceAction: SCNAction {
        return .sequence([
            .wait(duration: 1)
            ])
    }
    
    var longWaitSequenceAction: SCNAction {
        return .sequence([
            .wait(duration: 3)
            ])
    }
    
    var veryLongWaitSequenceAction: SCNAction {
        return .sequence([
            .wait(duration: 6)
            ])
    }
    
    var moveBackAndForthSequenceAction: SCNAction {
        return .sequence([
            SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 3),
            SCNAction.moveBy(x: 0, y: 0, z: 2, duration: 6),
            SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 3)
            ])
    }
    
    func growInSizeSequenceAction(_ node: SCNNode) -> SCNAction {
        let scale = node.scale
        
        let scale1 = vector(scaledFrom: scale, by: 0.1)
        let scale2 = vector(scaledFrom: scale, by: 0.4)
        let scale3 = vector(scaledFrom: scale, by: 0.3)
        let scale4 = vector(scaledFrom: scale, by: 0.7)
        let scale5 = vector(scaledFrom: scale, by: 0.6)
        let scale6 = vector(scaledFrom: scale, by: 1.1)
        let scale7 = vector(scaledFrom: scale, by: 1.0)
        
        return .sequence([
            SCNAction.scale(to: scale1, duration: 0),
            SCNAction.fadeIn(duration: 1),
            SCNAction.scale(to: scale2, duration: 1.5),
            SCNAction.scale(to: scale3, duration: 0.5),
            SCNAction.scale(to: scale4, duration: 1.5),
            SCNAction.scale(to: scale5, duration: 0.5),
            SCNAction.scale(to: scale6, duration: 1.5),
            SCNAction.scale(to: scale7, duration: 0.5)
            ])
    }
    
    func vector(scaledFrom vector: SCNVector3, by scale: Float) -> CGFloat {
        //        return SCNVector3(vector.x * scale, vector.y * scale, vector.z * scale)
        return CGFloat(vector.y * scale)
    }
    
    func openHoleAnimation() {
        hole1Node.position = computeHolePosition(vector3: gamePosition)
        hole2Node.position = computeHolePosition(vector3: gamePosition)
        
        hole1Node.opacity = 0
        hole2Node.opacity = 0
        hole3Node.opacity = 0
        
        addNodesToSceneView(nodes: [hole1Node, hole2Node])
        hole3Node.runAction(fadeInAndOutSequenceAction) {
            self.hole2Node.runAction(self.fadeInAndOutSequenceAction) {
                self.hole1Node.runAction(self.fadeInSequenceAction) {
                    let action = SCNAction.moveBy(x: 0, y: -CGFloat(self.seedYDistance), z: 0, duration: 2)
                    action.timingMode = .easeIn
                    self.seedNode.runAction(action) {
                        self.closeHoleAnimation()
                    }
                }
            }
        }
        
    }
    
    func closeHoleAnimation() {
        hole1Node.runAction(fadeInAndOutSequenceAction) {
            self.hole2Node.runAction(self.fadeInAndOutSequenceAction) {
                self.hole3Node.runAction(self.fadeInSequenceAction) {
                    self.hole3Node.runAction(self.fadeOutSequenceAction)
                    self.seedNode.runAction(self.fadeOutSequenceAction) {
                        self.hole1Node.removeFromParentNode()
                        self.hole2Node.removeFromParentNode()
                        self.hole3Node.removeFromParentNode()
                        DispatchQueue.main.async {
                            self.growIntoFlowerAnimation()
                        }
                    }
                }
            }
        }
    }
    
    func growIntoFlowerAnimation() {
        postIntroduction3Player.play()
        let holeAndLeaf1Node = SCNNode.holeAndLeaf1
        let holeAndLeaf2Node = SCNNode.holeAndLeaf2
        let holeAndLeaf3Node = SCNNode.holeAndLeaf3
        
        holeAndLeaf1Node.position = computeHolePosition(vector3: gamePosition)
        holeAndLeaf2Node.position = computeHolePosition(vector3: gamePosition)
        holeAndLeaf3Node.position = computeHolePosition(vector3: gamePosition)
        
        holeAndLeaf1Node.opacity = 0
        holeAndLeaf2Node.opacity = 0
        holeAndLeaf3Node.opacity = 0
        
        holeAndLeaf3Node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        sceneView.scene.rootNode.addChildNode(holeAndLeaf1Node)
        
        cloudNode.position = gamePosition
        cloudNode.position.y += 2.0
        
        cloudNode.opacity = 0
        
        
        rainParticleSystem.colliderNodes = [floorPlaneNode, holeAndLeaf1Node, holeAndLeaf2Node, holeAndLeaf3Node]
        
        holeAndLeaf1Node.runAction(self.fadeInAndOutSequenceAction) {
            self.sceneView.scene.rootNode.addChildNode(holeAndLeaf2Node)
            holeAndLeaf2Node.runAction(self.fadeInAndOutSequenceAction) {
                self.sceneView.scene.rootNode.addChildNode(holeAndLeaf3Node)
                holeAndLeaf3Node.runAction(self.fadeInSequenceAction) {
                    self.sceneView.scene.rootNode.addChildNode(self.cloudNode)
                    self.cloudNode.addParticleSystem(self.rainParticleSystem)
                    self.cloudNode.runAction(self.fadeInSequenceAction) {
                        self.cloudNode.runAction(self.veryLongWaitSequenceAction) {
                            holeAndLeaf3Node.runAction(self.fadeOutSequenceAction) {
                                holeAndLeaf1Node.removeFromParentNode()
                                holeAndLeaf2Node.removeFromParentNode()
                                holeAndLeaf3Node.removeFromParentNode()
                                self.cloudNode.removeAllParticleSystems()
                                DispatchQueue.main.async {
                                    self.growIntoATree()
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func growIntoATree() {
        sunnyWeatherPlayer.play()
        
        treeNode.position = gamePosition
        applesNode.position = gamePosition
        
        treeNode.opacity = 0
        applesNode.opacity = 0
        
        sceneView.scene.rootNode.addChildNode(treeNode)
        sceneView.scene.rootNode.addChildNode(applesNode)
        
        let moveUpAction = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 3)
        let foreverAction = SCNAction.repeatForever(moveBackAndForthSequenceAction)
        
        cloudNode.runAction(moveUpAction) {
            self.cloudNode.runAction(foreverAction)
        }
        
        let scalingAction = growInSizeSequenceAction(treeNode)
        treeNode.runAction(scalingAction) {
            self.treeNode.runAction(self.fadeInSequenceAction) {
                self.applesNode.runAction(self.waitSequenceAction) {
                    self.applesNode.runAction(self.fadeInSequenceAction) {
                        self.applesNode.runAction(self.longWaitSequenceAction) {
                            DispatchQueue.main.async {
                                self.appleDropFromTree()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func appleDropFromTree() {
        
        let appleNodeName = "apple8"
        for node in applesNode.childNodes {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.didTap(withGestureRecognizer:)))
            sceneView.addGestureRecognizer(tapGestureRecognizer)
            if node.name == appleNodeName {
                DispatchQueue.main.async {
                    self.animateAppleNode(node: node)
                    self.noteForApple()
                }
            }
        }
        
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else { return }
        animateAppleNode(node: node)
    }
    
    func animateAppleNode(node: SCNNode) {
        guard let name = node.name,
            appleNames.contains(name),
            !node.hasActions
            else { return }
        
        let originalPosition = node.position
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        let moveToPositionAction = SCNAction.move(to: originalPosition, duration: 1)
        
        DispatchQueue.main.async {
            node.physicsBody = physicsBody
            node.runAction(self.veryLongWaitSequenceAction) {
                node.runAction(self.fadeOutSequenceAction) {
                    node.physicsBody = nil
                    node.position = originalPosition
                    node.runAction(moveToPositionAction) {
                        node.runAction(self.fadeInSequenceAction) {
                            
                        }
                    }
                }
            }
        }
    }
    
    func noteForApple() {
        instructionLabel.numberOfLines = 5
        
        instructionLabel.isHidden = false
        instructionLabel.alpha = 1
        instructionLabelHeightConstraint?.constant = 88
        
        plantButton.isHidden = false
        plantButton.alpha = 1
        plantButton.setTitle("Thank You!", for: .normal)
        
        plantButton.removeTarget(nil, action: nil, for: .allEvents)
        plantButton.addTarget(self, action: #selector(ARViewController.closeAR), for: .touchUpInside)
        
        let when1 = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when1) {
            let text = "You can tap on an Apple to have a closer at it look on the ground! Check out the Apples!"
            self.instructionLabel.text = text
            let when2 = DispatchTime.now() + 18
            DispatchQueue.main.asyncAfter(deadline: when2) {
                let text = "I hope you have enjoyed the Playground!"
                self.instructionLabel.text = text
            }
        }
        
    }
    
    @objc fileprivate func closeAR() {
        dismiss(animated: true)
    }
    
    func animateIntroductionScene() {
        postIntroduction1Player.play()
        UIView.animate(withDuration: 1, animations: {
            self.instructionLabel.alpha = 1
            self.plantButton.alpha = 1
        }) { (_) in
            
        }
    }
}

// MARK: ARViewController - IBAction Methods
extension ARViewController {
    @objc func plantSeedButtonDidTouch(_ sender: UIButton) {
        guard foundSurface,
            !gameStarted else {
                return
        }
        
        gamePosition = computeGamePosition(vector3: hole3Node.position)
        
        let physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floorPlaneNode.physicsBody = physicsBody
        floorPlaneNode.position = gamePosition
        sceneView.scene.rootNode.addChildNode(floorPlaneNode)
        
        gameStarted = true
        self.seedPlacementAnimation()
    }
}

// MARK: ARViewController - Set Up and Layouts
extension ARViewController {
    func setUpSceneView() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session = ARSession()
        sceneView.delegate = self
        view = sceneView
    }
    
    func setUpLayouts() {
        setUpInstructionLabelLayouts()
        setUpPlantButtonLayouts()
    }
    
    func setUpInstructionLabelLayouts() {
        view.addSubview(instructionLabel)
        instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        instructionLabelHeightConstraint = instructionLabel.heightAnchor.constraint(equalToConstant: 52)
        instructionLabelHeightConstraint?.isActive = true
    }
    
    func setUpPlantButtonLayouts() {
        view.addSubview(plantButton)
        plantButton.leadingAnchor.constraint(equalTo: instructionLabel.leadingAnchor, constant: 8).isActive = true
        plantButton.trailingAnchor.constraint(equalTo: instructionLabel.trailingAnchor, constant: -8).isActive = true
        plantButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plantButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        plantButton.widthAnchor.constraint(equalToConstant: 88).isActive = true
        plantButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func resetTrackingConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
}

// MARK: ARViewController - SceneKit
extension ARViewController {
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            guard !self.gameStarted,
                let hitTestResult = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY),
                                                      types: [.existingPlaneUsingExtent,
                                                              .estimatedHorizontalPlane]).first
                else {
                    return
            }
            let translation = hitTestResult.worldTransform.translation
            let position = self.vector(from: translation)
            self.hole3Node.position = self.computeHolePosition(vector3: position)
            self.seedNode.position = SCNVector3(self.hole3Node.position.x, self.hole3Node.position.y + self.seedYDistance, self.hole3Node.position.z)
            if !self.foundSurface {
                self.foundSurface = true
                self.sceneView.scene.rootNode.addChildNode(self.hole3Node)
                self.sceneView.scene.rootNode.addChildNode(self.seedNode)
            }
        }
    }
    
}

extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //        gameStarted = true
        //        animateScene2()
    }
    
    func update(_ node: inout SCNNode, withGeometry geometry: SCNGeometry, type: SCNPhysicsBodyType) {
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: type, shape: shape)
        node.physicsBody = physicsBody
    }
}

extension ARViewController: ARSessionDelegate {
    
}

extension ARViewController {
    func addNodesToSceneView(nodes: [SCNNode]) {
        let rootNode = sceneView.scene.rootNode
        for node in nodes {
            rootNode.addChildNode(node)
        }
    }
    
    func centerExtentVector(from planeAnchor: ARPlaneAnchor) -> SCNVector3 {
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        return SCNVector3(x, y, z)
    }
    
    func vector(from translation: float3) -> SCNVector3 {
        let x = translation.x
        let y = translation.y
        let z = translation.z
        return SCNVector3(x, y, z)
    }
    
    func cameraVectors() -> (SCNVector3, SCNVector3)? {
        guard let frame = self.sceneView.session.currentFrame else { return nil }
        let transform = SCNMatrix4(frame.camera.transform)
        let directionFactor: Float = -5
        let direction = SCNVector3(directionFactor * transform.m31, directionFactor * transform.m32, directionFactor * transform.m33)
        let position = SCNVector3(transform.m41, transform.m42, transform.m43)
        return (direction, position)
    }
}

extension SCNNode {
    
    open class var hole1: SCNNode {
        guard let scene = SCNScene(named: "hole1.scn"),
            let node = scene.rootNode.childNode(withName: "hole1", recursively: true)
            else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.position.y = Float(-2 * scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var hole2: SCNNode {
        guard let scene = SCNScene(named: "hole2.scn"),
            let node = scene.rootNode.childNode(withName: "hole2", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.position.y = Float(-2 * scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var hole3: SCNNode {
        guard let scene = SCNScene(named: "hole3.scn"),
            let node = scene.rootNode.childNode(withName: "hole3", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.position.y = Float(-2 * scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var flatHole: SCNNode {
        guard let scene = SCNScene(named: "flatHole.scn"),
            let node = scene.rootNode.childNode(withName: "flatHole", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.position.y = Float(-2 * scaleFactor)
        node.castsShadow = true
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var seed: SCNNode {
        guard let scene = SCNScene(named: "seed.scn"),
            let node = scene.rootNode.childNode(withName: "seed", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var holeAndLeaf1: SCNNode {
        guard let scene = SCNScene(named: "holeAndLeaf1.scn"),
            let node = scene.rootNode.childNode(withName: "holeAndLeaf1", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var holeAndLeaf2: SCNNode {
        guard let scene = SCNScene(named: "holeAndLeaf2.scn"),
            let node = scene.rootNode.childNode(withName: "holeAndLeaf2", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var holeAndLeaf3: SCNNode {
        guard let scene = SCNScene(named: "holeAndLeaf3.scn"),
            let node = scene.rootNode.childNode(withName: "holeAndLeaf3", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var cloud: SCNNode {
        guard let scene = SCNScene(named: "cloud.scn"),
            let node = scene.rootNode.childNode(withName: "cloud", recursively: true)  else { return SCNNode() }
        node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var tree: SCNNode {
        guard let scene = SCNScene(named: "simpleTree.scn"),
            let node = scene.rootNode.childNode(withName: "simpleTree", recursively: true) else { return SCNNode() }
        node.scale = SCNVector3(scaleFactorAlternative, scaleFactorAlternative, scaleFactorAlternative)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var apples: SCNNode {
        // guard let scene = SCNScene(named: "apples.scn") else { return SCNNode() }
        guard let scene = SCNScene(named: "applesSizeVariation.scn") else { return SCNNode() }
        let node = scene.childNodesNode()
        node.scale = SCNVector3(scaleFactorAlternative, scaleFactorAlternative, scaleFactorAlternative)
        node.eulerAngles = SCNVector3().defaultEulerAngles
        return node
    }
    
    open class var floorPlane: SCNNode {
        let length: CGFloat = 3
        let plane = SCNPlane(width: length, height: length)
        plane.materials.first?.diffuse.contents = UIColor.clear
        let node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
        return node
    }
    
}

extension SCNParticleSystem {
    open class var rain: SCNParticleSystem {
        guard let particleSystem = SCNParticleSystem(named: "rainParticleSystem", inDirectory: nil) else { return SCNParticleSystem() }
        particleSystem.particleDiesOnCollision = true
        return particleSystem
    }
}

extension SCNScene {
    func childNodesNode() -> SCNNode {
        let node = SCNNode()
        let sceneChildNodes = self.rootNode.childNodes
        for childNode in sceneChildNodes {
            node.addChildNode(childNode)
        }
        return node
    }
}


extension UIColor {
    
    open class var transparentWhite: UIColor {
        return UIColor.white.withAlphaComponent(0.20)
    }
    
    open class var transparentTextBackgroundWhite: UIColor {
        return UIColor.white.withAlphaComponent(0.80)
    }
    
    open class var transparentTextBackgroundBlack: UIColor {
        return UIColor.black.withAlphaComponent(0.80)
    }
    
    open class var plantButtonBackground: UIColor {
        return UIColor.rgb(red: 46, green: 204, blue: 112)
    }
}

extension SCNVector3 {
    var defaultEulerAngles: SCNVector3 {
        return SCNVector3(0, eulerYAngle, 0)
    }
}
