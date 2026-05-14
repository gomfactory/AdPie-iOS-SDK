import UIKit
import AppTrackingTransparency
import AdPieSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestTrackingPermission { [weak self] _ in
            self?.initializeAdPieSDK()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func initializeAdPieSDK() {
        guard AdPieSDK.sharedInstance().isInitialized == false else { return }
        AdPieSDK.sharedInstance().logging()
        AdPieSDK.sharedInstance().initWithMediaId("57342d787174ea39844cac11")
    }
    
    func requestTrackingPermission(completion: @escaping (Bool) -> Void) {
        guard #available(iOS 14, *) else {
            return DispatchQueue.main.async { completion(true) }
        }
        let currentStatus = ATTrackingManager.trackingAuthorizationStatus
        if currentStatus == .authorized {
            return DispatchQueue.main.async { completion(true) }
        } else if currentStatus == .denied || currentStatus == .restricted {
            return DispatchQueue.main.async { completion(false) }
        }
        
        func request() {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async { completion(status == .authorized) }
            }
        }
        if UIApplication.shared.applicationState == .active {
            request()
            return
        }
        var observer: NSObjectProtocol?
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            if let obs = observer {
                NotificationCenter.default.removeObserver(obs)
                observer = nil
                request()
            }
        }
    }
}

