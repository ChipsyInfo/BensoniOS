//
//  MemberDetailViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 05/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import QuartzCore
import MessageUI
class MemberDetailViewController: UIViewController,ENSideMenuDelegate,MFMailComposeViewControllerDelegate {
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var backimg:UIImage!
    var memberNameString:String! = ""
    var memberDesignationString:String! = ""
    var memberAddressString:String! = ""
    var memberImageLink:String! = ""
    var memberServingTermString:String! = ""
    var memberPreviousTermString:String! = ""
    var memberContactCalString:String! = ""
    var memberContactMailString:String! = ""
    var prevsLabelHeight:CGFloat = 15
    var memberCommitteArray:NSMutableArray! = NSMutableArray()
    @IBOutlet weak var memberDetailScroll: UIScrollView!
    @IBOutlet weak var memberContentView: UIView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberDesignation: UILabel!
    @IBOutlet weak var memberAddress: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberServingTerm: UILabel!
    @IBOutlet weak var memberPrevsTerm: UILabel!
    @IBOutlet weak var memberTitleViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var prevsLabelBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var termServingTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var prevsTermTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var memberContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memberContactViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memberCommitteeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memberPrevsTermViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memberTermViewHeight: NSLayoutConstraint!
    @IBOutlet weak var memberContcatNumber: UILabel!
    @IBOutlet weak var memberContactMail: UILabel!
    @IBOutlet weak var memberCommitteeView: UIView!
    @IBOutlet weak var leftColorView: UIView!
    @IBOutlet weak var rightColorView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var mailView: UIView!
    var appDelegate:AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.appDelegate.SelectedOption = "MemberDetailViewController"
        UIView.animate(withDuration: 1.0, delay: 0.0, options:[], animations: {
            self.updateRightView()
            self.updateLeftView()
            //self.rightColorView.backgroundColor = UIColor(hex: 0x509FF7)
            //self.leftColorView.backgroundColor = UIColor(hex: 0x509FF7)
            }, completion:nil)
        self.navigationItem.title = "Town Council"
        let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.setTitle("Back", for: UIControlState())
        backimg = self.setcolorImage(UIImage(named: "bksml")!)
        button.setImage(backimg, for: UIControlState())
        button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
        //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
        let leftButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
        let negativeSpacerright:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacerright.width = -10
        self.navigationItem.leftBarButtonItems = [leftButton]
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
        self.navigationController?.navigationBar.isTranslucent = false
        memberName.text = self.memberNameString
        memberDesignation.text = memberDesignationString
        memberAddress.text = memberAddressString
        memberServingTerm.text = memberServingTermString
        DispatchQueue.main.async {
            if self.memberServingTerm.text == ""
            {
                self.termServingTitleHeight.constant = 0
                self.memberTermViewHeight.constant = 0
            }
            self.memberPrevsTerm.numberOfLines = 0
            self.memberPrevsTerm.text = self.memberPreviousTermString
            self.memberPrevsTerm.sizeToFit()
            
            if self.memberPrevsTerm.text == ""
            {
                self.prevsLabelBottomSpace.constant = 0
                self.prevsTermTitleHeight.constant = 0
                self.memberPrevsTermViewHeight.constant = 0
            }
            else
            {
                self.memberPrevsTermViewHeight.constant = CGFloat(self.memberPrevsTerm.frame.height * 2) + 15
            }
            self.memberContactMail.text = self.memberContactMailString
            self.memberContcatNumber.text = self.memberContactCalString
            if self.memberCommitteArray.count > 0
            {
                for cmarray in self.memberCommitteArray
                {
                    let circleView = UIView(frame: CGRect(x: 8,y: self.prevsLabelHeight + 7,width: 4,height: 4))
                    circleView.backgroundColor = UIColor(hex: 0x509FF7)
                    circleView.layer.cornerRadius = 2
                    let comiteelabel = UILabel(frame: CGRect(x: 20,y: self.prevsLabelHeight + 5,width: self.view.frame.width - 40,height: 0))
                    if #available(iOS 8.2, *) {
                        comiteelabel.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
                    } else {
                        // Fallback on earlier versions
                         comiteelabel.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
                    }
                    
                    comiteelabel.numberOfLines = 0
                    comiteelabel.text = cmarray as? String
                    comiteelabel.sizeToFit()
                    self.memberCommitteeView.addSubview(circleView)
                    self.memberCommitteeView.addSubview(comiteelabel)
                    self.prevsLabelHeight += CGFloat(comiteelabel.frame.height + comiteelabel.intrinsicContentSize.height)
                    
                }
                self.memberCommitteeViewHeight.constant = self.prevsLabelHeight + 10
            }
            else
            {
                self.memberCommitteeViewHeight.constant = 0
            }
            self.memberContentViewHeight.constant = self.memberTitleViewHeight.constant + self.memberTermViewHeight.constant + self.memberPrevsTermViewHeight.constant + self.memberCommitteeViewHeight.constant + self.memberContactViewHeight.constant
            
