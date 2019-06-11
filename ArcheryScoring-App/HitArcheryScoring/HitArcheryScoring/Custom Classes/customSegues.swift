//
//  customSegues.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/10/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import Foundation
import UIKit

class ScaleSegue : UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let toVC = self.destination
        let fromVC = self.source
        let containerView = fromVC.view.superview
        let origin = fromVC.view.center
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        toVC.view.center = origin
        toVC.modalPresentationStyle = .overCurrentContext
        toVC.modalTransitionStyle = .crossDissolve
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {toVC.view.transform = CGAffineTransform.identity}, completion: {success in fromVC.present(toVC, animated: false, completion: nil)})
    }
}

class UnwindScaleSegue : UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let toVC = self.destination
        let fromVC = self.source
        fromVC.view.superview?.insertSubview(toVC.view, at: 0)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            toVC.modalPresentationStyle = .overCurrentContext
            toVC.modalTransitionStyle = .crossDissolve
            fromVC.modalTransitionStyle = .crossDissolve
            fromVC.view.alpha = 0
        }, completion: {success in fromVC.dismiss(animated: false, completion: nil)})
    }
}
