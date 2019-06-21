//
//  itemExtensions.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/18/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import Foundation
import UIKit

//Button functions to make buttons bounce when tapped
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

//Calculates spring forces
extension UISpringTimingParameters {
    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
    
}

extension UITableViewCell {
    
    func bounce() {
        let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
        animator.addAnimations {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
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
}

//Functions for saving, retrieving, and deleting photos from the library directory
extension UIViewController {
    //Save target image to documents folder with a filename equal to the name + image number
    func saveImage(imageName : String, image : UIImage) {
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = libraryDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Check if file exists, remove if so
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Removed old image")
            } catch let removeError {
                print("Couldn't remove file at path ", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("Error saving image with error ", error)
        }
    }
    
    //Remove target image from documents folder with a given filename
    func removeImage(imageName : String) {
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = libraryDirectory.appendingPathComponent(fileName)
        
        //Check if file exists, remove if so
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Removed old image")
            } catch let removeError {
                print("Couldn't remove file at path ", removeError)
            }
        }
    }
    
    //Fetch image from disk
    func loadImageFromDiskWith(fileName : String) -> UIImage {
        let libraryDirectory = FileManager.SearchPathDirectory.libraryDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(libraryDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image ?? UIImage(named: "SingleSpot")!
        }
        return UIImage(named: "SingleSpot")!
    }
}
