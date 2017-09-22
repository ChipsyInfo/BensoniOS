//
//  EmergencyNumberViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 03/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class EmergencyNumberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ENSideMenuDelegate {
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var EmergencyArray:NSArray! = NSArray()
    var newBackgrndImage:UIImage!
    var initialBackgrndImage:UIImage!
    var headerView:UIView!
    var sectnArray:NSMutableArray! = NSMutableArray()
    var spinner:SARMaterialDesignSpinner!
    var isValuePresent:Bool! = false
    var reachable:Reachability!
    var emergencyData:EmergencyInfoDataController!
    @IBOutlet weak var emergencyTable: UITableView!
    @IBOutlet weak var signalButton: UIButton!
    @IBOutlet weak var tableTopView: UIView!
    @IBOutlet weak var othersView: UIView!
    @IBOutlet weak var emrAnimalButton: UIButton!
    @IBOutlet weak var emrPoisonButton: UIButton!
    @IBOutlet weak var emrFireButton: UIButton!
    @IBOutlet weak var emrPoliceButton: UIButton!
    @IBOutlet weak var emr911Button: UIButton!
    @IBOutlet weak var emergencyView1: UIView!
    @IBOutlet weak var emergencyView2: UIView!
    @IBOutlet weak var emergencyView3: UIView!
    @IBOutlet weak var emergencyView4: UIView!
    @IBOutlet weak var emergencyView5: UIView!
    @IBOutlet weak var emergencyView6: UIView!
    var Emptylabel:UILabel!
    var appDelegate:AppDelegate!
    override func viewDidLoad() {
        reachable = Reachability()
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SelectedOption = "EmergencyNumberViewController"
        DispatchQueue.main.async {
            self.Emptylabel = UILabel(frame: CGRect(x: 0, y: 400, width: UIScreen.main.bounds.width, height: 50))
            self.Emptylabel.textColor = UIColor.black
            self.Emptylabel.numberOfLines = 3
            self.Emptylabel.font = UIFont.systemFont(ofSize: 18)
            self.Emptylabel.textAlignment = .center
            self.Emptylabel.text = "There are no facebook profiles at this movement. Please check back later…"
            self.view.addSubview(self.Emptylabel)
            self.view.bringSubview(toFront: self.Emptylabel)
            self.Emptylabel.alpha = 0
        }
        
        
        if reachable.isReachable == true {
            //print("Internet connection OK")
            
            
            self.emergencyData = EmergencyInfoDataController()
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
        
        emergencyTable.delegate  = self
        emergencyTable.dataSource = self
        
        self.tableTopView.addCellShadowToView(self.tableTopView)
        //twitterData = TwitterInfoDataController()
        self.newBackgrndImage = UIImage(named: "btn_prs")
        self.initialBackgrndImage = UIImage(named: "btn")
        self.navigationItem.title = "Important Numbers"
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTableData),name:NSNotification.Name(rawValue: "emergencyAllDataReady"), object: nil)
        //self.othersView.hidden = true
        let viewtap1 = UITapGestureRecognizer(target: self, action: #selector(self.emergency911Clicked(_:)))
        self.emergencyView1.addGestureRecognizer(viewtap1)
        
        let viewtap2 = UITapGestureRecognizer(target: self, action: #selector(self.emergencypoliceclicked(_:)))
        self.emergencyView2.addGestureRecognizer(viewtap2)
        
        let viewtap3 = UITapGestureRecognizer(target: self, action: #selector(self.emergencyfireclicked(_:)))
        self.emergencyView3.addGestureRecognizer(viewtap3)
        
        let viewtap4 = UITapGestureRecognizer(target: self, action: #selector(self.emergencypoisncntrlClicked(_:)))
        self.emergencyView4.addGestureRecognizer(viewtap4)
        
        let viewtap5 = UITapGestureRecognizer(target: self, action: #selector(self.emergencyanimalcntrlClicked(_:)))
        self.emergencyView5.addGestureRecognizer(viewtap5)
        
        let viewtap6 = UITapGestureRecognizer(target: self, action: #selector(self.emergencyTrafficSignlClicked(_:)))
        self.emergencyView6.addGestureRecognizer(viewtap6)
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
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
    func gotoHome()
    {
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
        
        //self.navigationController?.presentViewController(home, animated: true, completion: nil)
    }
    func loadTableData()
    {
        DispatchQueue.main.async{
            self.isValuePresent = self.emergencyData.isValuePresent
            //self.othersView.hidden = false
            self.EmergencyArray = self.emergencyData.emergencyinfoArray
            if self.emergencyData.emergencyinfoArray.count == 0
            {
                self.spinner.stopAnimating()
                self.Emptylabel.alpha = 1
                
            }
            else
            {
                self.Emptylabel.alpha = 0
                self.sectnArray = self.emergencyData.emergencyCategoryData.emergencyCategoryarray
                self.emergencyTable.reloadData()
                self.spinner.stopAnimating()
            }
        }
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isValuePresent == true
        {
            return self.sectnArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isValuePresent == true
        {
            let emergencyarr = (self.sectnArray[section] as AnyObject).value(forKey: "emergencyArray") as! NSMutableArray
            if emergencyarr.count > 0
            {
                return emergencyarr.count
            }
            else
            {
                return 0
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isValuePresent == true
        {
            let emergencyarr = (self.sectnArray[(indexPath as NSIndexPath).section] as AnyObject).value(forKey: "emergencyArray") as! NSMutableArray
            if (indexPath as NSIndexPath).row == emergencyarr.count - 1
            {
                return 80.0
            }
        }
        return 70.0
    }
    /*
     func scrollViewDidScroll(scrollView: UIScrollView) {
     scrollView.bounces = (scrollView.contentOffset.y > 10);
     }
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EmergencyItemCell = tableView.dequeueReusableCell(withIdentifier: "EmergencyCell") as! EmergencyItemCell
        if self.isValuePresent == true
        {
            let emergencyarr = (self.sectnArray[(indexPath as NSIndexPath).section] as AnyObject).value(forKey: "emergencyArray") as! NSMutableArray
            if (indexPath as NSIndexPath).row <= emergencyarr.count - 1
            {
                //cell.cellContentFooterHeight.constant =  0
                if (indexPath as NSIndexPath).row == emergencyarr.count - 1
                {
                    cell.cellContentFooterHeight.constant =  10
                }
                else
                {
                    cell.cellContentFooterHeight.constant =  0
                }
                
                let circlename = (emergencyarr[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "emergeny_name") as? String
                let capitalizedname = circlename?.uppercased()
                let index = capitalizedname![capitalizedname!.startIndex]
                let colorpickarry:[[MaterialColor]] = MaterialColors.pick
                let colorindex : Int = Int(arc4random_uniform(UInt32(colorpickarry.count)))
                let materialColors: [MaterialColor] = MaterialColors.pick[colorindex]
                let randomIndex: Int = Int(arc4random_uniform(UInt32(materialColors.count)))
                let randomColor: UIColor = materialColors[randomIndex].color
                cell.circleView.backgroundColor = randomColor
                
                cell.cellInsideView.addCellShadowToView(cell.cellInsideView)
                cell.circleText.text = String(index)
                cell.circleText.textColor = UIColor.white
                cell.emergencyTitle.text = circlename
                
                cell.emergencyNumber.text = (emergencyarr[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "emergeny_number") as? String
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isValuePresent == true
        {
            let subView:UIView!
            headerView = UIView(frame: CGRect(x: 0,y: 0,width: self.emergencyTable.frame.width,height: 50))
            headerView.backgroundColor = UIColor(hex: 0xEDEDED)
            let headeLabel:UILabel = UILabel()
            headeLabel.font = UIFont.systemFont(ofSize: 14)
            headeLabel.textColor = UIColor.white
            headeLabel.numberOfLines = 0
            let emarr = (self.sectnArray[section] as AnyObject).value(forKey: "emergencyArray") as? NSMutableArray
            headeLabel.text = (self.sectnArray[section] as AnyObject).value(forKey: "categoryName") as? String
            headeLabel.text = headeLabel.text?.uppercased()
            headeLabel.sizeToFit()
            if section == 0
            {
                subView = UIView(frame: CGRect(x: 20,y: 8,width: self.emergencyTable.frame.width - 40 ,height: 40))
            }
            else
            {
                subView = UIView(frame: CGRect(x: 20,y: 5,width: self.emergencyTable.frame.width - 40,height: 40))
            }
            
            subView.backgroundColor = UIColor(hex:0x509FF7)
            let categorylabel:UILabel = UILabel(frame: CGRect(x: 5,y: 0,width: subView.frame.width - 10,height: 40))
            categorylabel.font = UIFont.systemFont(ofSize: 14)
            categorylabel.textAlignment = .center
            categorylabel.numberOfLines = 0
            categorylabel.textColor = UIColor.white
            categorylabel.text = headeLabel.text
            categorylabel.text = categorylabel.text?.uppercased()
            subView.layer.cornerRadius = 5
            subView.layer.borderColor = UIColor(hex: 0x0872c8)?.cgColor
            subView.layer.borderWidth = 1
            subView.addSubview(categorylabel)
            headerView.addSubview(subView)
            if emarr?.count > 0
            {
                return headerView
            }
            else
            {
                return UIView()
            }
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            hideSideMenuView()
        }
        else
        {
            let cell:EmergencyItemCell = tableView.cellForRow(at: indexPath) as! EmergencyItemCell
            var mobilenumbr = "tel:"
            var mobilestring = cell.emergencyNumber.text
            mobilestring = mobilestring?.replacingOccurrences(of: "AAA", with: "222")
            mobilestring = mobilestring?.replacingOccurrences(of: "HELP", with: "4357")
            mobilestring = mobilestring?.replacingOccurrences(of: " ", with: "")
            mobilenumbr = mobilenumbr.appendingFormat("%@", mobilestring!)
            if UIApplication.shared.canOpenURL(URL(string:mobilenumbr )!)
            {
                UIApplication.shared.openURL(URL(string:mobilenumbr )!)
            }
        }
        
    }
    @IBAction func emergency911Clicked(_ sender: AnyObject) {
       /* if UIApplication.shared.canOpenURL(URL(string:"tel:911" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:911" )!)
        }
        self.emr911Button.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
        */
        if UIApplication.shared.canOpenURL(URL(string:"tel:919-463-1600" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:919-463-1600" )!)
        }
        self.emr911Button.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencypoliceclicked(_ sender: AnyObject) {
        if UIApplication.shared.canOpenURL(URL(string:"tel:919-463-6120" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:919-463-6120" )!)
        }
        self.emrPoliceButton.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyfireclicked(_ sender: AnyObject) {
        if UIApplication.shared.canOpenURL(URL(string:"tel:919-463-7070" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:919-463-7070" )!)
        }
        self.emrFireButton.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencypoisncntrlClicked(_ sender: AnyObject) {
        if UIApplication.shared.canOpenURL(URL(string:"tel:1800-848-6946" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:1800-848-6946" )!)
        }
        self.emrPoisonButton.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyanimalcntrlClicked(_ sender: AnyObject) {
        if UIApplication.shared.canOpenURL(URL(string:"tel:919-212-7387" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:919-212-7387" )!)
        }
        self.emrAnimalButton.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyTrafficSignlClicked(_ sender: AnyObject) {
        if UIApplication.shared.canOpenURL(URL(string:"tel:919-477-2914" )!)
        {
            UIApplication.shared.openURL(URL(string:"tel:919-477-2914" )!)
        }
        self.signalButton.setBackgroundImage(self.initialBackgrndImage, for: UIControlState())
    }
    @IBAction func emergency911touchedDown(_ sender: AnyObject) {
        self.emr911Button.setBackgroundImage(self.newBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyPoliceTouchedDown(_ sender: AnyObject) {
        self.emrPoliceButton.setBackgroundImage(self.newBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyFireTouchedDown(_ sender: AnyObject) {
        self.emrFireButton.setBackgroundImage(self.newBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyPoisonTouchedDown(_ sender: AnyObject) {
        self.emrPoisonButton.setBackgroundImage(self.newBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyAnimalTouchedDown(_ sender: AnyObject) {
        self.emrAnimalButton.setBackgroundImage(self.newBackgrndImage, for: UIControlState())
    }
    @IBAction func emergencyTrafficTouchedDown(_ sender: AnyObject) {
        self.signalButton.setBackgroundImage(self.newBackgrndImage, for: UIControlState())
    }
    /*
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let sectionHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 45.0))
     let sectionTitleHeaderView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2 - 70, 5, 140, 35.0))
     sectionHeaderView.backgroundColor = UIColor(hex:0xEFEFF4)
     sectionTitleHeaderView.backgroundColor = UIColor(hex:0x509FF7)
     sectionTitleHeaderView.layer.cornerRadius = 2.0
     sectionHeaderView.addSubview(sectionTitleHeaderView)
     let headerLabel = UILabel(frame: CGRectMake((sectionTitleHeaderView.frame.size.width/2) - 90, 5, 180, 25.0))
     headerLabel.backgroundColor = UIColor.clearColor()
     headerLabel.textColor = UIColor.whiteColor()
     headerLabel.textAlignment = .Center
     headerLabel.font = UIFont.systemFontOfSize(16)
     sectionTitleHeaderView.addSubview(headerLabel)
     headerLabel.text = "Others"
     headerLabel.text = headerLabel.text?.uppercaseString
     return sectionHeaderView
     }*/
}
