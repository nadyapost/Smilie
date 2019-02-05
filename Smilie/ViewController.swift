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
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Device does not support face tracking")
        }
        
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
    }


    func setupSmileTracker() {
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.delegate = self
        view.addSubview(sceneView)
        
        smileLabel.text = "😐"
        smileLabel.font = UIFont.systemFont(ofSize: 150)
        view.addSubview(smileLabel)
        // Set constraints
        smileLabel.translatesAutoresizingMaskIntoConstraints = false
        smileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        smileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    func renderer(_renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        // 2
        let leftSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
        let rightSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
        // 3
        print(leftSmileValue, rightSmileValue)
    }
    
    
    
    
}

