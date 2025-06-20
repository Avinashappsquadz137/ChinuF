//
//  AppDelegate.swift
//  SanskarEP
//
//  Created by Warln on 10/01/22.
//
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseCore
import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import FirebaseMessaging
import FirebaseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate  {
    var audioPlayer: AVAudioPlayer?
    var window: UIWindow?
    let gcmMessageIDKey = "sanskarEp"
    var fcmString: String = ""
    static private(set) var shared: AppDelegate?
//    var appDel:AppDelegate? = nil

    lazy var operationQueue:OperationQueue = {
         let queue = OperationQueue()
         queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
         queue.name = "ServerInteractionQueue"
         queue.qualityOfService = .background
         return queue
     }()
     
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings.authorizationStatus.rawValue)")
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM Token: \(token)")
                self.fcmString = token
                UserDefaults.standard.set(token, forKey: "token")
                idenity.kDeviceToken = token
            }
        }
        AppFlow()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        
        NetworkMonitor.shared.startMonitoring()
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    //    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs Device Token: \(token)")

        Messaging.messaging().token { fcmToken, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let fcmToken = fcmToken {
                print("FCM Token: \(fcmToken)")
                self.fcmString = fcmToken
                UserDefaults.standard.set(fcmToken, forKey: "token")
                idenity.kDeviceToken = fcmToken
            }
        }
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase registration token received: \(fcmToken)")
        self.fcmString = fcmToken
      //  UserDefaults.standard.set(fcmToken, forKey: "token")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        if let notificationType = userInfo["data"] as? [String: Any],
              let type = notificationType["notification_type"] as? String {
               playNotificationSound(type: type)
           } else {
               playNotificationSound(type: nil)
           }
        if #available(iOS 14.0, *) {
            completionHandler([[.banner,.alert,.sound]])
        } else {
            completionHandler([[.alert,.sound]])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)

        DispatchQueue.main.async {
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController,
               let userInfoDict = userInfo as? [String: Any],
               let notificationData = userInfoDict["data"] as? [String: Any],
               let notificationType = notificationData["notification_type"] as? String {
                
                var viewControllerToPresent: UIViewController?
                
                if notificationType == "8" {
                    let customAlertVC = CustomAlert(nibName: "CustomAlert", bundle: nil)
                    customAlertVC.userInfo = userInfoDict
                    customAlertVC.delegate = customAlertVC as? CustomAlertDelegate
                    viewControllerToPresent = customAlertVC
                    
                } else if notificationType == "9" {
                    let leaveNotificationVC = CustomAlert(nibName: "CustomAlert", bundle: nil)
                    leaveNotificationVC.userInfo = userInfoDict
                    leaveNotificationVC.delegate = notificationType as? CustomAlertDelegate
                    viewControllerToPresent = leaveNotificationVC
                    
                }
//                else if notificationType == "13" {
//                    let leaveNotificationVC = CustomAlert(nibName: "CustomAlert", bundle: nil)
//                    leaveNotificationVC.userInfo = userInfoDict
//                    leaveNotificationVC.delegate = notificationType as? CustomAlertDelegate
//                    viewControllerToPresent = leaveNotificationVC
//                    
//               }
                else if notificationType == "14" {
                    let leaveNotificationVC = LeaveNotificationAlert(nibName: "LeaveNotificationAlert", bundle: nil)
                    leaveNotificationVC.userInfo = userInfoDict
                    leaveNotificationVC.delegate = notificationType as? LeaveRequestDelegate
                    viewControllerToPresent = leaveNotificationVC
                }

                if let viewController = viewControllerToPresent {
                    viewController.modalPresentationStyle = .overFullScreen
                    rootViewController.present(viewController, animated: true)
                }
            }
        }

        completionHandler()
    }


    

    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }

    
    
    //MARK: - App Flow
    func AppFlow() {
        
        if currentUser.EmpCode != "" {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "NewHomeVC") as! NewHomeVC
            AppDelegate.shared?.window?.rootViewController = vc
            AppDelegate.shared?.window?.makeKeyAndVisible()
        }else{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: idenity.login) as! LoginVc
            AppDelegate.shared?.window?.rootViewController = vc
            AppDelegate.shared?.window?.makeKeyAndVisible()
        }
    }

    func playNotificationSound(type: String?) {
        var soundFileName: String

        switch type {
        case "8":
            soundFileName = "bell3"
        case "9":
            soundFileName = "bell3"
        case "14":
            soundFileName = "bell3"
        case "11":
            soundFileName = "bell3"
        default:
            soundFileName = "bell2"
        }

        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else {
            print("Sound file not found!")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

}



