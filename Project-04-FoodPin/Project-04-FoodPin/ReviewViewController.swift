//
//  ReviewViewController.swift
//  Project-04-FoodPin
//
//  Created by Bean on 16/3/11.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    var rating: String?
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var ratingStackView: UIStackView!
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
        // 图片背景模糊
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // 评价按钮动画显示
        ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        // 评价按钮移动
//        ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        // 两个动画结合的函数
        // CGAffineTransformConcat(transform1, transform2)
        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
    }
    
    override func viewDidAppear(animated: Bool) {
        // 评价按钮动画现实
//        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
//            self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)
        // 评价按钮  spring animation 实现
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            self.ratingStackView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}
