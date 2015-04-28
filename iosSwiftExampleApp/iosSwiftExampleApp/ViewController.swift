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
    var startAppAdAutoLoad: STAStartAppAd?
    
    /*
    Declaration of STAStartAppAd which later on will be used
    for loading when user clicks on a button and showing the
    loaded ad when the ad was loaded with delegation
    */
    var startAppAdLoadShow: STAStartAppAd?

    /*
    Declaration of StartApp Banner view with automatic positioning
    */
    var startAppBannerAuto: STABannerView?
    
    /*
    Declaration of StartApp Banner view with fixed positioning and size
    */
    var startAppBannerFixed: STABannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        Init of the startapp interstitials
        NOTE: replace the ApplicationID and the PublisherID with your own IDs
        */
        startAppAdAutoLoad = STAStartAppAd()
        startAppAdLoadShow = STAStartAppAd()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startAppAdAutoLoad!.loadAd()
        
        /*
        load the StartApp auto position banner, banner size will be assigned automatically by  StartApp
        NOTE: replace the ApplicationID and the PublisherID with your own IDs
        */
        if (startAppBannerAuto == nil) {
            startAppBannerAuto = STABannerView(size: STA_AutoAdSize, autoOrigin: STAAdOrigin_Bottom, withView: self.view, withDelegate: nil);
            self.view.addSubview(startAppBannerAuto!)
        }
        
        /*
        load the StartApp fixed position banner - in (0, 200)
        NOTE: replace the ApplicationID and the PublisherID with your own IDs
        */
        if (startAppBannerFixed == nil) {
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                startAppBannerFixed = STABannerView(size: STA_PortraitAdSize_768x90, origin: CGPointMake(0,300), withView: self.view, withDelegate: nil)
            } else {
                startAppBannerFixed = STABannerView(size: STA_PortraitAdSize_320x50, origin: CGPointMake(0,200), withView: self.view, withDelegate: nil)
            }

            self.view.addSubview(startAppBannerFixed!)
        }
    }

    // Rotating the banner for iOS less than 8.0
    override func  didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)  {
        // notify StartApp auto Banner orientation change
        startAppBannerAuto!.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        
        // notify StartApp fixed position Banner orientation change
        startAppBannerFixed!.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
    }
    
    @IBAction func showAd() {
        /*
        displaying StartApp ad.
        NOTE:  Since the loadAd method is async,
        it is possible that when calling the showAd method the
        ad hasn't been loaded yet.
        You can verify that by using the isReady method.
        */
        startAppAdAutoLoad!.showAd()
    }
    
    @IBAction func loadShowAd() {
        // load StartApp ad with Automatic AdType and self view controller
        // as a delegation for callbacks
        startAppAdLoadShow!.loadAdWithDelegate(self);
    }
    
    /*
    Implementation of the STADelegationProtocol.
    All methods here are optional and you can
    implement only the ones you need.
    */
    
    // StartApp Ad loaded successfully
    func didLoadAd(ad: STAAbstractAd) {
        println("StartApp Ad had been loaded successfully")
        startAppAdLoadShow!.showAd()
    }
    
    // StartApp Ad failed to load
    func failedLoadAd(ad: STAAbstractAd, withError error: NSError) {
        println("StartApp Ad had failed to load")
    }
    
    // StartApp Ad is being displayed
    func didShowAd(ad: STAAbstractAd) {
        println("StartApp Ad is being displayed")
    }
    
    // StartApp Ad failed to display
    func failedShowAd(ad: STAAbstractAd, withError error: NSError) {
        println("StartApp Ad is failed to display")
    }
    
    // StartApp Ad is being displayed
    func didCloseAd(ad: STAAbstractAd) {
        println("StartApp Ad was closed")
    }
    
    // StartApp Ad is being displayed
    func didClickAd(ad: STAAbstractAd) {
        println("StartApp Ad was clicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

