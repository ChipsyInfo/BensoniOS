//
//  AccordionSectionView.swift
//  homeScreen
//
//  Created by chipsy services on 08/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
protocol AccordionSectionViewDelegate
{
    func accordionSectionWasSelected(_ accordionSection:AccordionSectionView)
}
var kHeaderViewHeight:CGFloat = 100
class AccordionSectionView: UIView {
    var contentViewFrame:CGRect!
    var _contentView : UIView?
    var _headerView : UIView?
    var contentView:UIView{
        get {
            return _contentView!
        }
        set {
            if _contentView != nil {
                _contentView?.removeFromSuperview()
                _contentView = nil
            }
            _contentView = newValue
            
            var contentViewFrame:CGRect  = _contentView!.frame
            contentViewFrame.origin.x = 0.0
            contentViewFrame.origin.y = kHeaderViewHeight
            
            _contentView!.frame = contentViewFrame
            
            self.addSubview(_contentView!)
            self.sendSubview(toBack: _contentView!)//[self sendSubviewToBack:_contentView];
        }
    }
    var headerView:UIView{
        get
        {
            return _headerView!
        }
        set{
            if _headerView != nil {
                _headerView!.removeFromSuperview()
                _headerView = nil
            }
            _headerView = newValue
            _headerView!.autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin]//UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            
            for recognizer in _headerView!.gestureRecognizers ?? [] {
                _headerView!.removeGestureRecognizer(recognizer)
            }
            let singleFingerTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.headerViewWasTouched(_:)))//[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewWasTouched:)];
            singleFingerTap.numberOfTapsRequired = 1
            _headerView!.addGestureRecognizer(singleFingerTap)
            
            var headerViewFrame:CGRect  = _headerView!.frame
            headerViewFrame.origin.x = 0.0;
            headerViewFrame.origin.y = 0.0;
            _headerView!.frame = headerViewFrame;
            
            self.addSubview(_headerView!)
        }
    }
    var indicatorView:UIView!
    var headerLabel:UILabel!
    var detailNewsLabel:UILabel!
    var lineEventView:UIView!
    var lineNewsView:UIView!
    var detailEventLabel:UILabel!
    var dateLabel:UILabel!
    var newsStaticLabel:UILabel!
    var sectionFrame:CGRect
    {
        get{
            return self.frame
        }
        set{
            self.frame = newValue
            
            contentViewFrame = self.contentView.frame
            contentViewFrame.size.width = frame.size.width
            contentViewFrame.size.height = frame.size.height - kHeaderViewHeight
            self.contentView.frame = contentViewFrame
        }
    }
    var delegate:AccordionSectionViewDelegate?
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin]
        self.clipsToBounds = true
        //self.val = NO;
        self.createHeaderView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createHeaderView()
    {
       let headerViewFrame:CGRect  = CGRect(x: 0.0, y: 64.0, width: self.frame.size.width, height: kHeaderViewHeight)
        
        let headerView:UIView  = UIView(frame: headerViewFrame)
        //CGFloat hue = ( arc4random() % 256 / 256.0 );
        //CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        //CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        //headerView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        headerView.backgroundColor = UIColor.white
        
       /* if iPad == true {
            /* do something specifically for iPad. */
            self.headerLabel = UILabel(frame:CGRect(x: 130.0, y: 0.0, width: UIScreen.main.bounds.size.width - 150, height: 50.0))
            self.headerLabel.textColor = UIColor.black
            self.headerLabel.textAlignment = .center
            self.headerLabel.numberOfLines = 2
            self.headerLabel.font = UIFont.systemFont(ofSize: 24)
            //self.headerLabel.backgroundColor = [UIColor clearColor];
            headerView.addSubview(self.headerLabel)
            
            self.detailEventLabel = UILabel(frame:CGRect(x: 130.0, y: 8.0, width: UIScreen.main.bounds.size.width - 150, height: 90.0))
            self.detailEventLabel.textColor = UIColor.black
            self.detailEventLabel.textAlignment = .center
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            if #available(iOS 8.2, *) {
                self.detailEventLabel.font = UIFont.systemFont(ofSize: 12, weight: -2.0)
            } else {
                // Fallback on earlier versions
                self.detailEventLabel.font = UIFont.systemFont(ofSize: 12)
            }
            self.detailEventLabel.backgroundColor = UIColor.clear
            self.detailEventLabel.numberOfLines = 3
            //self.detailEventLabel.lineBreakMode = .byTruncatingTail
            //self.detailEventLabel.textAlignment = .left
            //self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerView.addSubview(self.detailEventLabel)
            
            self.newsStaticLabel = UILabel(frame:CGRect(x: 130.0, y: 0.0, width: UIScreen.main.bounds.size.width - 150, height: 70))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 20.0, 170, 50.0)];
            self.newsStaticLabel.textColor = UIColor.black
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            
            if #available(iOS 8.2, *) {
                self.newsStaticLabel.font = UIFont.systemFont(ofSize: 14, weight: -1.0)
            } else {
                // Fallback on earlier versions
                self.newsStaticLabel.font = UIFont.systemFont(ofSize: 14)
            }
            self.newsStaticLabel.textAlignment = .center
            self.newsStaticLabel.backgroundColor = UIColor.clear
            self.newsStaticLabel.numberOfLines = 2
            //self.newsStaticLabel.lineBreakMode = .byTruncatingTail
            self.newsStaticLabel.text = "Featured News, Local Media & Citizens Talks"
            //self.newsStaticLabel.isHidden = true
            headerView.addSubview(self.newsStaticLabel)
            
            self.detailNewsLabel = UILabel(frame:CGRect(x: 130.0, y: 40.0, width: UIScreen.main.bounds.size.width - 150, height: 50.0))
            self.detailNewsLabel.textColor = UIColor.black
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            if #available(iOS 8.2, *) {
                self.detailNewsLabel.font = UIFont.systemFont(ofSize: 12, weight: -2.0)
            } else {
                // Fallback on earlier versions
                self.detailNewsLabel.font = UIFont.systemFont(ofSize: 12)
            }
            self.detailNewsLabel.backgroundColor = UIColor.clear
            self.detailNewsLabel.numberOfLines = 1
            self.detailNewsLabel.textAlignment = .natural
            //self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerView.addSubview(self.detailNewsLabel)
            
            self.dateLabel = UILabel(frame:CGRect(x: 130.0, y: 60.0, width: UIScreen.main.bounds.size.width - 150, height: 40.0))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 50.0, 200, 50.0)];
            self.dateLabel.textColor = UIColor.darkGray
            self.dateLabel.textAlignment = .center
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            if #available(iOS 8.2, *) {
                self.dateLabel.font = UIFont.systemFont(ofSize: 12, weight: -2.0)
            } else {
                // Fallback on earlier versions
                self.dateLabel.font = UIFont.systemFont(ofSize: 12)
            }//[UIFont systemFontOfSize:12 weight:-2.0]
            self.dateLabel.contentMode = .bottom
            self.dateLabel.backgroundColor = UIColor.clear
            self.dateLabel.numberOfLines = 1
            
            //self.dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerView.addSubview(self.dateLabel)
            
        } else {*/
            /* do something specifically for iPhone or iPod touch. */
            self.headerLabel = UILabel(frame:CGRect(x: 130.0, y: -3.0, width: UIScreen.main.bounds.size.width - 140, height: 50.0))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 10.0, self.frame.size.width - 150, 30.0)];
            self.headerLabel.textColor = UIColor.black
            self.headerLabel.textAlignment = .center
            self.headerLabel.font = UIFont(name: "BellMT", size: 34.0)
            //self.headerLabel.font = UIFont.systemFont(ofSize: 40)//[UIFont systemFontOfSize:16]
            self.headerLabel.numberOfLines = 2
            //self.headerLabel.lineBreakMode = .byTruncatingTail
            //self.headerLabel.backgroundColor = [UIColor clearColor];
            headerView.addSubview(self.headerLabel)
            
            self.lineEventView = UIView(frame: CGRect(x: 130.0, y: 65.0, width: UIScreen.main.bounds.size.width - 140, height: 1.0))
            self.lineEventView.backgroundColor = UIColor(hex: 0x268739)
            headerView.addSubview(self.lineEventView)
            
            self.lineNewsView = UIView(frame: CGRect(x: 130.0, y: 55.0, width: UIScreen.main.bounds.size.width - 140, height: 1.0))
            self.lineNewsView.backgroundColor = UIColor.orange
            headerView.addSubview(self.lineNewsView)
            
            self.detailEventLabel = UILabel(frame:CGRect(x: 130.0, y: 10.0, width: UIScreen.main.bounds.size.width - 140, height: 90.0))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 20.0, 170, 50.0)];
            self.detailEventLabel.textColor = UIColor.black
            self.detailEventLabel.textAlignment = .center
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            if #available(iOS 8.2, *) {
                self.detailEventLabel.font = UIFont.systemFont(ofSize: 14, weight: -1.0)
            } else {
                // Fallback on earlier versions
                self.detailEventLabel.font = UIFont.systemFont(ofSize: 14)
            }//[UIFont systemFontOfSize:14 weight: -1.0f]
            self.detailEventLabel.backgroundColor = UIColor.clear
            self.detailEventLabel.numberOfLines = 3
            //self.detailEventLabel.lineBreakMode = .byTruncatingTail
            headerView.addSubview(self.detailEventLabel)
            
            self.newsStaticLabel = UILabel(frame:CGRect(x: 130.0, y: 0.0, width: UIScreen.main.bounds.size.width - 135, height: 60))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 20.0, 170, 50.0)];
            self.newsStaticLabel.textColor = UIColor.black
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            
            if #available(iOS 8.2, *) {
                self.newsStaticLabel.font = UIFont.systemFont(ofSize: 14, weight: -1.0)
            } else {
                // Fallback on earlier versions
                self.newsStaticLabel.font = UIFont.systemFont(ofSize: 14)
            }
            
            self.newsStaticLabel.backgroundColor = UIColor.clear
            self.newsStaticLabel.numberOfLines = 2
            self.newsStaticLabel.textAlignment = .center
            //self.newsStaticLabel.lineBreakMode = .byTruncatingTail
            self.newsStaticLabel.text = "Featured News, Local Media & Citizens Talks"
            //self.newsStaticLabel.isHidden = true
            headerView.addSubview(self.newsStaticLabel)
            
            self.detailNewsLabel = UILabel(frame:CGRect(x: 130.0, y: 40.0, width: UIScreen.main.bounds.size.width - 140, height: 50.0))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 40.0, 170, 50.0)];
            self.detailNewsLabel.textColor = UIColor.black
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            if #available(iOS 8.2, *) {
                self.detailNewsLabel.font = UIFont.systemFont(ofSize: 14, weight: -1.0)
            } else {
                // Fallback on earlier versions
                self.detailNewsLabel.font = UIFont.systemFont(ofSize: 14)
            }//[UIFont systemFontOfSize:14 weight: -1.0f
            self.detailNewsLabel.backgroundColor = UIColor.clear
            self.detailNewsLabel.numberOfLines = 2
            self.detailNewsLabel.lineBreakMode = .byTruncatingTail
            headerView.addSubview(self.detailNewsLabel)
            
            self.dateLabel = UILabel(frame:CGRect(x: 130.0, y: 60.0, width: UIScreen.main.bounds.size.width - 140, height: 40.0))//[[UILabel alloc] initWithFrame:CGRectMake(130.0, 50.0, 200, 50.0)];
            self.dateLabel.textColor = UIColor.darkGray
            self.dateLabel.textAlignment = .center
            self.dateLabel.contentMode = .bottom
            //self.detailLabel.font = [UIFont systemFontOfSize:10];
            if #available(iOS 8.2, *) {
                if self.iPhone == true
                {
                    if UIScreen.main.bounds.height == 480.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 10, weight: -1.0)
                    }
                    if UIScreen.main.bounds.height == 568.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 10, weight: -1.0)
                    }
                    if UIScreen.main.bounds.height == 667.0
                    {
                       self.dateLabel.font = UIFont.systemFont(ofSize: 14, weight: -1.0)
                    }
                    if UIScreen.main.bounds.height == 736.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 15, weight: -1.0)
                    }
                    
                }
                if self.iPad == true
                {
                    self.dateLabel.font = UIFont.systemFont(ofSize: 16, weight: -1.0)
                    if UIScreen.main.bounds.height == 1024.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 16, weight: -1.0)
                    }
                    if UIScreen.main.bounds.height == 1366.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 16, weight: -1.0)
                    }
                    if UIScreen.main.bounds.height == 1112.0
                    {
                       self.dateLabel.font = UIFont.systemFont(ofSize: 16, weight: -1.0)
                    }
                }
            } else {
                // Fallback on earlier versions
                if self.iPhone == true
                {
                    if UIScreen.main.bounds.height == 480.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 10)
                    }
                    if UIScreen.main.bounds.height == 568.0
                    {
                       self.dateLabel.font = UIFont.systemFont(ofSize: 10)
                    }
                    if UIScreen.main.bounds.height == 667.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 14)
                    }
                    if UIScreen.main.bounds.height == 736.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 15)
                    }
                    
                }
                if self.iPad == true
                {
                    self.dateLabel.font = UIFont.systemFont(ofSize: 16)
                    if UIScreen.main.bounds.height == 1024.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 16)
                    }
                    if UIScreen.main.bounds.height == 1366.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 16)
                    }
                    if UIScreen.main.bounds.height == 1112.0
                    {
                        self.dateLabel.font = UIFont.systemFont(ofSize: 16)
                    }
                }
            }
            self.dateLabel.backgroundColor = UIColor.clear
            self.dateLabel.numberOfLines = 1
            //self.dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerView.addSubview(self.dateLabel)
            
            
       // }
        self.headerView = headerView;
    }
    func headerViewWasTouched(_ recognizer:UITapGestureRecognizer)
    {
        if self.delegate != nil
        {
            self.delegate?.accordionSectionWasSelected(self)
        }
    }
    
}