            let img = self.memberImageLink
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainUrl:NSMutableString = NSMutableString(string: appDelegate.mainUrlString)
            
            
            mainUrl.append(img!)
            let string = mainUrl
            var modifiedUrlString:NSString!
            // alternative: not case sensitive
            if string.lowercased.range(of: ".jpg") != nil {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpg", with: "_l.jpg") as NSString!
            }
            else if string.lowercased.range(of: ".png") != nil
            {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".png", with: "_l.png") as NSString!
            }
            else
            {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpeg", with: "_l.jpeg") as NSString!
            }
            
            self.memberImageView.image = nil
            let imgURL = URL(string: modifiedUrlString as String)
            let request: URLRequest = URLRequest(url: imgURL!)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                let error = error
                let data = data
                //self.spinner.stopAnimating()
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    
                    // Store the image in to our cache
                    //cell.newsHomeImageView.image = image
                    // Update the cell
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        
                        
                        //Do UI stuff here
                        
                        self.memberImageView.image = image  
                    }
                }
            })
            task.resume()
            
        }
        
        let mailtap = UITapGestureRecognizer(target: self, action: #selector(self.mailViewTouched))
        mailView.addGestureRecognizer(mailtap)
        let callltap = UITapGestureRecognizer(target: self, action: #selector(self.callViewTouched))
        callView.addGestureRecognizer(callltap)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.memberDetailScroll.setContentOffset(CGPoint.zero, animated: true)
    }
    func updateRightView()
    {
        let animation:CATransition  = CATransition()
        animation.duration = 0.8 //setDuration:0.3];
        animation.type =  kCATransitionPush// setType:kCATransitionPush];
        animation.subtype = kCATransitionFromRight //setSubtype:kCATransitionFromRight];
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFuncionEaseInEaseOut]];
        self.rightColorView.layer.backgroundColor = UIColor(hex: 0x509FF7)?.cgColor
        
        
        self.rightColorView.layer.add(animation, forKey: "rightToLeftAnimation")
        //self.rightColorView.layer.addAnimation(animation, forKey: "rightToLeftAnimation")
        //self.rightColorView.layer.addAnimation(animation, forKey: "rightToLeftAnimation")
        
    }
    func updateLeftView()
    {
        let animation:CATransition  = CATransition()
        animation.duration = 0.8 //setDuration:0.3];
        animation.type =  kCATransitionPush// setType:kCATransitionPush];
        animation.subtype = kCATransitionFromLeft//setSubtype:kCATransitionFromRight];
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFuncionEaseInEaseOut]];
        self.leftColorView.layer.backgroundColor = UIColor(hex: 0x509FF7)?.cgColor
        
        
        self.leftColorView.layer.add(animation, forKey: "leftToRightAnimation")
        //self.rightColorView.layer.addAnimation(animation, forKey: "rightToLeftAnimation")
        //self.rightColorView.layer.addAnimation(animation, forKey: "rightToLeftAnimation")
        
    }
    func mailViewTouched()
    {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.memberContactMail.text!])
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            
            let alert:UIAlertView  = UIAlertView(title: "mConnect", message: "Mail is not configured. Please configure mail and then try again.", delegate: nil, cancelButtonTitle: "Ok")//
            alert.show()
            
        }
    }
    func callViewTouched()
    {
        var mobilenumbr = "tel:"
        var mobilestring = self.memberContcatNumber.text
        mobilestring = mobilestring?.replacingOccurrences(of: " ", with: "")
        mobilenumbr = mobilenumbr.appendingFormat("%@", mobilestring!)
        if UIApplication.shared.canOpenURL(URL(string:mobilenumbr )!)
        {
            UIApplication.shared.openURL(URL(string:mobilenumbr )!)
        }
    }

    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        appDelegate.SelectedOption = "MemberDetailViewController"

    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func gotoHome()
    {
        self.appDelegate.SelectedOption = ""
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        let _ = self.navigationController?.popViewController(animated: false)
        //self.navigationController?.presentViewController(home, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if (result == MFMailComposeResult.cancelled)
        {
            //cancelled - can show alert message if required
        }
        else if (result == MFMailComposeResult.saved)
        {
            //not sent
        }
        else if (result == MFMailComposeResult.sent)
        {
            let alert:UIAlertView  = UIAlertView(title: "mConnect", message: "Mail sent successfully", delegate: nil, cancelButtonTitle: "Ok")//[[UIAlertView alloc] initWithTitle:@"Seva"
            alert.show()
        }
        else if (result == MFMailComposeResult.failed)
        {
        }
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        controller.dismiss(animated: true, completion: nil)
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
}
