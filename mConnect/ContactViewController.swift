//
//  ContactViewController.swift
//  mConnect
//
//  Created by chipsy services on 10/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import MessageUI
class ContactViewController: UIViewController,ENSideMenuDelegate,MFMailComposeViewControllerDelegate {
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var AddressLabel: UILabel!//16
    @IBOutlet weak var DiscrptionLabe: UILabel!//14
    @IBOutlet weak var MailToUsTitalLabel: UILabel!//16
    @IBOutlet weak var MailToUsDiscriptionLabel: UILabel!//13
    @IBOutlet weak var MailLinkLabel: UILabel!//14
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                AddressLabel.font = UIFont.systemFont(ofSize: 14)
                DiscrptionLabe.font = UIFont.systemFont(ofSize: 12)
                MailToUsTitalLabel.font = UIFont.systemFont(ofSize: 14)
                MailToUsDiscriptionLabel.font = UIFont.systemFont(ofSize: 11)
                MailLinkLabel.font = UIFont.systemFont(ofSize: 12)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                AddressLabel.font = UIFont.systemFont(ofSize: 15)
                DiscrptionLabe.font = UIFont.systemFont(ofSize: 13)
                MailToUsTitalLabel.font = UIFont.systemFont(ofSize: 15)
                MailToUsDiscriptionLabel.font = UIFont.systemFont(ofSize: 12)
                MailLinkLabel.font = UIFont.systemFont(ofSize: 13)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                AddressLabel.font = UIFont.systemFont(ofSize: 16)
                DiscrptionLabe.font = UIFont.systemFont(ofSize: 14)
                MailToUsTitalLabel.font = UIFont.systemFont(ofSize: 16)
                MailToUsDiscriptionLabel.font = UIFont.systemFont(ofSize: 13)
                MailLinkLabel.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 736.0
            {
                AddressLabel.font = UIFont.systemFont(ofSize: 18)
                DiscrptionLabe.font = UIFont.systemFont(ofSize: 16)
                MailToUsTitalLabel.font = UIFont.systemFont(ofSize: 18)
                MailToUsDiscriptionLabel.font = UIFont.systemFont(ofSize: 15)
                MailLinkLabel.font = UIFont.systemFont(ofSize: 16)
            }
            
        }
        if self.iPad == true
        {
            
            if UIScreen.main.bounds.height == 1024.0
            {
                
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                
            }
        }
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Contact & Feedback"
        let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.setImage(UIImage(named: "home_g"), for: UIControlState())
        button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
        //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
        let rightButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = rightButton
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
        let mailtap = UITapGestureRecognizer(target: self, action: #selector(self.mailViewTouched))
        mailView.addGestureRecognizer(mailtap)
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func mailViewTouched()
    {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["apps@ideationwizard.com"])
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            
            let alert:UIAlertView  = UIAlertView(title: "mConnect", message: "Mail is not configured. Please configure mail and then try again.", delegate: nil, cancelButtonTitle: "Ok")//
            alert.show()
            
        }
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
    @IBAction func mailButtonTouched(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["apps@ideationwizard.com"])
            // mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            
            let alert:UIAlertView  = UIAlertView(title: "mConnect", message: "Mail is not configured. Please configure mail and then try again.", delegate: nil, cancelButtonTitle: "Ok")//
            alert.show()
            
        }
    }
    func gotoHome()
    {
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
}
