//
//  SanskarEPUIApp.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//

import SwiftUI
import UserNotifications
import AVFoundation

@main
struct SanskarEPUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var notificationHandler = NotificationHandler.shared
    init() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .navigationViewStyle(StackNavigationViewStyle())
                .environment(\.colorScheme, .light)
                .environmentObject(notificationHandler) 
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    var audioPlayer: AVAudioPlayer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaultsManager.setSavedDeviceModel(deviceModel)
          
            print("📱 Device model saved: \(UserDefaultsManager.getSavedDeviceModel())")

        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("✅ APNs permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("❌ APNs permission denied.")
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 APNs Device Token: \(token)")
        UserDefaultsManager.setFCMToken(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        print("📦 Background notification received: \(userInfo)")
        return .newData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("📩 Foreground Notification Data: \(userInfo)")
        if let notificationType = userInfo["data"] as? [String: Any],
           let type = notificationType["notification_type"] as? String {
            playNotificationSound(type: type)
        } else {
            playNotificationSound(type: nil)
        }
        return [.alert, .sound, .badge]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("📩 User tapped notification: \(userInfo)")

        if let userInfoDict = userInfo as? [String: Any],
           let notificationData = userInfoDict["data"] as? [String: Any] {
            DispatchQueue.main.async {
                NotificationHandler.shared.handleNotification(data: notificationData)
            }
        }
    }


    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.yourapp.dontremove" {
            print("User tapped Don't Remove!")
        } else if shortcutItem.type == "com.yourapp.bugreport" {
            print("User tapped Bug Report!")
        }
    }

    func playNotificationSound(type: String?) {
        var soundFileName: String

        switch type {
        case "8", "9", "14", "11":
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
                 


struct SplashView: View {
    @EnvironmentObject var notificationHandler: NotificationHandler
    let isLoggedIn = UserDefaultsManager.isLoggedIn()
    @State private var isActive = false
    var body: some View {
        NavigationStack {
            ZStack {
                if isActive {
                    if isLoggedIn {
                        MainHomeView()
                            .overlay(ToastView())
                            .navigationViewStyle(StackNavigationViewStyle())
                            .environment(\.colorScheme, .light)
                            .navigationDestination(isPresented: $notificationHandler.navigateToNotificationScreen) {
                                NotificationHistoryListView()
                                    .environmentObject(notificationHandler)
                            }
                    } else {
                        MainLoginView()
                            .navigationViewStyle(StackNavigationViewStyle())
                            .environment(\.colorScheme, .light)
                    }
                } else {
                    ZStack {
                        Image("signBackground")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        Image("chinuF_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    .onAppear {
                        notificationHandler.showGuestPopup = false
                        notificationHandler.selectedPushData = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
                }
            }
        }
    }
}
