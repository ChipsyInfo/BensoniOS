//
//  FacebookWebViewController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 30/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class FacebookWebViewController: UIViewController,UIWebViewDelegate,ENSideMenuDelegate {
   
    
    var isFromHome:Bool! = false
    var request:NSMutableURLRequest!
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var backimg:UIImage!
    var currentURL:String!
    var checkstring:String!
    @IBOutlet weak var facebookWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkstring = request.url?.absoluteString
        checkstring = checkstring.replacingOccurrences(of: "www", with: "m")
        facebookWebView.loadRequest(request as URLRequest)
        self.navigationItem.title = "Facebook Feeds"
        let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.setTitle("Back", for: UIControlState())
        backimg = self.setcolorImage(UIImage(named: "bksml")!)
        button.setImage(backimg, for: UIControlState())
        button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
        //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
        if self.isFromHome == false
        {
            let leftButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
            let negativeSpacerright:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSpacerright.width = -10
            self.navigationItem.leftBarButtonItems = [leftButton]
        }
        else
        {
            let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            button.setImage(UIImage(named: "home_g"), for: UIControlState())
            button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
            //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
            let rightButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = rightButton
        }
        self.sideMenuController()?.sideMenu?.delegate = self
        self.sideMenuController()?.sideMenu?.allowRightSwipe = true
        self.sideMenuController()?.sideMenu?.allowPanGesture = true
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = true
        let origImage = UIImage(named: "menu")
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        menuButton.setImage(origImage, for: UIControlState())
        menuButton.contentMode = UIViewContentMode.center
        //menuButton.tintColor = UIColor(netHex: 0xFFFFFF)
        // add button images, etc.
        menuButton.addTarget(self, action:#selector(self.menuButtonTouched(_:)), for:UIControlEvents.touchUpInside)
        menu = UIBarButtonItem(customView: menuButton)
        self.navigationItem.rightBarButtonItems = [menu]
        facebookWebView.scrollView.showsHorizontalScrollIndicator = false
        facebookWebView.scrollView.showsVerticalScrollIndicator = false
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func setcolorImage(_ img:UIImage)-> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
        img.draw(in: rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        
        context.setFillColor(UIColor(hex:0x007AFF)!.cgColor);
        context.fill(rect);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage
    }
    func webViewDidFinishLoad(_ webView:UIWebView)
    {
        
        //print(webView.request?.mainDocumentURL)
        currentURL  = (webView.request?.mainDocumentURL?.absoluteString)!
    }
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    func gotoHome()
    {
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        if self.isFromHome == true
        {
            hideSideMenuView()
            delay(0.6)
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
        else
        {
            hideSideMenuView()
            if(facebookWebView.canGoBack) {
                //Go back in webview history
                
                if currentURL == checkstring
                {
                    let _ = self.navigationController?.popViewController(animated: false)
                }
                else
                {
                    facebookWebView.goBack()
                }
                
            } else {
                //Pop view controller to preview view controller
                //NSNotificationCenter.defaultCenter().postNotificationName("reload", object: self, userInfo: nil)
                let _ = self.navigationController?.popViewController(animated: false)
            }
        }
        //self.navigationController?.presentViewController(home, animated: true, completion: nil)
    }
}

