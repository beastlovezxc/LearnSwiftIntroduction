//
//  WalkthroughContentViewController.swift
//  Project-004-FoodPin
//
//  Created by Bean on 16/7/11.
//  Copyright © 2016年 Bean. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var forwardButton: UIButton!
    
//    @IBAction func close(sender: AnyObject) {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setBool(true, forKey: "hasViewedWalkthrough")
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    @IBAction func nextButtonTapped(sender: UIButton) {
        switch index {
        case 0...1:
            let pageViewController = parentViewController as! WalkthroughPageViewController
            pageViewController.forward(index)
        case 2:
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "hasViewedWalkthrough")
            dismissViewControllerAnimated(true, completion: nil)
        default: break
        }
    }
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = index
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        switch index {
        case 0...1: forwardButton.setTitle("NEXT", forState: UIControlState.Normal)
        case 2:forwardButton.setTitle("DONE", forState: UIControlState.Normal)
        default: break
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    }
