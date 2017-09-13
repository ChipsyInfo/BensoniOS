//
//  NewsPopupViewcontroller.swift
//  Town of Morrisville
//
//  Created by chipsy services on 30/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore
class NewsPopupViewcontroller: UIViewController,UIScrollViewDelegate {
    var newsImage:UIImage!
    var imageString:String!
    var newsTitleString:String!
    var newsReportString:String!
    var newsDescriptionString:String!
    var weburlString:String!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var arrowImageview: UIImageView!
    @IBOutlet weak var newsDesc: UITextView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsInfoImageView: UIImageView!
    @IBOutlet weak var newsPopUpContentView: UIView!
    @IBOutlet weak var newspopScroll: UIScrollView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reportLabel: UILabel! = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTitle.text = newsTitleString
        newsDesc.text = newsDescriptionString
        let  attrbstr = weburlString
        newspopScroll.delegate = self
        if attrbstr != ""
        {
            newsDesc.text = newsDesc.text?.appendingFormat("\n%@", attrbstr!)
        }
        self.reportLabel.text = newsReportString
        newsDesc.sizeToFit()
        UIView.animate(withDuration: 2.0, animations: {
            self.arrowImageview.transform = CGAffineTransform(rotationAngle: (90.0 * CGFloat(M_PI)) / 180.0)
        })
        closeButton.addDropShadowToView(closeButton)
        shareButton.layer.cornerRadius = 15
        closeButton.layer.cornerRadius = 24
        let imgclose = UIImage(named: "close")
        closeButton.setImage(imgclose, for: UIControlState())
        closeButton.contentMode = .center
        let img = imageString
        
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
        
        //self.descriptionViewHeight.constant = self.newsDesc.frame.height * 2 + self.descriptionViewHeight.constant
        //self.contentViewHeight.constant = self.imageViewHeight.constant  + self.descriptionViewHeight.constant + 40
        self.imageFromServerURL(modifiedUrlString as String)
 
    }
    func imageFromServerURL(_ urlString: String) {
        self.descriptionViewHeight.constant = self.newsDesc.frame.height * 2 + self.descriptionViewHeight.constant
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.newsImage = image
                let heightimg = ((UIScreen.main.bounds.size.width - 20) * self.newsImage.size.height) / self.newsImage.size.width
                self.imageViewHeight.constant = heightimg
                self.newsInfoImageView.image = self.newsImage
                //imageViewHeight.constant = newsInfoImageView.frame.height
                self.newsInfoImageView.contentMode = .scaleAspectFill
                
                self.contentViewHeight.constant = self.imageViewHeight.constant  + self.descriptionViewHeight.constant + 80
            })
            
        }).resume()
        
    }
    override func viewDidLayoutSubviews() {
        self.newspopScroll.contentSize = CGSize(width: self.newspopScroll.contentSize.width, height: CGFloat(descriptionViewHeight.constant + imageViewHeight.constant + 80))
    }
    @IBAction func closeButtonClicked(_ sender: AnyObject) {
        DispatchQueue.main.async
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: AnyObject) {
        var firstActivityItem = "Title: "
        firstActivityItem = firstActivityItem + newsTitleString
        var secondActivityItem = "Description: "
        secondActivityItem = secondActivityItem + newsDescriptionString
        if weburlString != ""
        {
            secondActivityItem = secondActivityItem.appendingFormat("\n %@ \n", weburlString)
        }
        //let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        let thirdActivityItem = "-Shared by mConnect"
        // If you want to put an image
        //let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem,thirdActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
       /* activityViewController.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]*/
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
     
}
extension UIView {
    
    func addDropShadowToView(_ targetView:UIView? ){
        targetView!.layer.shadowColor = UIColor.black.cgColor
        targetView!.layer.shadowOpacity = 1
        targetView!.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        targetView!.layer.shadowRadius = 2
        //targetView!.layer.shouldRasterize = true
        
        targetView!.layer.masksToBounds =  false
    }
    func addCellShadowToView(_ targetView:UIView? ){
        targetView!.layer.shadowColor = UIColor.lightGray.cgColor
        targetView!.layer.shadowOpacity = 1
        targetView!.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        targetView!.layer.shadowRadius = 2
        //targetView!.layer.shouldRasterize = true
        
        targetView!.layer.masksToBounds =  false
    }
    
}

extension NSMutableAttributedString {
    
    public func setAsLink(_ textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
