import UIKit
import Flutter

import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)}
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
                   UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
//
//import UIKit
//import Flutter
//import ObjectiveDropboxOfficial
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        GeneratedPluginRegistrant.register(with: self)
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//    
//    override func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//        if let authResult = DBClientsManager.handleRedirectURL(url) {
//            if authResult.isSuccess() {
//                print("dropbox auth success")
//            } else if authResult.isCancel() {
//                print("dropbox auth cancel")
//            } else if authResult.isError() {
//                print("dropbox auth error \(String(describing: authResult.errorDescription))")
//            }
//            return true
//        }
//        return false
//    }
//}
//
