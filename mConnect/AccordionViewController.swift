//
//  AccordionViewController.swift
//  homeScreen
//
//  Created by chipsy services on 08/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
protocol AccordionViewControllerDelegate
{
    func moveToScreen(_ index:Int)
}
open class AccordionViewController: UIViewController,AccordionSectionViewDelegate {
    open var isFullscreen:Bool! = false
    var delegate : AccordionViewControllerDelegate?
    open var  eventTitleArray:NSMutableArray!
    open var eventDetailArray:NSMutableArray!
    open var eventDateArray:NSMutableArray!
    open var newsTitleArray:NSMutableArray!
    open var  newsDetailArray:NSMutableArray!
    var headerLabel:UILabel!
    var content:NSMutableArray!
    var sections:NSMutableArray!
    var updateTimer:Timer!
    var newscount:UInt32!
    var eventcount:UInt32!
    var currentSection:AccordionSectionView!
    var eventSection:AccordionSectionView!
    var newsSection:AccordionSectionView!
    var val:Bool! = false
    var eventTimer:Timer!
    var newsTimer:Timer!
    var result:CGSize!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.sections = NSMutableArray()
        self.content = NSMutableArray()
        self.view.autoresizingMask = [.flexibleHeight,.flexibleWidth,.flexibleRightMargin,.flexibleLeftMargin]
        self.view.backgroundColor = UIColor.white
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func heightForOpenSection() -> CGFloat
    {
        return self.view.frame.size.height - CGFloat(Double(self.sections.count) * 100.0)
    }
    
    func createSectionWithContent(_ content:UIViewController,sectionTitle:NSArray,detailData:NSArray,dateInfo:NSArray)-> AccordionSectionView
    {
        self.content.add(content)//addObject:content];
        self.addChildViewController(content) //addChildViewController:content];
        return self.createSectionWithContentView(content.view, sectionTitle: sectionTitle, detailData: detailData, dateInfo: dateInfo)
    }
    func createSectionWithContentView(_ contentView:UIView,sectionTitle:NSArray,detailData:NSArray,dateInfo:NSArray) -> AccordionSectionView
    {
        let accordionSectionFrame:CGRect  = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 100.0)
        let accordionSection:AccordionSectionView  = AccordionSectionView(frame: accordionSectionFrame)
        accordionSection.delegate = self;
        accordionSection.contentView = contentView
        accordionSection.sectionFrame = accordionSectionFrame
        accordionSection.dateLabel.text = dateInfo[0] as? String
        if (accordionSection.dateLabel.text == "") {
            //accordionSection.headerLabel.text = "Featured News, Local Media & Citizens Talks"
            accordionSection.detailNewsLabel.text = ""
            accordionSection.newsStaticLabel.isHidden = false
            accordionSection.lineEventView.alpha = 0
            accordionSection.dateLabel.frame = CGRect(x: 130.0, y: 50.0, width: UIScreen.main.bounds.size.width - 140, height: 40.0)
            accordionSection.dateLabel.text = "Stay Connected. Stay Involved."
            self.newsSection = accordionSection
           // self.newsTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateNewsLabel), userInfo: nil, repeats: true)
           // RunLoop.main.add(self.newsTimer, forMode:RunLoopMode.commonModes)
            
        }
        else
        {
            self.eventSection = accordionSection
            accordionSection.newsStaticLabel.isHidden = true
            accordionSection.headerLabel.text = "Morrisville"
            accordionSection.lineNewsView.alpha = 0
            accordionSection.detailEventLabel.text = "Live Connected. Live Well."
            self.eventSection.detailEventLabel.numberOfLines = 1
            accordionSection.dateLabel.text = "Latest Town of MSV Official Updates"
           // self.eventTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateEventLabel), userInfo: nil, repeats: true)
            //RunLoop.main.add(self.eventTimer, forMode:RunLoopMode.commonModes)
            
        }
        
