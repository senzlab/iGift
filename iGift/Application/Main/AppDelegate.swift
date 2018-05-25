//
//  AppDelegate.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/8/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: NavigationViewController!
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self

        // Load Navigation View Controller to stack other viewcontroallers
        window = UIWindow.init(frame: UIScreen.main.bounds)
        navController = NavigationViewController()

        // Setup Global Styles for NavBar
        setupNavBarStyles(navController.navigationBar)

        // Setup Global Styles for StatusBar
        setupStatusBarStyles()

        // Add Nav Controller into root
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            //Parse errors and track state
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }

    func setupNavBarStyles(_ navigationBar: UINavigationBar) {
        // Set Background color to nav bar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.fromHex(HexColors.PRIMARY_COLOR.rawValue)

        // Set font and size on elements in nav bar
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: Constants.MAIN_FONT_FAMILY.rawValue, size: 25)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBarAppearace.tintColor = UIColor.white
    }

    func setupStatusBarStyles() {
        // Make stutus bar content white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iGift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //    MARK: Push notifications related functions
    //    Reference : https://www.appcoda.com/push-notification-ios/
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print((#file as NSString).lastPathComponent, " # deviceToken = ", deviceTokenString)
        PreferenceUtil.instance.put(key: PreferenceUtil.DEVICE_ID, value: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print((#file as NSString).lastPathComponent, " # Reason to fail register remote notification : ", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print((#file as NSString).lastPathComponent, " # userInfo = ", userInfo)

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let senz = userInfo["gcm.notification.senz"] as? NSString {
            print((#file as NSString).lastPathComponent, " # senzConnect = ", senz)
            
            let z = SenzUtil.instance.parse(msg: senz as String)
            if (z.attr["#amnt"] != nil) {
                // this means new iGift
                let senzGift = Igift(id: 1)
                senzGift.uid = z.attr["#uid"]!
                senzGift.user = z.attr["#from"]!
                senzGift.amount = z.attr["#amnt"]!
                senzGift.cid = z.attr["#id"]!
                senzGift.state = "TRANSFER"
                senzGift.timestamp = TimeUtil.sharedInstance.timestamp()
                senzGift.isMyIgift = false
                senzGift.isViewed = false
                _ = SenzDb.instance.createIgift(igift: senzGift)
                
                let igiftsReceivedViewController = IGiftsReceivedViewController(nibName: "IGiftsReceivedViewController", bundle: nil)
                navController.pushViewController(igiftsReceivedViewController, animated: true)
            } else {
                // this means new request
                let z = SenzUtil.instance.parse(msg: senz as String)
                let phoneNumber:String = z.attr["#from"]!
                
                if (SenzDb.instance.getUser(phn: phoneNumber) != nil) {
                    // activate user
                    _ = SenzDb.instance.markAsActive(id: phoneNumber)
                } else {
                    // create user
                    let senzUser = User(id: 1)
                    senzUser.zid = phoneNumber
                    senzUser.phone = phoneNumber
                    _ = SenzDb.instance.createUser(user: senzUser)
                }
                
                let contactsViewController = ContactsViewController(nibName: "ContactsViewController", bundle: nil)
                navController.pushViewController(contactsViewController, animated: true)
            }
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 1: \(messageID)")
        }
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 2: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        PreferenceUtil.instance.put(key: PreferenceUtil.FCM_TOKEN, value: fcmToken)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

