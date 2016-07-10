//
//  ReviewViewController.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/8.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var ratingStackView: UIStackView!
    
    var rating: String?
    @IBAction func ratingSelected(sender: UIButton) {
        
        switch (sender.tag) {
        case 100: rating = "dislike"
        case 200: rating = "good"
        case 300: rating = "great"
        default: break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }
    override func viewDidLoad() {
        
        // 增加毛玻璃效果
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // 增加ratingStackView 的动画效果 : 改变大小
        ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        // 增加ratingStackView 的动画效果 : 改变位置
        ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        // 增加ratingStackView 的动画效果 ：同时改变大小和位置
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // 增加 ratingStackView 的动画效果 : 改变大小
        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
            self.ratingStackView.transform = CGAffineTransformIdentity}, completion:  nil)
    }
}