        self.view.addSubview(accordionSection)
        self.sections.add(accordionSection)
        self.update()
        return accordionSection;
    }
    
    func updateEventLabel()
    {
        
        let animation:CATransition  = CATransition()
        animation.duration = 0.5 //setDuration:0.3];
        animation.type =  kCATransitionPush// setType:kCATransitionPush];
        animation.subtype = kCATransitionFromRight //setSubtype:kCATransitionFromRight];
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFuncionEaseInEaseOut]];
        let randomValue:UInt32  = arc4random_uniform(eventcount)
        let val:Int = Int(randomValue)
        self.eventSection.headerLabel.text = self.eventTitleArray[val] as? String
        if self.eventDetailArray[val] as! String == "at "
        {
            self.eventSection.detailEventLabel.text = ""
        }
        else
        {
            self.eventSection.detailEventLabel.text = self.eventDetailArray[val] as? String
        }
        
        self.eventSection.detailEventLabel.numberOfLines = 1
        self.eventSection.dateLabel.text = self.eventDateArray[val] as? String
        
        
        self.eventSection.headerLabel.layer.add(animation, forKey: "rightToLeftAnimation")
        self.eventSection.detailEventLabel.layer.add(animation, forKey: "rightToLeftAnimation")
        self.eventSection.dateLabel.layer.add(animation, forKey: "rightToLeftAnimation")
        
    }
    func updateNewsLabel()
    {
        let animation:CATransition  = CATransition()
        animation.duration = 0.5 //setDuration:0.3];
        animation.type =  kCATransitionPush// setType:kCATransitionPush];
        animation.subtype = kCATransitionFromRight //setSubtype:kCATransitionFromRight];
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let randomValue:UInt32  = arc4random_uniform(newscount)
        let val:Int = Int(randomValue)
        
        self.newsSection.headerLabel.text = self.newsTitleArray[val] as? String
        self.newsSection.detailNewsLabel.text = self.newsDetailArray[val] as? String
        
        
        self.newsSection.headerLabel.layer.add(animation, forKey: "rightToLeftAnimation")
        self.newsSection.detailNewsLabel.layer.add(animation, forKey: "rightToLeftAnimation")
    }
    open func update()
    {
        self.val = false
       /* if iPad == true {
            /* do something specifically for iPad. */
            result = UIScreen.main.bounds.size
            if (result.height > 1300) {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 1120, width: result.width, height: result.height)
            }
            else
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 775, width: result.width, height: result.height)
                
            }
        }
        if iPhone == true{
            /* do something specifically for iPhone or iPod touch. */
            result = UIScreen.main.bounds.size
            if(result.height == 480)
            {
                //280
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 245, width: result.width, height: result.height)
                
            }
            else if(result.height == 568)
            {
                
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 320, width: result.width, height: result.height)
                
            }
            else if (result.height == 667)
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 420.0, width: result.width, height: result.height)
            }
            else
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 486.0, width: result.width, height: result.height)
            }
            
        }*/
        if iPad == true {
            /* do something specifically for iPad. */
            result = UIScreen.main.bounds.size
            if (result.height > 1300) {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 1166, width: result.width, height: result.height)
            }
            else
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 824, width: result.width, height: result.height)
                
            }
        }
        if iPhone == true{
            /* do something specifically for iPhone or iPod touch. */
            result = UIScreen.main.bounds.size
            if(result.height == 480)
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 280.0, width: result.width, height: result.height)
                
            }
            else if(result.height == 568)
            {
                
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 368.0, width: result.width, height: result.height)
                
            }
            else if (result.height == 667)
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 468.0, width: result.width, height: result.height)
            }
            else
            {
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 536.0, width: result.width, height: result.height)
            }
            
        }
        var currentYPos:CGFloat  = 0.0
        for i in 0..<self.sections.count {
            
            var accordionSection:AccordionSectionView = self.sections.object(at: i) as! AccordionSectionView
            if (self.val && i>0) {
                let headerSideViewFrame:CGRect  = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
                let headerSideView:UIView  = UIView(frame: headerSideViewFrame)//initWithFrame:headerSideViewFrame];
                let rightColor:UIColor  = UIColor(hex:0xFC7B1C)!
                let leftColor:UIColor  = UIColor(hex:0xFB852E)!
                let gradient:CAGradientLayer  = CAGradientLayer()
                gradient.frame = headerSideView.frame
                gradient.startPoint = CGPoint(x: 0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.colors = [(leftColor.cgColor),(rightColor.cgColor)]
                headerSideView.layer.insertSublayer(gradient, at: 0)
                //[headerSideView.layer insertSublayer:gradient atIndex:0];
                
                accordionSection.addSubview(headerSideView)
                let headerImageViewFrame:CGRect  = CGRect(x: 30.0, y: 20.0, width: 40, height: 40)
                let nwsimageView:UIImageView  = UIImageView(frame: headerImageViewFrame)//[[UIImageView alloc]initWithFrame:headerImageViewFrame];
                nwsimageView.image = UIImage(named: "news")
                accordionSection.addSubview(nwsimageView)
                
                let headerTriangleImageViewFrame:CGRect  = CGRect(x: 100.0, y: 38.0, width: 24, height: 24)
                let triangleImageView:UIImageView  = UIImageView(frame: headerTriangleImageViewFrame)
                triangleImageView.image = UIImage(named:"arrow_dark_or")
                accordionSection.addSubview(triangleImageView)
                self.headerLabel = UILabel(frame:CGRect(x: 32.0, y: 55.0, width: 50.0, height: 30.0))// initWithFrame:CGRectMake(32.0, 55.0, 50.0, 30.0)];
                self.headerLabel.textColor = UIColor.white
                self.headerLabel.text = "NEWS"
                self.headerLabel.font = UIFont.systemFont(ofSize: 12)
                headerSideView.addSubview(self.headerLabel)
                let lineSideView:UIView  = UIView(frame:CGRect(x: 0,y: 99.5, width: 100, height: 0.5))// initWithFrame:CGRectMake(0,99.5, 100, 0.5)];
                lineSideView.backgroundColor = UIColor(hex:0xFC6B1E)
                headerSideView.addSubview(lineSideView)
                let headersideViewTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
                headersideViewTap.numberOfTapsRequired = 1
                headerSideView.addGestureRecognizer(headersideViewTap)
                let lineView:UIView  = UIView(frame:CGRect(x: 100,y: 99.5, width: accordionSection.frame.size.width, height: 0.5)) //initWithFrame:CGRectMake(100,99.5, accordionSection.frame.size.width, 0.5)];
                lineView.backgroundColor = UIColor(hex:0xE4E3E3)
                accordionSection.addSubview(lineView)
            }
            else
            {
                let headerSideViewFrame:CGRect  = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
                let headerSideView:UIView  = UIView(frame:headerSideViewFrame) //initWithFrame:headerSideViewFrame];
                let rightColor:UIColor = UIColor(hex:0x1986FF )!
                let leftColor:UIColor = UIColor(hex:0x509FF7)!
                let gradient:CAGradientLayer = CAGradientLayer()
                
                gradient.frame = headerSideView.frame;
                gradient.startPoint = CGPoint(x: 0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradient.colors = [(leftColor.cgColor),(rightColor.cgColor)]
                
                accordionSection.addSubview(headerSideView)
                headerSideView.layer.insertSublayer(gradient, at: 0)
                let headerImageViewFrame:CGRect  = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
                let eventimageView:UIImageView  = UIImageView(frame:headerImageViewFrame)//initWithFrame:headerImageViewFrame];
                eventimageView.image = UIImage(named:"tweet")
                accordionSection.addSubview(eventimageView)
                
                let headerTriangleImageViewFrame:CGRect  = CGRect(x: 100.0, y: 38.0, width: 24, height: 24)
                let triangleImageView:UIImageView  = UIImageView(frame:headerTriangleImageViewFrame)
                let blueimg = self.setcolorImage(UIImage(named:"arrow_dark_blue")!)
                triangleImageView.image = blueimg
                accordionSection.addSubview(triangleImageView)
                
                self.headerLabel = UILabel(frame:CGRect(x: 28.0, y: 58.0, width: 50.0, height: 30.0))
                self.headerLabel.textColor = UIColor.white
                self.headerLabel.text = "EVENTS"
                self.headerLabel.font = UIFont.systemFont(ofSize: 12)// systemFontOfSize:12.0]
                //headerSideView.addSubview(self.headerLabel)
                let lineSideView:UIView  = UIView(frame:CGRect(x: 0,y: 99.5, width: 100, height: 0.5))// initWithFrame:CGRectMake(0,99.5, 100, 0.5)]
                lineSideView.backgroundColor = UIColor(hex:0x0872C8)
                headerSideView.addSubview(lineSideView)
                let headersideViewTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
                headersideViewTap.numberOfTapsRequired = 1
                headerSideView.addGestureRecognizer(headersideViewTap)
                let lineView:UIView  = UIView(frame:CGRect(x: 100,y: 99.5, width: accordionSection.frame.size.width, height: 0.5))// initWithFrame:CGRectMake(100,99.5, accordionSection.frame.size.width, 0.5)]
                lineView.backgroundColor = UIColor(hex:0xE4E3E3)
                accordionSection.addSubview(lineView)
                
            }
            if(self.currentSection != nil)
            {
                accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos, width: accordionSection.frame.size.width, height: self.heightForOpenSection()+50.0)
                
                currentYPos += self.heightForOpenSection()
            }
            else
            {
                if i>0
                {
                    currentYPos += 100.0 
                }
                
                accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos, width: accordionSection.frame.size.width, height: 100.0)
                self.val = true
            }
            
        }
    }
    func loadSectionFrame(_ view:AccordionSectionView,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)-> AccordionSectionView
    {
        view.sectionFrame = CGRect(x: x, y: y, width: width, height: height)
        return view
    }
    func loadViewFrame(_ view:UIView,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat)-> UIView
    {
        view.frame = CGRect(x: x, y: y, width: width, height: height)
        return view
    }
    func updateFullscreen()
    {
        var currentYPos:CGFloat  = 0.0
        for i in 0..<self.sections.count{
            var accordionSection:AccordionSectionView = self.sections.object(at: i) as! AccordionSectionView
            if(self.currentSection != nil) {
                if self.currentSection == accordionSection
                {
                    
                    self.view.bringSubview(toFront: accordionSection)
                    accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos, width: accordionSection.frame.size.width, height: self.heightForOpenSection()+200)
                    if i == 0
                    {
                        currentYPos += self.heightForOpenSection()
                        view.viewWithTag(55)?.removeFromSuperview()
                    }
                    else
                    {
                        /*
                         let menuItemImage = UIImage(named: "bg-menuitem")!
                         let menuItemHighlitedImage = UIImage()
                         
                         let starImage = UIImage(named: "icon-star")!
                         
                         let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
                         
                         let starMenuItem2 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
                         
                         let starMenuItem3 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
                         
                         let starMenuItem4 = PathMenuItem(image: UIImage(), highlightedImage: UIImage(), contentImage: UIImage())
                         
                         let starMenuItem5 = PathMenuItem(image: UIImage(), highlightedImage: UIImage(), contentImage: UIImage())
                         
                         let items = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5]
                         
                         let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
                         highlightedImage: UIImage(),
                         contentImage: UIImage(named: "icon-plus"),
                         highlightedContentImage: UIImage())
                         
                         let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
                         menu.delegate = self
                         menu.tag = 55
                         menu.startPoint     = CGPointMake(UIScreen.mainScreen().bounds.width - 40.0, view.frame.size.height - 40.0)
                         menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
                         menu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
                         menu.timeOffset     = 0.0
                         menu.farRadius      = 70
                         menu.nearRadius     = 40
                         menu.endRadius      = 70
                         menu.animationDuration = 0.5
                         
                         view.addSubview(menu)
                         */
                        
                    }
                    
                }
                else
                {
                    view.viewWithTag(55)?.removeFromSuperview()
                    if (currentYPos > 535)
                    {
                        self.view.addSubview(accordionSection)
                        accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+36, width: accordionSection.frame.size.width, height: 100.0)
                        
                    }
                    else if (currentYPos > 466) {
                        self.view.addSubview(accordionSection)
                        accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+37, width: accordionSection.frame.size.width, height: 100.0)
                    }
                    else if (currentYPos > 367) {
                        self.view.addSubview(accordionSection)
                        accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+36, width: accordionSection.frame.size.width, height: 100.0)
                    }
                    else if (currentYPos > 279)
                    {
                        self.view.addSubview(accordionSection)
                        accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+36, width: accordionSection.frame.size.width, height: 100.0)
                    }
                    else
                    {
                        let val:CGFloat = CGFloat(i*100)
                        if iPad == true
                        {
                            
                            /* do something specifically for iPad. */
                            accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: val, width: accordionSection.frame.size.width, height: 100.0)
                            
                        }
                        if iPhone == true
                        {
                            /* do something specifically for iPhone or iPod touch. */
                            accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: val, width: accordionSection.frame.size.width, height: 100.0)
                            
                        }
                        
                        
                    }
                }
                
                
            }
            else
            {
                if (currentYPos > 535)
                {
                    self.view.addSubview(accordionSection)
                    accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+36, width: accordionSection.frame.size.width, height: 100.0)
                    
                }
                else if (currentYPos > 466) {
                    self.view.addSubview(accordionSection)
                    accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+37, width: accordionSection.frame.size.width, height: 100.0)
                }
                else if (currentYPos > 367) {
                    self.view.addSubview(accordionSection)
                    accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+36, width: accordionSection.frame.size.width, height: 100.0)
                }
                else if (currentYPos > 279)
                {
                    self.view.addSubview(accordionSection)
                    accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: currentYPos+36, width: accordionSection.frame.size.width, height: 100.0)
                }
                else
                {
                    let val:CGFloat = CGFloat(i*100)
                    if iPad == true
                    {
                        
                        /* do something specifically for iPad. */
                        accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: val, width: accordionSection.frame.size.width, height: 100.0)
                        
                    }
                    if iPhone == true
                    {
                        /* do something specifically for iPhone or iPod touch. */
                        accordionSection = self.loadSectionFrame(accordionSection, x: 0.0, y: val, width: accordionSection.frame.size.width, height: 100.0)
                        
                    }
                    
                    
                }
                
                
            }
        }
    }
    func updateAnimated()
    {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations:{
            if self.iPad == true {
                /* do something specifically for iPad. */
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                
            }
            if self.iPhone == true
            {
                /* do something specifically for iPhone or iPod touch. */
                self.view = self.loadViewFrame(self.view, x: 0.0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }
            if self.isFullscreen == true
            {
                self.updateFullscreen()
            }
            else
            {
                self.update()
            }
            
            }, completion: {(value: Bool) in
        })
    }
    func updateBackAnimated()
    {
        result = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations:{
            if self.iPad == true {
                /* do something specifically for iPad. */
                
                if (self.result.height > 1300) {
                    self.view = self.loadViewFrame(self.view, x: 0.0, y: 1166, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                }
                else
                {
                    self.view = self.loadViewFrame(self.view, x: 0.0, y: 824, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    
                }
            }
            if self.iPhone == true
            {
                /* do something specifically for iPhone or iPod touch. */
                if(self.result.height == 480)
                {
                    self.view = self.loadViewFrame(self.view, x: 0.0, y: 280.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                }
                else if(self.result.height == 568)
                {
                    self.view = self.loadViewFrame(self.view, x: 0.0, y: 368.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                }
                else if (self.result.height == 667)
                {
                    self.view = self.loadViewFrame(self.view, x: 0.0, y: 468.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                }
                else
                {
                    self.view = self.loadViewFrame(self.view, x: 0.0, y: 536.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                }
            }
            if self.isFullscreen == true
            {
                self.updateFullscreen()
            }
            else
            {
                self.update()
            }
            
            }, completion: {(value: Bool) in
        })
    }
    func imageTapped(_ tap:UITapGestureRecognizer)
    {
        if sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            hideSideMenuView()
        }
        else
        {
            let accordionSection:AccordionSectionView  = tap.view?.superview as! AccordionSectionView
            self.accordionSectionWasSelected(accordionSection)
        }
        
    }
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    func setcolorImage(_ img:UIImage)-> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
        img.draw(in: rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        
        context.setFillColor(UIColor(hex:0x0169a6)!.cgColor);
        context.fill(rect);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage
    }
    func accordionSectionWasSelected(_ accordionSection: AccordionSectionView) {
        if((self.delegate) != nil)
        {
            self.currentSection = accordionSection
            if (self.currentSection.dateLabel.text == "Latest Town of MSV Official Updates")
            {
                delegate?.moveToScreen(1)
            }
            else
            {
                delegate?.moveToScreen(2)
            }
            
        }/*
        if(self.currentSection != nil) {
            
            if self.currentSection == accordionSection
            {
                self.currentSection = nil
                self.newsTimer.invalidate()
                //accordionSection.newsStaticLabel.hidden = true
                if #available(iOS 8.2, *) {
                    accordionSection.detailEventLabel.font = UIFont.systemFont(ofSize: 12, weight: -2.0)
                } else {
                    // Fallback on earlier versions
                    accordionSection.detailEventLabel.font = UIFont.systemFont(ofSize: 12)
                }
                if (accordionSection.newsStaticLabel.isHidden == true) {
                    accordionSection.headerLabel.isHidden = false
                    accordionSection.dateLabel.isHidden = false
                    accordionSection.detailEventLabel.numberOfLines = 1
                    //accordionSection.detailEventLabel.text = ""
                    accordionSection.headerLabel.text = self.eventTitleArray[0] as? String
                    accordionSection.detailEventLabel.text = self.eventDetailArray[0] as? String
                    
                    accordionSection.dateLabel.text = self.eventDateArray[0] as? String
                }
                else
                {
                    accordionSection.newsStaticLabel.isHidden = true
                    accordionSection.headerLabel.isHidden = false
                    accordionSection.detailNewsLabel.isHidden = false
                }
                
                self.eventTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateEventLabel), userInfo: nil, repeats: true)
                RunLoop.main.add(self.eventTimer, forMode:RunLoopMode.commonModes)
                self.updateBackAnimated()
                self.newsTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateNewsLabel), userInfo: nil, repeats: true)
                RunLoop.main.add(self.newsTimer, forMode:RunLoopMode.commonModes)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "hideflowingbuttonmenu"), object: self, userInfo: nil)
                
            }
            else
            {
                self.currentSection = accordionSection
                if (self.currentSection.dateLabel.text == "") {
                    self.newsTimer.invalidate()
                    accordionSection.headerLabel.isHidden = true
                    accordionSection.detailNewsLabel.isHidden = true
                    accordionSection.newsStaticLabel.isHidden = false
                    delay(0.3)
                    {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "displayflowingbuttonmenu"), object: self, userInfo: nil)
                    }
                }
                self.eventSection.headerLabel.isHidden = false
                self.eventSection.dateLabel.isHidden = false
                self.eventSection.detailEventLabel.numberOfLines = 1
                //accordionSection.detailEventLabel.text = ""
                self.eventSection.headerLabel.text = self.eventTitleArray[0] as? String
                self.eventSection.detailEventLabel.text = self.eventDetailArray[0] as? String
                
                self.eventSection.dateLabel.text = self.eventDateArray[0] as? String
                self.eventTimer.invalidate()
                self.updateAnimated()
            }
        }
        else
        {
            self.currentSection = accordionSection
            if (self.currentSection.dateLabel.isHidden == true || self.currentSection.dateLabel.text == "") {
                self.newsTimer.invalidate()
                accordionSection.headerLabel.isHidden = true
                accordionSection.detailNewsLabel.isHidden = true
                accordionSection.newsStaticLabel.isHidden = false
                delay(0.3)
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "displayflowingbuttonmenu"), object: self, userInfo: nil)
                }
            }
            else
            {
                accordionSection.headerLabel.isHidden = true
                accordionSection.dateLabel.isHidden = true
                
                accordionSection.detailEventLabel.font = UIFont.systemFont(ofSize: 14)
                
                //accordionSection.detailEventLabel.font = UIFont.systemFontOfSize(11)
                accordionSection.detailEventLabel.numberOfLines = 3
                accordionSection.detailEventLabel.text = "Upcoming Events and Ongoing Events, for more click Main Menu"
            }
            self.eventTimer.invalidate()
            self.updateAnimated()
        }*/
    }
    
}
extension AccordionViewController: PathMenuDelegate {
    public func pathMenu(_ menu: PathMenu, didSelectIndex idx: Int) {
        print("Select the index : \(idx)")
    }
    
    public func pathMenuWillAnimateOpen(_ menu: PathMenu) {
        print("Menu will open!")
    }
    
    public func pathMenuWillAnimateClose(_ menu: PathMenu) {
        print("Menu will close!")
    }
    
    public func pathMenuDidFinishAnimationOpen(_ menu: PathMenu) {
        print("Menu was open!")
    }
    
    public func pathMenuDidFinishAnimationClose(_ menu: PathMenu) {
        print("Menu was closed!")
    }
}
