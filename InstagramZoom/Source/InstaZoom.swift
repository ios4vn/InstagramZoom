//
//  InstaZoom.swift
//  KeepUser
//
//  Created by Nguyen Hai Trieu on 10/11/17.
//  Copyright © 2017 横田 貴之. All rights reserved.
//

import UIKit

let ImageZoom_Started_Zoom_Notification = "ImageZoom_Started_Zoom_Notification"
let ImageZoom_Ended_Zoom_Notification   = "ImageZoom_Ended_Zoom_Notification"
let MaxOverlayAlpha: CGFloat = 0.8
let MinOverlayAlpha: CGFloat = 0.4

class InstaZoom: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let shared = InstaZoom()

    var currentImageView: UIImageView?
    var hostImageView: UIImageView?
    var overlayColorView: UIView!
    var isAnimatingReset = false
    var firstCenterPoint = CGPoint.zero
    var startingRect = CGRect.zero
    var isHandlingGesture = false
    
    func gestureStateChanged (gesture: UIGestureRecognizer, zoomImageView: UIImageView) {
        
        // Insure user is passing correct UIPinchGestureRecognizer class.
        guard let theGesture = gesture as? UIPinchGestureRecognizer else {
            return
        }
        
        // Prevent animation issues if currently animating reset.
        if (isAnimatingReset) {
            return
        }
        
        // Reset zoom if state = UIGestureRecognizerStateEnded
        if (theGesture.state == UIGestureRecognizerState.ended || theGesture.state == UIGestureRecognizerState.cancelled || theGesture.state == UIGestureRecognizerState.failed) {
            self.reset()
            return;
        }
        
        // Ignore other views trying to start zoom if already zooming with another view
        if (isHandlingGesture && hostImageView != zoomImageView) {
            print("(InstaZoom): 'gestureStateChanged:' ignored since this imageView isnt being tracked")
            return
        }
        
        // Start handling gestures if state = UIGestureRecognizerStateBegan and not already handling gestures.
        if (!isHandlingGesture && theGesture.state == UIGestureRecognizerState.began) {
            isHandlingGesture = true
            
            // Set Host ImageView
            hostImageView = zoomImageView
            zoomImageView.isHidden = true
            
            // Convert local point to window coordinates
            let point = zoomImageView.convert(zoomImageView.frame.origin, to: nil)
            startingRect = CGRect(x: point.x, y: point.y, width: zoomImageView.frame.size.width, height: zoomImageView.frame.size.height)
            
            // Post Notification for start tracking
            NotificationCenter.default.post(name: Notification.Name(rawValue: ImageZoom_Started_Zoom_Notification), object: nil)
            
            let currentWindow = UIApplication.shared.keyWindow
            
            overlayColorView = UIView.init(frame: CGRect(x: 0, y: 0, width: (currentWindow?.frame.size.width)!, height: (currentWindow?.frame.size.height)!))
            overlayColorView.backgroundColor = UIColor.black
            overlayColorView.alpha = CGFloat(MinOverlayAlpha)
            currentWindow?.addSubview(overlayColorView)
            
            firstCenterPoint = theGesture.location(in: currentWindow)
            
            // Init zoom ImageView
            currentImageView = UIImageView.init(image: zoomImageView.image)
            currentImageView?.contentMode = zoomImageView.contentMode
            currentImageView?.frame = startingRect
            currentWindow?.addSubview(currentImageView!)
        }
        
        // Update scale & center
        if (theGesture.state == UIGestureRecognizerState.changed) {
            // Calculate new image scale.
            let currentScale = (currentImageView?.frame.size.width)! / startingRect.size.width
            let newScale = currentScale * theGesture.scale
            
            // Calculate new overlay alpha
            overlayColorView.alpha = MinOverlayAlpha + (newScale - 1) < MaxOverlayAlpha ? MinOverlayAlpha + (newScale - 1) : MaxOverlayAlpha;
            
            // Calculate new center
            let currentWindow = UIApplication.shared.keyWindow
            let pinchCenter = CGPoint(x: theGesture.location(in: currentWindow).x - (currentWindow?.bounds.midX)!,
                                      y: theGesture.location(in: currentWindow).y - (currentWindow?.bounds.midY)!)
            let centerXDif = firstCenterPoint.x - theGesture.location(in: currentWindow).x
            let centerYDif = firstCenterPoint.y - theGesture.location(in: currentWindow).y
            let transform = currentWindow?.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: newScale, y: newScale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                .translatedBy(x: -centerXDif, y: -centerYDif)
            currentImageView?.transform = transform!
            // Reset the scale
            theGesture.scale = 1
        }
    }
    
    func reset () {
        // If not already animating
        if (isAnimatingReset || !isHandlingGesture) {
            return
        }
        
        // Prevent further scale/center updates
        isAnimatingReset = true
        
        // Animate image zoom reset and post zoom ended notification
        UIView.animate(withDuration: 0.2, animations: {
            if let currentImageView = self.currentImageView {
                currentImageView.frame = self.startingRect
                self.overlayColorView.alpha = 0
            }
        }) { (finished) in
            self.currentImageView?.removeFromSuperview()
            self.overlayColorView.removeFromSuperview()
            self.currentImageView = nil
            self.overlayColorView = nil
            self.hostImageView?.isHidden = false
            self.hostImageView = nil
            self.startingRect = CGRect.zero
            self.firstCenterPoint = CGPoint.zero
            self.isHandlingGesture = false
            self.isAnimatingReset = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: ImageZoom_Ended_Zoom_Notification), object: nil)

        }

    }
}
