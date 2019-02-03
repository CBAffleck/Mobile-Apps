//
//  SlideUpSegue.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/30/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class SlideUpSegue: UIStoryboardSegue {

    override func perform() {
        slideUp()
    }

    func slideUp() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: destination.view.frame.height)
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                toViewController.view.transform = CGAffineTransform.identity
            }, completion: { success in
                fromViewController.present(toViewController, animated: false, completion: nil)
            }
        )
    }
}

class UnwindSlideUpSegue: UIStoryboardSegue {
    
    override func perform() {
        slideDown()
    }
    
    func slideDown() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: self.source.view.frame.height)
        }, completion: { success in
            fromViewController.dismiss(animated: false, completion: nil)
        }
        )
    }
}

class SlideDownSegue: UIStoryboardSegue {
    
    override func perform() {
        slideDown()
    }
    
    func slideDown() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }
        )
    }
}
