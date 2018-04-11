//
//  AppDelegate.swift
//  Town of Morrisville
//
//  Created by chipsy services on 27/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import EventKit
import Foundation
import SystemConfiguration
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate,GGLInstanceIDDelegate, GCMReceiverDelegate
{
    var facebookCount:Int = 0
    var twitterCount:Int = 0
    
    var fblink:String!
    var twitterlink:String!
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    var accordionVC:AccordionViewController!
    var openNews:Bool! = false
    var eventreminddict:NSMutableDictionary! = [:]
    var window: UIWindow?
    var mainUrlString:String! = "https://apimconnect.ideationwizard.com"
    var YouTubeArrayCountHome: Int?
    var YouTubeArrayLinkHome:String?
    var SelectedOption:String? = ""
    var eventidarray:NSMutableArray! = NSMutableArray()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        //self.eventidarray = NSUserDefaults.standardUserDefaults().valueForKey("eventidarray") as! NSMutableArray
        //registerForPushNotifications(application)
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        self.accordionVC = AccordionViewController()
        if let data = UserDefaults.standard.object(forKey: "eventremindedict")
        {
            let object = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! NSMutableDictionary
            if object.count > 0
            {
                eventreminddict = object
            }
        }
        // Register for remote notifications
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            //FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        application.registerForRemoteNotifications()
        
        Fabric.with([Twitter.self])
        // Check if launched from notification
        // 1
        if (launchOptions != nil){
            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? [String:AnyObject]{
                
                //handle your notification here
                let _ = userInfo
                self.openNews = true
            }
        }
        let gcmConfig = GCMConfig.default()
        gcmConfig?.receiverDelegate = self
        GCMService.sharedInstance().start(with: gcmConfig)
        return true
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
    {
        if notificationSettings.types != UIUserNotificationType()
        {
            application.registerForRemoteNotifications()
        }
    }
    func registerForPushNotifications(_ application: UIApplication)
    {
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = "VIEW_IDENTIFIER"
        viewAction.title = "View"
        viewAction.activationMode = .foreground
        
        let newsCategory = UIMutableUserNotificationCategory()
        newsCategory.identifier = "NEWS_CATEGORY"
        newsCategory.setActions([viewAction], for: .default)
        
        let categories: Set<UIUserNotificationCategory> = [newsCategory]
        
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: categories)
        application.registerUserNotificationSettings(notificationSettings)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /*
         let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
         var tokenString = ""
         
         for i in 0..<deviceToken.length
         {
         tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
         }
         print("Device Token:", tokenString)
         */
        // [END receive_apns_token]
        // [START get_gcm_reg_token]
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,kGGLInstanceIDAPNSServerTypeSandboxOption:false as AnyObject]
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        // [END get_gcm_reg_token]
        
        
    }
    func registrationHandler(_ registrationToken: String?, error: Error?) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            //print("Registration Token: \(registrationToken)")
            
            let userInfo = ["registrationToken": registrationToken]
            let url:URL = URL(string: "https://apimconnect.ideationwizard.com/adddeviceid")!
            //let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let UUID = UIDevice.current.identifierForVendor?.uuidString
            let paramString = NSString(format: "app_id=%@&device_id=%@&device_type=IOS",self.registrationToken!,UUID!)
            request.httpBody = paramString.data(using: String.Encoding.utf8.rawValue)
            URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                
                guard let _:Data = data, let _:URLResponse = response  , error == nil else
                {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                //print(dataString!)
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let data_dictionary = json as? NSDictionary else
                    {
                        return
                    }
                    if let responseInfoCode = data_dictionary["status"] as? NSDictionary
                    {
                        _ = responseInfoCode["code"] as? Int
                        let message = responseInfoCode["message"] as? String
                        let _ = message
                        DispatchQueue.main.async {
                        }
                    }
                    
                }
                catch
                {
                    print("Error with Json: \(error)")
                }
                }.resume()
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        } else {
           // print("Registration to GCM failed with error: \(error?.localizedDescription)")
            let userInfo = ["error": error?.localizedDescription]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        }
    }
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        // Handle the received message
        // [START_EXCLUDE]
        let state = application.applicationState
        if (state == .inactive || state == .background) {
            // go to screen relevant to Notification content
        } else {
            // App is in UIApplicationStateActive (running in foreground)
            // perhaps show an UIAlertView
            let notifiAlert = UIAlertView()
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let message = alert["title"] as? NSString {
                        //Do stuff
                        notifiAlert.message = message as String
                    }
                    if let title = alert["title"] as? NSString {
                        //Do stuff
                        _ = title
                        notifiAlert.title = "News Update"
                    }
                } //else if let alert = aps["alert"] as? NSString {
                //Do stuff
                //}
            }
            //notifiAlert.title = "TITLE"
            //notifiAlert.message = NotificationMessage as? String
            notifiAlert.addButton(withTitle: "OK")
            
            notifiAlert.show()
        }
        //NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
        //                                                          userInfo: userInfo)
        // [END_EXCLUDE]
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register:", error)
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    // Check the current app version, if it's not equal to the current version. Display update alert.
    func checkVersion() {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleVersion"] as AnyObject?
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let buildversion = nsObject as! String
        let urlString = String(format: "https://apimconnect.ideationwizard.com/iosversion/%@",buildversion)
        let url = URL(string: urlString)
        
        // let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
            do{
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                guard let data_dictionary = json as? NSDictionary else
                {
                    return
                }
                
                
                if let responseInfo = data_dictionary["status"] as? NSDictionary{
                    let responseCode = responseInfo["code"] as! Int
                    
                    
                    if responseCode == 1{
                        DispatchQueue.main.async{
                            let alert:UIAlertView = UIAlertView(title: "Update Available", message: "An update of mConnect is available in Appstore. You need to update mConnect before you can use it", delegate:self, cancelButtonTitle: nil, otherButtonTitles: "OK")
                            alert.tag = 1001
                            alert.show()
                        }
                        print("Force Update");
                    }
                    else if responseCode == 2{
                        
                        DispatchQueue.main.async{
                            let alert:UIAlertView = UIAlertView(title: "Update Available", message: "An update of mConnect is available in Appstore. Do you want to update.", delegate:self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                            alert.tag = 1002
                            alert.show()
                        }
                        print("Update Available");
                    }
                    
                }
                
            }catch {
                print("Error with Json: \(error)")
            }
            
            }.resume()
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if alertView.tag == 1002{
            switch(buttonIndex)
            {
            case 0:
                break
            case 1:
                let url = URL(string: "https://itunes.apple.com/in/app/mconnect/id1150951416?mt=8")
                UIApplication.shared.openURL(url!)
                break
            default:
                break
            }
        }
        else if alertView.tag == 1001{
            let url = URL(string: "https://itunes.apple.com/in/app/mconnect/id1150951416?mt=8")
            UIApplication.shared.openURL(url!)
        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        GCMService.sharedInstance().connect { (error:Error?) in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                
                // [END_EXCLUDE]
            }
        }
        /*
        GCMService.sharedInstance().connect(handler: {(error:NSError?) -> Void in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                
                // [END_EXCLUDE]
            }
        })*/
        self.checkVersion()
        if let data = UserDefaults.standard.object(forKey: "eventremindedict")
        {
            let object = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! NSMutableDictionary
            if object.count > 0
            {
                eventreminddict = object
            }
        }
        let reminddict = eventreminddict
        for (key, value) in reminddict! {
            let eventStore = EKEventStore()
            let val = value
            if let existingEvent = eventStore.event(withIdentifier: val as! String)
            {
                _ = existingEvent
                //self.remindLabel.text = "delete"
                //let val = reminddict[eventid]
                //self.savedEventId = existingEvent.eventIdentifier
            }
            else
            {
                eventreminddict.removeObject(forKey: key)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "changereminderLabel"), object: self, userInfo: nil)
                //self.remindLabel.text = "remind me"
                
            }
            //[eventStore eventWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:self.showId]];
            
            // the key exists in the dictionary
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }
    
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.openNews = true
    }
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        // Handle the received message
        // [START_EXCLUDE]
        let state = UIApplication.shared.applicationState
        if (state == .inactive || state == .background) {
            // go to screen relevant to Notification content
        } else {
            // App is in UIApplicationStateActive (running in foreground)
            // perhaps show an UIAlertView
            let notifiAlert = UIAlertView()
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    if let message = alert["title"] as? NSString {
                        //Do stuff
                        notifiAlert.message = message as String
                    }
                    if let title = alert["title"] as? NSString {
                        //Do stuff
                        _ = title
                        notifiAlert.title = "News Update"
                    }
                } //else if let alert = aps["alert"] as? NSString {
                //Do stuff
                //}
            }
            //notifiAlert.title = "TITLE"
            //notifiAlert.message = NotificationMessage as? String
            notifiAlert.addButton(withTitle: "OK")
            
            notifiAlert.show()
        }
        //return
    }
    
    
}
