//
//  MultitouchBugView.swift
//  MultitouchBug
//
//  Created by ShinryakuTako@InvadingOctopus.io on 2018/07/09.
//  Copyright © 2018 Invading Octopus. All rights reserved.
//

// iOS Touch Bugs

// ⚠️ BUG 1: RADAR (Bug Reporter ID) 39997859: `UITouch.location(in:)` and `UITouch.preciseLocation(in:)` for a touch "wobbles" when a 2nd touch moves near it, even if the tracked touch is stationary. ⚠️ Seems to be a problem since iOS 11.3 on ALL devices (including iPhones and iPads), and in all apps, like Photos.

// ⚠️ BUG 2: `UITouch.location(in:)` and `UITouch.previousLocation(in:)` are sometimes not updated for many frames, causing a node to "jump" many pixels after 10 or so frames. Same issue with `preciseLocation(in:)` and `precisePreviousLocation(in:)`.

import UIKit

class MultitouchBugView: UIView {
    
    @IBOutlet weak var label: UILabel!
    
    var trackedTouch: UITouch?
    
    override func draw(_ rect: CGRect) {
        
        guard let trackedTouch = self.trackedTouch else { return }
        
        let touchLocation = trackedTouch.location(in: self)
        let size = CGSize(width: 150, height: 150)
        let rectangle = CGRect(origin: CGPoint(x: touchLocation.x - size.width / 2,
                                               y: touchLocation.y - size.height / 2),
                               size: size)
        
        // Change the color every frame to better visualize minor changes in position.
        
        let color = UIColor(displayP3Red: CGFloat.random(in: 0.5...1.0),
                            green: CGFloat.random(in: 0.5...1.0),
                            blue: CGFloat.random(in: 0.5...1.0),
                            alpha: 1.0)
        
        color.set()
        UIRectFill(rectangle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if trackedTouch == nil {
            trackedTouch = touches.first
            setNeedsDisplay()
        }
        updateLabel()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let trackedTouch = self.trackedTouch,
            touches.contains(trackedTouch)
        {
            setNeedsDisplay()
        }
        updateLabel()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let trackedTouch = self.trackedTouch,
            touches.contains(trackedTouch)
        {
            self.trackedTouch = nil
            setNeedsDisplay()
        }
        updateLabel()
    }
    
    func updateLabel() {
        guard let label = self.label else { return }
        
        if trackedTouch == nil {
            label.text = "iOS Multitouch Bug: Tap and hold anywhere."
        }
        else {
            
            let touchLocation = self.trackedTouch!.location(in: self)
            
            label.text = """
            Keep the first finger stationary and bring a second finger near it. The position of the first touch will wobble slightly even if the first finger does not move.
            
            First touch x: \(touchLocation.x)
            First touch y: \(touchLocation.y)
            
            \(self.trackedTouch!)
            """
        }
    }
}
