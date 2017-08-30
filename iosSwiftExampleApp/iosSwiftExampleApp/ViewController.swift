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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAppAdAutoLoad!.load()
        
        /*
        load the StartApp auto position banner, banner size will be assigned automatically by  StartApp
        NOTE: replace the ApplicationID and the PublisherID with your own IDs
        */
        
        if (startAppBannerAuto == nil) {
            startAppBannerAuto = STABannerView(size: STA_AutoAdSize, autoOrigin: STAAdOrigin_Bottom, with: self.view, withDelegate: nil);
            self.view.addSubview(startAppBannerAuto!)
        }
        
        /*
        load the StartApp fixed position banner - in (0, 200)
        NOTE: replace the ApplicationID and the PublisherID with your own IDs
        */
        
        if (startAppBannerFixed == nil) {
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                startAppBannerFixed = STABannerView(size: STA_PortraitAdSize_768x90, origin: CGPoint(x: 0,y: 300), with: self.view, withDelegate: nil)
            } else {
                startAppBannerFixed = STABannerView(size: STA_PortraitAdSize_320x50, origin: CGPoint(x: 0,y: 200), with: self.view, withDelegate: nil)
            }

            self.view.addSubview(startAppBannerFixed!)
        }
 
    }

    // Rotating the banner for iOS less than 8.0
    override func  didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)  {
        // notify StartApp auto Banner orientation change
        startAppBannerAuto!.didRotate(from: fromInterfaceOrientation)
        
        // notify StartApp fixed position Banner orientation change
        startAppBannerFixed!.didRotate(from: fromInterfaceOrientation)
        
        super.didRotate(from: fromInterfaceOrientation)
    }
    
    @IBAction func showAd() {
        /*
        displaying StartApp ad.
        NOTE:  Since the loadAd method is async,
        it is possible that when calling the showAd method the
        ad hasn't been loaded yet.
        You can verify that by using the isReady method.
        */
        startAppAdAutoLoad!.show()
    }
    
    @IBAction func loadShowAd() {
        // load StartApp ad with Automatic AdType and self view controller
        // as a delegation for callbacks
        startAppAdLoadShow!.load(withDelegate: self);
    }
    
    /*
    Implementation of the STADelegationProtocol.
    All methods here are optional and you can
    implement only the ones you need.
    */
    
    // StartApp Ad loaded successfully
    func didLoad(_ ad: STAAbstractAd) {
        print("StartApp Ad had been loaded successfully", terminator: "")
        startAppAdLoadShow!.show()
    }
    
    // StartApp Ad failed to load
    func failedLoad(_ ad: STAAbstractAd, withError error: Error) {
        print("StartApp Ad had failed to load", terminator: "")
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
}

