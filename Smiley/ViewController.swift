//
//  ViewController.swift
//  Smiley
//
//  Created by Bryce Aebi on 11/3/16.
//  Copyright © 2016 Bryce Aebi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var trayArrowImageView: UIImageView!
    
    var trayOriginCenter: CGPoint!
    var trayDownPoint: CGPoint!
    var trayUpPoint: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFacePoint: CGPoint!
    var newlyCreatedFacePanPoint: CGPoint!
    var newlyCreatedFacePinchScale: CGFloat!
    var newlyCreatedFaceRotate: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trayOriginCenter = self.trayView.center
        self.trayUpPoint = self.trayView.center
        let bottomY = self.trayView.frame.maxY
        let distFromCenterToBottom = bottomY - self.trayView.center.y
        let downOffset = (distFromCenterToBottom * 2) - 50
        self.trayDownPoint = CGPoint(x: self.trayOriginCenter.x, y: self.trayOriginCenter.y + downOffset)
    }
    
    @IBAction func onTrayPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = panGestureRecognizer.location(in: self.parentView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            print("Gesture began at: \(point)")
            self.trayOriginCenter = trayView.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            print("Gesture changed at: \(point)")
            let translation = panGestureRecognizer.translation(in: self.parentView)
            trayView.center = CGPoint(x: trayOriginCenter.x, y: trayOriginCenter.y + translation.y)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
            
            let panVelocity = panGestureRecognizer.velocity(in: self.view)
            print("Velocity: \(panVelocity)")
            UIView.animate(withDuration: 0.1, animations: { 
                if panVelocity.y > 0 {
                    // up
                    self.trayView.center = self.trayDownPoint
                    self.trayArrowImageView.transform =
                        CGAffineTransform(rotationAngle: CGFloat(180 * M_PI / 180))
                }else{
                    // down
                    self.trayView.center = self.trayUpPoint
                    self.trayArrowImageView.transform =
                        CGAffineTransform(rotationAngle: CGFloat(360 * M_PI / 180))
                }
                }, completion: { (isComplete: Bool) in
                    
            })
        }
    }
    
    @IBAction func smileyPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = panGestureRecognizer.location(in: parentView)
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            print("Gesture began at: \(point)")
            // Gesture recognizers know the view they are attached to
            let imageView = panGestureRecognizer.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            self.newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            self.newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            self.newlyCreatedFace.center.y += trayView.frame.origin.y
            self.newlyCreatedFacePoint = self.newlyCreatedFace.center
            self.newlyCreatedFace.isUserInteractionEnabled = true
            
            let newFacePanGestureRecognizer = UIPanGestureRecognizer(
                target: self, action: #selector(newSmileyPanGesture(sender:))
            )
            newFacePanGestureRecognizer.delegate = self
            self.newlyCreatedFace.addGestureRecognizer(newFacePanGestureRecognizer)
            
            let newFacePinchGestureRecognizer = UIPinchGestureRecognizer(
                target: self, action: #selector(newSmileyPinchGesture(sender:))
            )
            newFacePinchGestureRecognizer.delegate = self
            self.newlyCreatedFace.addGestureRecognizer(newFacePinchGestureRecognizer)
            
            let newFaceRotateGestureRecognizer = UIRotationGestureRecognizer(
                target: self, action: #selector(newSmileyRotateGesture(sender:))
            )
            newFaceRotateGestureRecognizer.delegate = self
            self.newlyCreatedFace.addGestureRecognizer(newFaceRotateGestureRecognizer)
                
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2,y: 2)
                }, completion: { (isComplete: Bool) in
                    
            })
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            print("Gesture changed at: \(point)")
            let translation = panGestureRecognizer.translation(in: parentView)
            self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFacePoint.x + translation.x, y: self.newlyCreatedFacePoint.y + translation.y)
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
            UIView.animate(withDuration: 0.3, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1,y: 1)
                }, completion: { (isComplete: Bool) in
                    
            })
            
        }
        
    }
    
    func newSmileyPanGesture(sender: UIPanGestureRecognizer) {
        // the parent view of the tray)
        let point = sender.location(in: parentView)
        if sender.state == UIGestureRecognizerState.began {
            print("Gesture began at: \(point)")
            self.newlyCreatedFacePanPoint = point
            
        } else if sender.state == UIGestureRecognizerState.changed {
            print("Gesture changed at: \(point)")
            let translation = sender.translation(in: parentView)
            self.newlyCreatedFace.center = CGPoint(x: self.newlyCreatedFacePanPoint.x + translation.x, y: self.newlyCreatedFacePanPoint.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
        }
        
    }
    
    func newSmileyPinchGesture(sender: UIPinchGestureRecognizer){
        let point = sender.location(in: parentView)
        if sender.state == UIGestureRecognizerState.began {
            print("Gesture began at: \(point)")
            self.newlyCreatedFacePinchScale = sender.scale
            
        } else if sender.state == UIGestureRecognizerState.changed {
            print("Gesture changed at: \(point)")
            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: sender.scale,y: sender.scale)
            
        } else if sender.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
        }
    }
    
    func newSmileyRotateGesture(sender: UIRotationGestureRecognizer){
        let point = sender.location(in: parentView)
        if sender.state == UIGestureRecognizerState.began {
            print("Gesture began at: \(point)")
            self.newlyCreatedFaceRotate = sender.rotation
            
        } else if sender.state == UIGestureRecognizerState.changed {
            print("Gesture changed at: \(point)")
            self.newlyCreatedFace.transform = sender.view!.transform.rotated(by: sender.rotation)
            
        } else if sender.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // We don't want the trayView to simultaneously move with another view
        if gestureRecognizer.view?.tag == 100 || otherGestureRecognizer.view?.tag == 100 {
            return false
        }
        return true
    }

}

