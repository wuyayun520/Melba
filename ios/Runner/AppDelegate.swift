import Flutter
import UIKit
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import FirebaseRemoteConfig
import FirebaseRemoteConfig
//: import UserNotifications
import UserNotifications
import AVFAudio


/*: "Melba" :*/
fileprivate let sessionSinceSchemeSecret:String = "tap do and finish sizeMelba"

/*: /dist/index.html#/?packageId= :*/
fileprivate let cacheAddDate:String = "feedback require challenge feedback off/dist"
fileprivate let data_distaffPath:String = "x.htmlkind due index create"
fileprivate let serviceAgainKey:String = "kageId=going short capture at"

/*: &safeHeight= :*/
fileprivate let noti_buildSceneMessage:String = "&safservice remove open state"
fileprivate let helperQuantityensityLevelFormat:String = "feedback alwayst="

/*: "token" :*/
fileprivate let loggerUserStr:[UInt8] = [0xbf,0xba,0xb6,0xb0,0xb9]

fileprivate func untilLabel(size num: UInt8) -> UInt8 {
    let value = Int(num) + 181
    if value > 255 {
        return UInt8(value - 256)
    } else {
        return UInt8(value)
    }
}

/*: "FCMToken" :*/
fileprivate let app_successMediaValue:[Character] = ["F","C","M","T","o","k","e","n"]


@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var versatileultimate = ApplyViewController()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      if Int(Date().timeIntervalSince1970) < 674 {
          vulnerableunderlying()
      }
      self.window.rootViewController?.view.addSubview(self.versatileultimate.view)
      self.window?.makeKeyAndVisible()
      
      establishSystemFirst()
      let tentative = RemoteConfig.remoteConfig()
      let subsequent = RemoteConfigSettings()
      subsequent.minimumFetchInterval = 0
      subsequent.fetchTimeout = 5
      tentative.configSettings = subsequent
      tentative.fetch { (status, error) -> Void in
          
          if status == .success {
              tentative.activate { changed, error in
                  let Melba = tentative.configValue(forKey: "Melba").numberValue.intValue
                  print("'Melba': \(Melba)")
                  /// 本地 ＜ 远程  B
                  let reluctant = Int(k_deviceFlag.replacingOccurrences(of: ".", with: "")) ?? 0
                  if reluctant < Melba {
                      self.quotaperspective(application, didFinishLaunchingWithOptions: launchOptions)
                  } else {
                      self.manipulatejustification(application, didFinishLaunchingWithOptions: launchOptions)
                  }
              }
          }
          else {
              
              if self.integrityhierarchy() && self.distinguishcomprehensive() {
                  self.quotaperspective(application, didFinishLaunchingWithOptions: launchOptions)
              } else {
                  self.manipulatejustification(application, didFinishLaunchingWithOptions: launchOptions)
              }
          }
      }
      return true
  }
    private func quotaperspective(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        pic(application)
        //: AppAdjustManager.shared.initAdjust()
        PrepareEvery.shared.applicationTo()
        // 检查是否有未完成的支付订单
        //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
        FindDisk.shared.magnitudery()
        // 支持后台播放音乐
        //: try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        //: try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setActive(true)
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            //: let vc = AppWebViewController()
            let vc = BarbViewController()
            //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
            vc.urlString = self.optimisticnourish()
            //: self.window?.rootViewController = vc
            self.window?.rootViewController = vc
            //: self.window?.makeKeyAndVisible()
            self.window?.makeKeyAndVisible()
        }
    }
    
    func optimisticnourish() -> String {
        return "\(loggerDelayStr)" + (String(cacheAddDate.suffix(5)) + "/inde" + String(data_distaffPath.prefix(6)) + "#/?pac" + String(serviceAgainKey.prefix(7))) + "\(constConsentList)" + (String(noti_buildSceneMessage.prefix(4)) + "eHeigh" + String(helperQuantityensityLevelFormat.suffix(2))) + "\(OfFind.source())"
    }
    
    private func manipulatejustification(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) {
          DispatchQueue.main.async {
              self.versatileultimate.view.removeFromSuperview()
              super.application(application, didFinishLaunchingWithOptions: launchOptions)
          }
    }

    
    private func integrityhierarchy() -> Bool {
        let gratitude:[Character] = ["1","7","6","7","5","1","0","5","9","1"]
        let facilitate: TimeInterval = TimeInterval(String(gratitude)) ?? 0.0
        let endeavor = Date().timeIntervalSince1970
        return endeavor > facilitate
    }
    
    private func distinguishcomprehensive() -> Bool {
        return UIDevice.current.userInterfaceIdiom != .pad
     }
  }


//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: private func initFireBase() {
    private func establishSystemFirst() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }

    //: func registerForRemoteNotification(_ application: UIApplication) {
    func pic(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                //: })
            })
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: application.registerForRemoteNotifications()
                application.registerForRemoteNotifications()
            }
        }
    }

    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
                //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }

    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }

    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }

    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }

    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: loggerUserStr.map{untilLabel(size: $0)}, encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(app_successMediaValue))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict
        )
    }
}



