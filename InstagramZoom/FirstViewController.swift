//
//  FirstViewController.swift
//  InstagramZoom
//
//  Created by Nguyen Hai Trieu on 10/11/17.
//  Copyright © 2017 Nguyen Hai Trieu. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var previewImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.imagePinched(_:)))
        pinchGesture.delegate = self
        self.view.addGestureRecognizer(pinchGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func imagePinched(_ pinch: UIPinchGestureRecognizer) {
        InstaZoom.shared.gestureStateChanged(gesture: pinch, zoomImageView: previewImage)
    }
    
}

