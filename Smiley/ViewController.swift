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
    
    var trayOrigin: CGPoint!
    var trayDownPoint: CGPoint!
    var trayUpPoint: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFacePoint: CGPoint!
    var newlyCreatedFacePanPoint: CGPoint!
    var newlyCreatedFacePinchScale: CGFloat!
    
    @IBAction func onPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = panGestureRecognizer.location(in: parentView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            trayOrigin = trayView.center
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            let translation = panGestureRecognizer.translation(in: parentView)
            trayView.center = CGPoint(x: trayOrigin.x, y: trayOrigin.y + translation.y)
            print("Gesture changed at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
            let panVelocity = panGestureRecognizer.velocity(in: trayView)
            
            UIView.animate(withDuration: 0.1, animations: { 
                if panVelocity.y > 0 {
                    // up
                    self.trayView.center = self.trayUpPoint
                }else{
                    // down
                    self.trayView.center = self.trayDownPoint
                }
                }, completion: { (isComplete: Bool) in
                    
            })

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trayOrigin = self.trayView.center
        self.trayDownPoint = CGPoint(x: trayOrigin.x, y: trayOrigin.y - 150)
        self.trayUpPoint = self.trayView.center
        
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
            self.newlyCreatedFacePanPoint = point
            self.newlyCreatedFacePinchScale = sender.scale
        } else if sender.state == UIGestureRecognizerState.changed {
            print("Gesture changed at: \(point)")
            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: sender.scale,y: sender.scale)
        } else if sender.state == UIGestureRecognizerState.ended {
            print("Gesture ended at: \(point)")
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
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            self.newlyCreatedFacePoint = self.newlyCreatedFace.center
            let newFacePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(newSmileyPanGesture(sender:)))
            let newFacePinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(newSmileyPinchGesture(sender:)))
            self.newlyCreatedFace.isUserInteractionEnabled = true
            self.newlyCreatedFace.addGestureRecognizer(newFacePanGestureRecognizer)
            self.newlyCreatedFace.addGestureRecognizer(newFacePinchGestureRecognizer)
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

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

