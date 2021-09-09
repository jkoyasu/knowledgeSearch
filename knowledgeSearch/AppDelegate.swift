//
//  AppDelegate.swift
//  syuttaikinUI
//
//  Created by koyasu on 2021/03/15.
//
import AWSDK
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AWControllerDelegate, UNUserNotificationCenterDelegate {
  
    var oaNumber: String?
    
    var window: UIWindow?
    
    /// 初期起動かどうかのステータスをフラグ
    var initFlg = true
    
    /// LDAP認証に利用するccitパスワード (APIリクエスト処理にて参照)
    var ccitPassword = ""
    /// 起動直後か (連絡先検索画面にて参照、更新)
    var isJustStart = true
    
    var awcontroller = AWController.clientInstance()
    
    /// AirWatch SDK Credential 保持情報の定義
    private enum InfoEntry: String {
        case loading          = "Loading..."
        case enrolled         = "Enrolled: "
        case compliant        = "Compliant: "
        case group            = "Organization Group: "
        case groupID          = "Organization Group ID: "
        case managementType   = "Management Type: "
        case isManaged        = "Is Managed: "
        case username         = "Username: "
        case userOrganization = "User Organization Group: "
        case email            = "Email Address: "
        case fullName         = "Full Name: "
        case domain           = "Domain: "
        case userID           = "User ID: "

        var string: String { return self.rawValue }
    }

    private var deviceInformation = [
        (key: InfoEntry.enrolled,       value: InfoEntry.loading.string),
        (key: InfoEntry.compliant,      value: InfoEntry.loading.string),
        (key: InfoEntry.group,          value: InfoEntry.loading.string),
        (key: InfoEntry.groupID,        value: InfoEntry.loading.string),
        (key: InfoEntry.managementType, value: InfoEntry.loading.string),
        (key: InfoEntry.isManaged,      value: InfoEntry.loading.string)
    ]

    /// AirWatch SDK Credential 保持情報
    private var userInformation = [
        (key: InfoEntry.username,         value: InfoEntry.loading.string),
        (key: InfoEntry.userOrganization, value: InfoEntry.loading.string),
        (key: InfoEntry.username,         value: InfoEntry.loading.string),
        (key: InfoEntry.fullName,         value: InfoEntry.loading.string),
        (key: InfoEntry.domain,           value: InfoEntry.loading.string),
        (key: InfoEntry.userID,           value: InfoEntry.loading.string)
    ]

    func fetchUserInfo() {
        UserInformationController.sharedInstance.retrieveUserInfo { [weak self] (userInformation, error) in

            // OA番号を AirWatch 認証情報から取得
            self?.oaNumber = AWController.clientInstance().account?.username
            
            // 例外ケース1: 認証結果から取得できない場合、 userInformation 情報から取得
            if self?.oaNumber == nil {
                NSLog("userInformation.userName: \(userInformation?.userName as Optional)")
                self?.oaNumber = userInformation?.userName
            }

            guard
                let userInformation = userInformation,
                error == nil
                else {
                    AWLogError("Error fetching information: \(error.debugDescription)")

                    return
            }

            AWLogInfo("user info getted:")
            // Username
            AWLogInfo( "userName:" + userInformation.userName)

            // Group ID
            AWLogInfo( "groupID:" + userInformation.groupID)

            // Email Address
            AWLogInfo( "email:" + userInformation.email)

            // Full Name
            AWLogInfo( "Name:" + userInformation.firstName + " " + userInformation.lastName)

            // Domain
            AWLogInfo( "domain:" + userInformation.domain)

            // User ID
            AWLogInfo( "userIdentifier:" +  userInformation.userIdentifier)
            
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let contentView = ContentView()
        let window = UIWindow()
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
                (granted, _) in
                if granted{
                    UNUserNotificationCenter.current().delegate = self
                }
            }
        
//        // デバッグ出力
//        NSLog("AWController.clientInstance(): controller.account?.username: \(awcontroller.account?.username as Optional)")
        //NSLog("AWController.clientInstance(): controller.account?.password: \(controller.account?.password as Optional)")
        
        awcontroller.callbackScheme = "knowledgeSearch"
        awcontroller.delegate = self
        awcontroller.start()
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handedBySDKController = AWController.clientInstance().handleOpenURL(url, fromApplication: sourceApplication)
        if handedBySDKController  {
            AWLogInfo("Handed over open URL to AWController")
            return true
        }
        return false
    }
    
    // MARK: AWControllerDelegate
    func controllerDidFinishInitialCheck(error: NSError?) {

        if let error = error {
            AWLogError("Application recieved initial check Error: \(error)")
        } else {
            AWLogInfo("Controller did complete initial check.")
        }
        
        fetchUserInfo()
        
    }
    
    func controllerDidReceive(profiles: [Profile]) {
        // This method to designed to provide a profile for application immediately after the controller has recieved
        //
        //
        // Usually, Applications receive Workspace ONE SDK Settings as a Profile.
        // Application will receive a profile updated by admin according to the following rules.
        //  1. When App is being launched for the first time.
        //  2. When Application is being killed and relaunched (cold-boot).
        //  3. After launched from the background and the last profile updated was more than 4 hours ago.
        //
        // In other cases, the cached profile will be returned through this method.
        //
        // Note: First time install and launch of the application requires a profile to be available.
        // Otherwise Workspace ONE SDK's Controller Start process will be halted and will be reported as an error.
        // Generally, this method will be called after `controllerDidFinishInitialCheck(error:)` except in
        // the instance of first time launch of the application.
        //
        AWLogVerbose("Workspace ONE SDK recieved \(profiles.count) profiles.")

        guard profiles.count > 0 else {
            AWLogError("No profile received")
            return
        }

        AWLogInfo("Now printing profiles received: \n")
        profiles.forEach { AWLogInfo("\(String(describing: $0))") }
    }
 
    func controllerDidReceive(enrollmentStatus: AWSDK.EnrollmentStatus) {
        // This optional method will be called when enrollment status si retrieved from Workspace ONE console.
        // You will receive one of the following.
        //      When Device was never enrolled:
        //        `deviceNotFound`:
        //
        //      When device is in process of enrollment:
        //        'discovered'
        //        'registered'
        //        'enrollmentInProgress'
        //
        //      When device is enrolled and compliant:
        //        'enrolled'
        //
        //      When device is unenrolled or detected as non-compliant:
        //        `enterpriseWipePending`
        //        `deviceWipePending`
        //        `retired`
        //        `unenrolled`
        //      When network is not reachable or server sends a status that can not be parsed to one of the above.
        //         `unknown`
        AWLogInfo("Current Enrollment Status: \(String(describing: enrollmentStatus))")
    }

    func controllerDidWipeCurrentUserData() {
        // Please check for this method to handle cases when this device was unenrolled, or user tried to unlock with more than allowed attempts,
        // or other cases of compromised device detection etc. You may recieve this callback at anytime during the app run.
        AWLogError("Application should wipe all secure data")
    }

    func controllerDidLockDataAccess() {
        // This optional method will give opportunity to prepare for showing lock screen and thus saving any sensitive data
        // before showing lock screen. This method requires your admin to set up authentication type as either passcode or
        // username/password.
        AWLogInfo("Controller did lock data access.")
    }

    func controllerWillPromptForPasscode() {
        // This optional method will be called right before showing unlock screen. It is intended to take care of any UI related changes
        // before Workspace ONE SDK's Controller will present its screens. This method requires your admin to set up authentication type as either passcode or
        // username/password.
        AWLogInfo("Controller did lock data access.")
    }

    func controllerDidUnlockDataAccess() {
        // This method will be called once user enters right passcode or username/password on lock screen.
        // This method requires your admin to set up authentication type as either passcode or
        // username/password.
        AWLogInfo("User successfully unlocked")
    }

    func applicationShouldStopNetworkActivity(reason: AWSDK.NetworkActivityStatus) {
        // This method gets called when your admin restricts offline access but detected that the network is offline.
        // This method will also be called when admin whitelists specific SSIDs that this device should be connected while using this
        // application and user is connected to different/non-whitelisted WiFi network.
        //
        // Application should look this callback and stop making any network calls until recovered. Look for `applicationCanResumeNetworkActivity`.
        AWLogError("Workspace ONE SDK Detected that device violated network access policy set by the admin. reason: \(String(describing: reason))")
    }

    func applicationCanResumeNetworkActivity() {
        // This method will be called when device recovered from restrictions set by admin regarding network access.
        AWLogInfo("Application can resume network activity.")
    }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
}

