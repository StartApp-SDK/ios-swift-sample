//
//  ViewController.swift
//  iosSwiftExampleApp
//
//  Created by StartApp on 6/5/14.
//  Copyright (c) 2014 StartApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, STADelegateProtocol {
    
    /*
    Declaration of STAStartAppAd which later on will be used
    for loading within the viewDidApear and displaying when
    clicking a button
    */
    lazy var startAppAdAutoLoad = STAStartAppAd()
    
    /*
    Declaration of STAStartAppAd which later on will be used
    for loading when user clicks on a button and showing the
    loaded ad when the ad was loaded with delegation
    */
    lazy var startAppAdLoadShow = STAStartAppAd()

    /*
    Declaration of StartApp Banner view with automatic positioning
    */
    var startAppBannerBottom: STABannerView?
    
    /*
    Declaration of StartApp Banner view with fixed positioning and size
    */
    var startAppBannerFixed: STABannerView?
    
    /*
     Declaration of StartApp Rewarded ad
     */
    lazy var startAppRewarded = STAStartAppAd()
    
    /*
     Initialize StartApp SDK with your appId
     */
    private func initStartAppSDK() {
        // initialize the SDK with your appID and devID
        guard let sdk = STAStartAppSDK.sharedInstance() else {
            fatalError("StartAppSDK initialization failed!")
        }
        
        if sdk.appID != nil {
            // The sdk has already been initialized
            return
        }
        
        sdk.appID = "yourAppId"
        sdk.devID = "yourDeveloperId"
        sdk.preferences = STASDKPreferences.prefrences(withAge: 22, andGender: STAGender_Male)
        
        /*
         load the StartApp auto interstitial ad
         */
        startAppAdAutoLoad?.load()
        
        /*
         load the StartApp auto position banner, banner size will be assigned automatically by  StartApp
         */
        if (startAppBannerBottom == nil) {
            startAppBannerBottom = STABannerView(
                size: STA_AutoAdSize,
                autoOrigin: STAAdOrigin_Bottom,
                with: bottomContainerView,
                withDelegate: nil);
            
            bottomContainerView.addSubview(startAppBannerBottom!)
        }
        
        /*
         load the StartApp fixed position banner - in (0, 200)
         */
        if (startAppBannerFixed == nil) {
            let halfX = 0.5 * (view.bounds.width - 320)
            
            startAppBannerFixed = STABannerView(
                size: STA_PortraitAdSize_320x50,
                origin: CGPoint(x: halfX, y: 200),
                with: view, withDelegate: nil)
            
            view.addSubview(startAppBannerFixed!)
        }
    }
    
    /*
     Also we recomend to show a splash screen ad in your app
     */
    private func showSplashAd() {
        guard let sdk = STAStartAppSDK.sharedInstance() else {
            fatalError("StartAppSDK initialization failed!")
        }
        
        let splashPreferences : STASplashPreferences = STASplashPreferences()
        splashPreferences.splashMode = STASplashModeTemplate
        splashPreferences.splashTemplateTheme = STASplashTemplateThemeOcean;
        splashPreferences.splashLoadingIndicatorType = STASplashLoadingIndicatorTypeDots;
        splashPreferences.splashTemplateIconImageName = "StartAppIcon";
        splashPreferences.splashTemplateAppName = "StartApp Example App";
        
        sdk.showSplashAd(with: splashPreferences)
    }
    
    private func writePersonalizedAdsConsent(isGranted: Bool) {
        guard let sdk = STAStartAppSDK.sharedInstance() else {
            fatalError("StartAppSDK initialization failed!")
        }
        
        sdk.setUserConsent(isGranted, forConsentType: "pas", withTimestamp: Int(Date().timeIntervalSince1970))
        UserDefaults.standard.set(true, forKey: "gdpr_dialog_was_shown")
    }
    
    private func initStartAppSdkIfGdprShown() {
        if !UserDefaults.standard.bool(forKey: "gdpr_dialog_was_shown") {
            return
        }
        
        initStartAppSDK()
        showSplashAd()
    }
    
    private func initStartAppSdkIfGdprNotShown() {
        if UserDefaults.standard.bool(forKey: "gdpr_dialog_was_shown") {
            return
        }
        
        performSegue(withIdentifier: "showGdprSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dstController = segue.destination as? GdprViewController {
            dstController.completionHandler = {
                self.initStartAppSDK()
                self.writePersonalizedAdsConsent(isGranted: $0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFixedBannerSize.setTitle(
            (UIDevice.current.userInterfaceIdiom == .pad) ? "768x90" : "320x50",
            for: UIControl.State.normal)
        
        initStartAppSdkIfGdprShown()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initStartAppSdkIfGdprNotShown()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        // notify StartApp auto Banner orientation change
        startAppBannerBottom?.viewWillTransition(to: size, with: coordinator)
        // notify StartApp fixed position Banner orientation change
        startAppBannerFixed?.viewWillTransition(to: size, with: coordinator)
    }

    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var btnFixedBannerSize: UIButton!
    
    @IBAction func showAd() {
        /*
        displaying StartApp ad.
        NOTE:  Since the loadAd method is async,
        it is possible that when calling the showAd method the
        ad hasn't been loaded yet.
        You can verify that by using the isReady method.
        */
        startAppAdAutoLoad?.show()
    }
    
    @IBAction func loadShowAd() {
        // load StartApp ad with Automatic AdType and self view controller
        // as a delegation for callbacks
        startAppAdLoadShow?.load(withDelegate: self);
    }
    
    @IBAction func loadShowRewardedVideo() {
        // load StartApp rewarded video
        startAppRewarded?.loadRewardedVideoAd(withDelegate: self);
    }
    
    @IBAction func autoBannerSizeButtonTap(_ sender: Any) {
        startAppBannerBottom?.setSTABannerSize(STA_AutoAdSize);
    }
    
    @IBAction func fixedBannerSizeButtonTap(_ sender: Any) {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            startAppBannerBottom?.setSTABannerSize(STA_PortraitAdSize_768x90);
        } else {
            startAppBannerBottom?.setSTABannerSize(STA_PortraitAdSize_320x50);
        }
    }
    
    @IBAction func mRecBannerSizeButtonTap(_ sender: Any) {
        startAppBannerBottom?.setSTABannerSize(STA_MRecAdSize_300x250);
    }
    
    @IBAction func coverBannerSizeButtonTap(_ sender: Any) {
        startAppBannerBottom?.setSTABannerSize(STA_CoverAdSize);
    }
    /*
    Implementation of the STADelegationProtocol.
    All methods here are optional and you can
    implement only the ones you need.
    */
    
    // StartApp Ad loaded successfully
    func didLoad(_ ad: STAAbstractAd) {
        print("StartApp Ad had been loaded successfully", terminator: "")
        
        if (ad == startAppAdLoadShow) {
            startAppAdLoadShow?.show()
        } else if (ad == startAppRewarded) {
            startAppRewarded?.show()
        }
    }
    
    // StartApp Ad failed to load
    func failedLoad(_ ad: STAAbstractAd, withError error: Error) {
        if (ad == startAppAdLoadShow) {
            print("StartApp Ad had failed to load", terminator: "")
        } else if (ad == startAppRewarded) {
            print("StartApp rewarded video failed to load", terminator: "")
        }
    }
    
    // StartApp Ad is being displayed
    func didShow(_ ad: STAAbstractAd) {
        print("StartApp Ad is being displayed", terminator: "")
    }
    
    // StartApp Ad failed to display
    func failedShow(_ ad: STAAbstractAd, withError error: Error) {
        print("StartApp Ad is failed to display", terminator: "")
    }
    
    // StartApp Ad is being displayed
    func didClose(_ ad: STAAbstractAd) {
        print("StartApp Ad was closed", terminator: "")
    }
    
    // StartApp Ad is being displayed
    func didClick(_ ad: STAAbstractAd) {
        print("StartApp Ad was clicked", terminator: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // StartApp playing rewarded video has been completed
    func didCompleteVideo(_ ad: STAAbstractAd) {
        print("StartApp rewarded video had been completed", terminator: "")
    }
}

