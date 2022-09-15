//
//  PopAnimator.swift
//  five
//
//  Created by Рома Сумороков on 25.08.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
  let duration = 0.4
  var presenting = true
  var originFrame = CGRect.zero
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = presenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
    let recipeView = presenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
      
    let initialFrame = presenting ? originFrame : recipeView.frame
    let finalFrame = presenting ? recipeView.frame : originFrame

    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width

    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
        
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

    if presenting {
      recipeView.transform = scaleTransform
      recipeView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      recipeView.clipsToBounds = true
    }

    recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
    recipeView.layer.masksToBounds = true
      
    containerView.addSubview(toView)
    containerView.bringSubviewToFront(recipeView)

    UIView.animate(
      withDuration: duration,
      delay:0.0,
      usingSpringWithDamping: self.presenting ? 0.6 : 1.0,
      initialSpringVelocity: 0.5,
    animations: {
      recipeView.transform = self.presenting ? .identity : scaleTransform
      recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
      recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    duration
  }
}
