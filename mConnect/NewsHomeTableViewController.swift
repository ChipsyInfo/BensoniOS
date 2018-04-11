//
//  NewsHomeTableViewController.swift
//  homeScreen
//
//  Created by chipsy services on 08/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
var CellnewsIdentifier = "NewsCell"
class NewsHomeTableViewController: UITableViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var newsHomeTable: UITableView!
    var newsarray:NSMutableArray! = NSMutableArray()
    var newsTitleArray: NSMutableArray!
    var newsDetailArray: NSMutableArray!
    var newsDataArray:NSArray!
    var imgarray:[UIImage]! = []
    var homeData:HomeInfoDataController!
    var newsHomeImage:UIImage!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .currentContext
        newsHomeTable.delegate = self
        newsHomeTable.dataSource = self
        newsarray = self.homeData.newsArray
        
        DispatchQueue.main.async
        {
            
            self.newsHomeTable.reloadData()
        }
        let dict:NSDictionary! = NSDictionary()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadNewsTable(_:)), name: NSNotification.Name(rawValue: "NewsUpdate"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.animateTable()
        
        
    }
    func animateTable() {
        newsHomeTable.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: NewsHomeCell = a as! NewsHomeCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    func reloadNewsTable(_ notification:Notification)
    {
        DispatchQueue.main.async
        {
            self.newsDataArray = (notification as NSNotification).userInfo!["newsArray"] as! NSArray
            //self.newsDataArray = self.homeData.newsArray
            
            let newstitleArray:NSMutableArray = NSMutableArray()
            let newsdetailArray:NSMutableArray = NSMutableArray()
            for news in self.newsDataArray
            {
                let newstitle = (news as AnyObject).value(forKey: "title") as! String
                newstitleArray.add(newstitle)
                
                let newsdetail = (news as AnyObject).value(forKey: "descriptn") as! String
                newsdetailArray.add(newsdetail)
                
            }
            self.newsTitleArray = newstitleArray
            self.newsDetailArray = newsdetailArray
            self.newsHomeTable.reloadData()
        }
    }
    override func viewDidLayoutSubviews() {
        self.tableView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(newsTitleArray.count*80 + 60))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTitleArray.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsHomeCell!  = tableView.dequeueReusableCell(withIdentifier: CellnewsIdentifier) as! NewsHomeCell//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.newsTitle.text = self.newsTitleArray[(indexPath as NSIndexPath).row] as? String
        //cell.newsTitle.font = UIFont.systemFontOfSize(14)
        //cell.newsTitle.sizeToFit()
        let img = (self.newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "small_image") as! String
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
        
        cell.newsHomeImageView.image = nil
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
                    if let currentcell:NewsHomeCell = cell {
                        
                        //Do UI stuff here
                        
                        currentcell.newsHomeImageView.image = image
                        
                        
                    }
                }
            }
        })
        task.resume()
        //cell.newsHomeImageView.image = imgarray[indexPath.row]
        
        
        //cell.newsHomeImageView.contentMode = .ScaleAspectFit
        //cell.newsDetail.numberOfLines = 2
        cell.newsDetail.text = self.newsDetailArray[(indexPath as NSIndexPath).row] as? String
        cell.newsDetail.sizeToFit()
        let lineView = UIView(frame: CGRect(x: 0,y: 79, width: UIScreen.main.bounds.size.width, height: 1))
        // Configure the cell...
        
        lineView.backgroundColor = UIColor(hex:0xE4E3E3)
        cell.contentView.addSubview(lineView)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.parent?.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            self.parent?.hideSideMenuView()
        }
        else
        {
            let cell:NewsHomeCell  = tableView.cellForRow(at: indexPath) as! NewsHomeCell
            let popupView = self.storyboard?.instantiateViewController(withIdentifier: "NewsPopupViewcontroller") as? NewsPopupViewcontroller
            popupView!.modalPresentationStyle = .overFullScreen
            //popupView?.delegate = self
            //loginView!.preferredContentSize = CGSizeMake(50, 100)
            popupView?.newsTitleString = cell.newsTitle.text
            popupView?.newsDescriptionString = cell.newsDetail.text
            var reportString:String!
            reportString = "Posted on: "
            reportString = reportString.appendingFormat("%@", (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String) //appending((newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String)
            reportString = reportString.appending(", ")
            reportString = reportString.appendingFormat("%@", (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as! String)
            popupView?.newsReportString = reportString
            popupView?.imageString = (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "large_image") as! String
            let weburl = (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "websiteurl") as! String
            if weburl != ""
            {
                popupView?.weburlString = weburl
            }
            else
            {
                popupView?.weburlString = ""
            }
            let popoverMenuViewController = popupView!.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = .any
            popoverMenuViewController?.delegate = self
            self.view.window!.rootViewController!.present(popupView!,animated: true,completion: nil)
        }
        
        
    }
    
}
