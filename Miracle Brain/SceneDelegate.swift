//
//  SceneDelegate.swift
//  Miracle Brain
//
//  Created by KIBEOM SHIN on 3/10/24.
//

import UIKit
import AppTrackingTransparency
import FirebaseAnalytics
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        for userActivity in connectionOptions.userActivities {
            if let incomingURL = userActivity.webpageURL {
                print("Incoming URL is \(incomingURL)")
                let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                    guard error == nil else{
                        print("Found an error \(error!.localizedDescription)")
                        return
                    }
                    if dynamicLink == dynamicLink {
                        self.handelIncomingDynamicLink(_dynamicLink: dynamicLink!)
                    }
                }
                print("linkHandled: \(linkHandled)")
                break
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            print("url:-   \(url)")
            if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
                self.handelIncomingDynamicLink(_dynamicLink: dynamicLink)
            } else {
                print("False")
            }
            
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                    print("Found an error \(error!.localizedDescription)")
                    return
                }
                if dynamicLink == dynamicLink {
                    self.handelIncomingDynamicLink(_dynamicLink: dynamicLink!)
                }
            }
            print(linkHandled)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //ATT Framework
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status{
                    case .notDetermined:
                        print("notDetermined")
                        Analytics.setAnalyticsCollectionEnabled(false)
                    case .restricted:
                        print("restricted")
                        Analytics.setAnalyticsCollectionEnabled(false)
                    case .denied:
                        print("denied")
                        Analytics.setAnalyticsCollectionEnabled(false)
                    case .authorized:
                        print("authorized")
                        Analytics.setAnalyticsCollectionEnabled(true)
                    @unknown default:
                        print("unknown")
                        Analytics.setAnalyticsCollectionEnabled(false)
                    }
                }
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func handelIncomingDynamicLink(_dynamicLink: DynamicLink) {
        if !_dynamicLink.utmParametersDictionary.isEmpty {
            let utmParams = _dynamicLink.utmParametersDictionary
            Analytics.logEvent(AnalyticsEventCampaignDetails, parameters: utmParams)
            Analytics.logEvent("campaign_test", parameters: utmParams)
            print("match: \(_dynamicLink.matchType)")
            _dynamicLink.matchType
        }
    }
}

