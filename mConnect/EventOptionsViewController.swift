//
//  EventOptionsViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 09/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
protocol EventOptionsViewControllerDelegate
{
    func updateEvents(_ categoryid:Int,categoryName:String)
}
class EventOptionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    var isValuePresent:Bool! = false
    var delegate:EventOptionsViewControllerDelegate!
    var eventCategoryArray:NSMutableArray! = NSMutableArray()
    var eventCategoryData:EventsCategoryDataController!
    @IBOutlet weak var EventOptionsTable: UITableView!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EventOptionsTable.delegate = self
        self.EventOptionsTable.dataSource = self
        let viewtap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        viewtap.delegate = self
        self.view.addGestureRecognizer(viewtap)
        self.isValuePresent = self.eventCategoryData.isValuePresent
        if self.isValuePresent == true
        {
            //self.eventCategoryArray.removeObjectAtIndex(0)
            self.eventCategoryArray.removeAllObjects()
            self.eventCategoryArray = self.eventCategoryData.eventcategoryinfoArray
            self.eventCategoryArray.insert("All", at: 0)
            
            DispatchQueue.main.async {
                self.EventOptionsTable.reloadData()
                //self.flowmenu.hidden = true
            }
            
        }
        //self.eventCategoryData = EventsCategoryDataController()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loadTableData), name: "eventCategoryAllDataReady", object: nil)
    }
    func viewTapped()
    {
        if self.delegate != nil
        {
            DispatchQueue.main.async{
                self.eventCategoryArray.removeObject(at: 0)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isDescendant(of: self.EventOptionsTable) {
            return false
        }
        return true
    }
    func loadTableData()
    {
        
        self.isValuePresent = self.eventCategoryData.isValuePresent
        if self.isValuePresent == true
        {
            self.eventCategoryArray = self.eventCategoryData.eventcategoryinfoArray
            self.eventCategoryArray.insert("All", at: 0)
            DispatchQueue.main.async {
                self.EventOptionsTable.reloadData()
                //self.flowmenu.hidden = true
            }
            
        }
        
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
            return self.eventCategoryArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventCategoryCell")!
        
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            }
            if UIScreen.main.bounds.height == 667.0
            {
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                
            }
            if UIScreen.main.bounds.height == 736.0
            {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            }
            
        }
        if self.iPad == true
        {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
            if UIScreen.main.bounds.height == 1024.0
            {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                
                cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
            }
        }
        if (indexPath as NSIndexPath).row == 0
        {
            cell.textLabel?.text = self.eventCategoryArray[(indexPath as NSIndexPath).row] as? String
        }
        else
        {
            cell.textLabel?.text = (self.eventCategoryArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "eventcategoryname") as? String
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cel = tableView.cellForRow(at: indexPath)
        let categoryname = cel?.textLabel?.text
        if categoryname == "All"
        {
            if self.delegate != nil
            {
                DispatchQueue.main.async{
                    self.delegate.updateEvents(0, categoryName: categoryname!)
                    self.eventCategoryArray.removeObject(at: 0)
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
        }
        else
        {
            let category = self.eventCategoryArray[(indexPath as NSIndexPath).row] as! EventCategory
            
            if self.delegate != nil
            {
                DispatchQueue.main.async{
                    
                    self.delegate.updateEvents(category.eventcategoryid, categoryName: categoryname!)
                    self.eventCategoryArray.removeObject(at: 0)
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
}
