//
//  NativeViewController.swift
//  iosSwiftExampleApp
//
//  Created by Nadav on 12/30/14.
//  Copyright (c) 2014 StartApp. All rights reserved.
//

import UIKit

class NativeViewController: UIViewController, STADelegateProtocol {

    /* Declaration of STAStartAppNativeAd which will load and store all the ads we intend to display */
    var startAppNativeAd: STAStartAppNativeAd?

    /* Specific details about each ad */
    var adDetails: STANativeAdDetails?

    @IBOutlet weak var showAdButton: UIButton!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var clickAdButton: UIButton!
    @IBOutlet weak var adTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAppNativeAd = STAStartAppNativeAd()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadAd(sender: AnyObject) {

        // Set some preferences
        var pref: STANativeAdPreferences = STANativeAdPreferences()
        pref.adsNumber = 1 // Request only one ad
        pref.autoBitmapDownload = true // Download image
        pref.bitmapSize = SIZE_150X150

        // Loading the ad
        startAppNativeAd!.loadAdWithDelegate(self, withNativeAdPreferences: pref)
    }
    
    // Delegate method to know when the ad finished loading    
    func didLoadAd(ad: STAAbstractAd!) {
        println("StartApp Native Ad had been loaded successfully")
        showAdButton.hidden = false
        adImageView.hidden = false
    }

    // StartApp Ad failed to load
    func failedLoadAd(ad: STAAbstractAd, withError error: NSError) {
        println("StartApp Native Ad \(ad) had failed to load \(error)")
    }
    
    @IBAction func showAd(sender: AnyObject) {
        // Show the ad only if it has been loaded
        
        if (startAppNativeAd?.isReady() == true) {
            // Take the first ad, which in default can be only one.
            if let adDetailsObject: STANativeAdDetails = startAppNativeAd?.adsDetails.objectAtIndex(0) as? STANativeAdDetails {

                adDetails = adDetailsObject
                
                // Send the impression
                adDetails!.sendImpression()
                
                clickAdButton.hidden = false
                adTitle.text = adDetails!.title
                adTitle.hidden = false
                adImageView.image = adDetails!.imageBitmap
            }
        } else {
            let alertView : UIAlertView = UIAlertView(title: "Ad is not loaded", message: "Native ad hasn't been loaded so we don't need to show the ad", delegate: self, cancelButtonTitle: "OK")
        }
    }
    
    @IBAction func clickAd(sender: AnyObject) {
        adDetails?.sendClick()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
