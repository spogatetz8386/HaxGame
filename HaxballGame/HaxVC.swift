//
//  HaxVC.swift
//  HaxballGame
//
//  Created by Jeremy Otto Potratz on 11/8/16.
//  Copyright © 2016 apcsp. All rights reserved.
//


import UIKit
import CDJoystick

class HaxVC: UIViewController, UICollisionBehaviorDelegate {
    
    var animator : UIDynamicAnimator!
    var collision : UICollisionBehavior!
    var push : UIPushBehavior!
    var gravity : UIGravityBehavior!
    var ballView = UIView()
    var playerView = UIView()
    var ballBehavior = UIDynamicItemBehavior()
    var playerBehavior = UIDynamicItemBehavior()
    var jsActive = false
    
    var vector = CGVector()
    
    var pushBehavior : UIPushBehavior!
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Began")
        var location = touches.first?.locationInView(view)
        let jsXSize = 100
        let jsYSize = 100
        location!.x = location!.x - (CGFloat(jsXSize) / 2)
        location!.y = location!.y - (CGFloat(jsYSize) / 2)
        let js = addJS(CGRect(origin: location!, size: CGSize(width: jsXSize, height: jsYSize)))
        view.addSubview(js)
        js.tracking = true
        UIView.animateWithDuration(0.1) { () -> Void in
            js.touchesMoved(touches, withEvent: event)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let jsView = self.view.viewWithTag(999) as! CDJoystick
        jsView.tracking = false
        jsView.removeFromSuperview()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let jsView = self.view.viewWithTag(999) as! CDJoystick
        jsView.tracking = false
        jsView.removeFromSuperview()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let jsView = view.viewWithTag(999)
        jsView?.touchesMoved(touches, withEvent: event)
    }
    
    
    func addJS(frame: CGRect) -> CDJoystick{
        let js = CDJoystick()
        js.frame = frame
        js.backgroundColor = .clearColor()
        js.substrateColor = .lightGrayColor()
        js.substrateBorderColor = .grayColor()
        js.substrateBorderWidth = 1.0
        js.stickSize = CGSize(width: 50, height: 50)
        js.stickColor = .darkGrayColor()
        js.stickBorderColor = .blackColor()
        js.stickBorderWidth = 2.0
        js.fade = 0.5
        js.tag = 999
        
        js.trackingHandler = { (joystickData) -> () in
            //            self.playerView.center.x += joystickData.velocity.x * 2
            //            self.playerView.center.y += joystickData.velocity.y * 2
            
            self.vector = CGVector(dx: joystickData.velocity.x/2 , dy: joystickData.velocity.y/2)
            
            let hi = joystickData.angle
            
            print(self.vector)
            
            print(hi)
            
            
            self.pushBehavior = UIPushBehavior(items: [self.playerView], mode: UIPushBehaviorMode.Instantaneous)
            self.pushBehavior.pushDirection = self.vector
            self.pushBehavior.active = true
            self.animator?.addBehavior(self.pushBehavior)
        }
        
        return js
    }
    
    
    func addViews(){
        
        ballView.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        playerView.frame = CGRect(x: 100, y: 300, width: 50, height: 50)
        
        ballView.backgroundColor = UIColor.blackColor()
        ballView.layer.cornerRadius = ballView.frame.size.width/2
        ballView.clipsToBounds = true
        ballView.layer.borderColor = UIColor.blackColor().CGColor
        ballView.layer.borderWidth = 5.0
        
        playerView.backgroundColor = UIColor.greenColor()
        playerView.layer.cornerRadius = ballView.frame.size.width/2
        playerView.clipsToBounds = true
        playerView.layer.borderColor = UIColor.greenColor().CGColor
        playerView.layer.borderWidth = 5.0
        
        
        view.addSubview(ballView)
        view.addSubview(playerView)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        
        addViews()
        
        ballBehavior = UIDynamicItemBehavior(items: [ballView])
        ballBehavior.allowsRotation = false
        ballBehavior.elasticity = 1.08
        ballBehavior.friction = 0.00
        ballBehavior.resistance = 0.0
        ballBehavior.density = 100000000000
        animator?.addBehavior(ballBehavior)
        
        
        playerBehavior = UIDynamicItemBehavior(items: [playerView])
        playerBehavior.allowsRotation = false
        playerBehavior.elasticity = 0.50
        playerBehavior.friction = 0.0
        playerBehavior.resistance = 5.0
        animator?.addBehavior(playerBehavior)
        
        
        
        collision = UICollisionBehavior(items: [ballView, playerView])
        collision.collisionMode = UICollisionBehaviorMode.Everything
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        collision.collisionDelegate = self
        
        
        
    }
    
    
}
