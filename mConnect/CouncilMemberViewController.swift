//
//  CouncilMemberViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 04/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import QuartzCore
class CouncilMemberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ENSideMenuDelegate {
    var isValuePresent:Bool! = false
    var councilData: CouncilMemberInfoDataController!
    var  menuButton:UIButton!
    var spinner:SARMaterialDesignSpinner!
    var  menu:UIBarButtonItem!
    var imgarray:[UIImage]! = []
    var reachable:Reachability!
    var CouncilMemberArray:NSMutableArray! = NSMutableArray()
    var CommitteeInfoarray:NSMutableArray! = NSMutableArray()
    
    @IBOutlet weak var councilViewTable: UITableView!
    
    override func viewDidLoad() {
        reachable = Reachability()
        super.viewDidLoad()
       if reachable.isReachable == true {
            //print("Internet connection OK")
            
            
            councilData = CouncilMemberInfoDataController()
            self.spinner = SARMaterialDesignSpinner(frame: CGRect(x: self.view.frame.width/2 - 25,y: self.view.frame.height/2 - 25,width: 50,height: 50))
            self.view.addSubview(self.spinner)
            spinner.strokeColor =  UIColor.blue
            
            spinner.startAnimating()
        }
        else
        {
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
        councilViewTable.delegate = self
        councilViewTable.dataSource = self
        self.navigationItem.title = "Town Council"
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTableData),name:NSNotification.Name(rawValue: "councilmemberAllDataReady"), object: nil)
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func gotoHome()
    {
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    func loadTableData()
    {
        self.isValuePresent = self.councilData.isValuePresent
        if self.isValuePresent == true
        {
            self.CouncilMemberArray = self.councilData.councilinfoArray
        }
        DispatchQueue.main.async
        {
            if self.isValuePresent == true
            {
                self.councilViewTable.reloadData()
                self.spinner.stopAnimating()
            }
            
        }
        
    }
    func loadAlert()
    {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isValuePresent == true
        {
            return 100.0
        }
        return  0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isValuePresent == true
        {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isValuePresent == true
        {
            return self.CouncilMemberArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CouncilViewItemCell! = tableView.dequeueReusableCell(withIdentifier: "CouncilViewCell") as! CouncilViewItemCell
        if self.isValuePresent == true
        {
            cell.councilMemberName.text = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "councillor_name") as? String
            cell.councilMemberName.text = cell.councilMemberName.text?.uppercased()
            cell.councilMemberDesignation.text = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "councillor_designation") as? String
            let img = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "imagepath") as! String
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainUrl:NSMutableString = NSMutableString(string: appDelegate.mainUrlString)
            
            
            mainUrl.append(img)
            let string = mainUrl
            var modifiedUrlString:NSString!
            // alternative: not case sensitive
            if string.lowercased.range(of: ".jpg") != nil {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpg", with: "_s.jpg") as NSString!
            }
            else if string.lowercased.range(of: ".png") != nil
            {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".png", with: "_s.png") as NSString!
            }
            else
            {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpeg", with: "_s.jpeg") as NSString!
            }
            
            cell.councilMemberImageView.image = nil
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
                        if let currentcell:CouncilViewItemCell = cell {
                            
                            //Do UI stuff here
                            currentcell.councilMemberImageView.image = image
                            cell.councilMemberImageView.layer.cornerRadius = 40
                            cell.councilMemberImageView.layer.borderColor = UIColor.white.cgColor
                            cell.councilMemberImageView.layer.borderWidth = 1
                            cell.councilMemberImageView.layer.masksToBounds = true
                            cell.councilMemberImageView.clipsToBounds = true
                        }
                    }
                }
            })
            task.resume()
            
            let lineView = UIView(frame:CGRect(x: 60,y: 99, width: UIScreen.main.bounds.size.width, height: 1))
            lineView.backgroundColor = UIColor(hex:0xE4E3E3)
            cell.contentView.addSubview(lineView)
            let lineSideView = UIView(frame:CGRect(x: 0,y: 99, width: 60, height: 1))
            lineSideView.backgroundColor = UIColor(hex:0x0872C8)
            cell.contentView.addSubview(lineSideView)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            hideSideMenuView()
        }
        else
        {
            _ = tableView.cellForRow(at: indexPath) as! CouncilViewItemCell
            let detailView = self.storyboard?.instantiateViewController(withIdentifier: "MemberDetailViewController") as? MemberDetailViewController
            detailView?.memberNameString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "councillor_name") as? String
            detailView?.memberImageLink = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "imagepath") as? String
            detailView?.memberDesignationString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "councillor_designation") as? String
            detailView?.memberAddressString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "councillor_address") as? String
            detailView?.memberServingTermString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "term_serving") as? String
            detailView?.memberPreviousTermString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "previosterms") as? String
            detailView?.memberContactCalString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "mobileNumber") as? String
            detailView?.memberContactMailString = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "email_address") as? String
            detailView?.memberCommitteArray = (self.CouncilMemberArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "commitieearray") as? NSMutableArray
            
            self.navigationController?.pushViewController(detailView!, animated: false)
        }
    }
}
