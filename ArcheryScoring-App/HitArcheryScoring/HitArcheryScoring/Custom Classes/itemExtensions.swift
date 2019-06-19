//
//  itemExtensions.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/18/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func bounce() {
        let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
        animator.addAnimations {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        animator.startAnimation()
    }
    
    func bounceBack() {
        let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
        animator.addAnimations {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        animator.startAnimation()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.tag != 1 {
            let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
            animator.addAnimations {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
            animator.startAnimation()
        } else {
            bounce()
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        bounceBack()
    }
}

extension UISpringTimingParameters {
    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
    
}
