//
//  ViewController.swift
//  Smilie
//
//  Created by Nadya Postriganova on 5/2/19.
//  Copyright © 2019 Nadya Postriganova. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    let sceneView = ARSCNView()
    let smileLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Make sure your device supports ARKit
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Device does not support face tracking")
        }
        
        // Get permission to access your device’s camera
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if (granted) {
                DispatchQueue.main.sync {
                    // We're going to implement this function in a minute
                    self.setupSmileTracker()
                }
            } else {
                fatalError("User did not grant camera permission!")
            }
        }
        // Add Privacy — Camera Usage Description into info.plist
    }
    
    //  Handle face tracking
    func setupSmileTracker() {
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.delegate = self
        view.addSubview(sceneView)
        
        //  basic UI properties to our smileLabel and setting its constraints so it is in the middle of the screen
        smileLabel.text = "😐"
        smileLabel.font = UIFont.systemFont(ofSize: 150)
        view.addSubview(smileLabel)
        // Set constraints
        smileLabel.translatesAutoresizingMaskIntoConstraints = false
        smileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        smileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    
    func renderer(_renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1 renderer will run every time our scene updates and provides us with the ARAnchor that corresponds to the user’s face
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        
        // 2 blendShapes is a dictionary that stores coefficients corresponding to various facial features
        let leftSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
        let rightSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
        
        
        // 3
        //print(leftSmileValue, rightSmileValue)
        
        DispatchQueue.main.async {
            self.handleSmile(leftValue: leftSmileValue, rightValue: rightSmileValue)
        }
    }
    
    // change the emoji in our smileLabel depending on how much the user is smiling into the camera
    func handleSmile(leftValue: CGFloat, rightValue: CGFloat) {
        let smileValue = (leftValue + rightValue)/2.0
        switch smileValue {
        case _ where smileValue > 0.5:
            smileLabel.text = "😁"
        case _ where smileValue > 0.2:
            smileLabel.text = "🙂"
        default:
            smileLabel.text = "😐"
        }
    }
    
    
}

