//
//  ViewController.swift
//  VSlideView
//
//  Created by Vishal Manhas on 31/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var thumbNailButton: UIView!
    @IBOutlet weak var rightSwipeImage:UIImageView!
    @IBOutlet weak var leftSwipeImage:UIImageView!
    @IBOutlet weak var thumbNailImage:UIImageView!
    @IBOutlet weak var swipeText:UILabel!
    
    var initialThumbNailState: CGPoint!
    var isSwipeLeftToRight = true
    
    let leadingSpace: CGFloat = 4.0
    let trailingSpace: CGFloat = 4.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPSlider()
    }

    
    
    func setUPSlider() {
        swipeView.layer.cornerRadius = 20
        thumbNailButton.layer.cornerRadius = 18
        
        swipeView.backgroundColor = .white
        thumbNailButton.backgroundColor  = .white
        
        swipeView.layer.borderWidth = 0.5
        thumbNailButton.layer.borderWidth = 0.5
        
        swipeText.text = "     Swipe right to lock the device"
        
        swipeView.layer.borderColor =  UIColor(named: "Swipe")?.cgColor
        thumbNailButton.layer.borderColor = UIColor(named: "Swipe")?.cgColor
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        thumbNailButton.addGestureRecognizer(panGesture)
        
        initialThumbNailState = CGPoint(x: leadingSpace + thumbNailButton.bounds.width / 2, y: swipeView.bounds.midY)
        thumbNailButton.center = initialThumbNailState
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: swipeView)
        
        switch gestureRecognizer.state {
        case .began:
            // Reset the initial position when the gesture begins
            initialThumbNailState = thumbNailButton.center
            
        case .changed:
            // Update thumbNailButton position smoothly
            let newCenterX = min(max(thumbNailButton.bounds.width / 2 + leadingSpace, initialThumbNailState.x + translation.x), swipeView.bounds.width - thumbNailButton.bounds.width / 2 - trailingSpace)
            thumbNailButton.center.x = newCenterX
            
            // Change swipeView background color based on thumbNailButton position
            //            if thumbNailButton.center.x <= swipeView.bounds.midX {
            //                swipeView.backgroundColor = UIColor(named: "F52600")
            //
            //                isSwipeLeftToRight = true
            //            } else {
            //                swipeView.backgroundColor = .white // Change to desired color
            //                isSwipeLeftToRight = false
            //            }
            
        case .ended, .cancelled:
            // Determine final position based on thumbNailButton's current position
            let finalPositionX: CGFloat
            if thumbNailButton.center.x <= swipeView.bounds.midX {
                finalPositionX = leadingSpace + thumbNailButton.bounds.width / 2
                isSwipeLeftToRight = true
            } else {
                finalPositionX = swipeView.bounds.width - thumbNailButton.bounds.width / 2 - trailingSpace
                isSwipeLeftToRight = false
            }
            
            // Animate thumbNailButton to the final position
            UIView.animate(withDuration: 0.1, animations: {
                self.thumbNailButton.center.x = finalPositionX
            }) { _ in
                // Print or alert based on the final position
                if self.isSwipeLeftToRight {
                    self.thumbNailButton.backgroundColor = .white
                    self.thumbNailImage.image = UIImage(named: "unlock")
                    print("Left side completed")
                } else {
                    self.thumbNailButton.backgroundColor = UIColor(named: "Swipe")
                    self.thumbNailImage.image = UIImage(named: "ic_lock_fill")
                    self.swipeView.backgroundColor = .white
                }
            }
            
        default:
            break
        }
    }

}

