//
//  NativeViewController.swift
//  iosSwiftExampleApp
//
//  Created by StartApp on 12/30/14.
//  Copyright (c) 2014 StartApp. All rights reserved.
//

import UIKit

let kAdCellsInterval = 5

class NativeViewController: UIViewController, STADelegateProtocol, UITableViewDelegate, UITableViewDataSource {

    static let regularCellIdentifier = "RegularCell"
    static let adCellIdentifier = "AdCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    /* Declaration of STAStartAppNativeAd which will load and store all the ads we intend to display */
    lazy var startAppNativeAd = STAStartAppNativeAd()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadAd(_ sender: AnyObject) {
        // Set some preferences
        let pref: STANativeAdPreferences = STANativeAdPreferences()
        pref.adsNumber = 10 // Request 10 ads
        pref.autoBitmapDownload = true // Download image
        pref.bitmapSize = SIZE_100X100

        // Loading the ad
        startAppNativeAd?.load(withDelegate: self, with: pref)
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Delegate method to know when the ad finished loading    
    func didLoad(_ ad: STAAbstractAd!) {
        print("StartApp Native Ad had been loaded successfully", terminator: "")
        tableView.isHidden = false
        tableView.reloadData()
    }

    // StartApp Ad failed to load
    func failedLoad(_ ad: STAAbstractAd, withError error: Error) {
        print("StartApp Native Ad \(ad) had failed to load \(error)")
        showLoadAdFailedAlert()
    }
    
    private func showLoadAdFailedAlert() {
        let alert = UIAlertController(
            title: "Ad is not loaded",
            message: "Native ad hasn't been loaded so we don't need to show the ad",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let amountOfAdsLoaded = startAppNativeAd?.adsDetails.count {
            return amountOfAdsLoaded * kAdCellsInterval
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isAdCell = indexPath.row%kAdCellsInterval == 0;
        let cellIdentifier = (isAdCell) ? NativeViewController.adCellIdentifier : NativeViewController.regularCellIdentifier
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        if isAdCell {
            let adIndex = indexPath.row / kAdCellsInterval
            let adDetails:STANativeAdDetails = startAppNativeAd?.adsDetails[adIndex] as! STANativeAdDetails
            cell?.textLabel?.text = adDetails.title
            cell?.textLabel?.numberOfLines = 2
            cell?.imageView?.image = adDetails.imageBitmap
            
            //Registering cell for automatic impression and click tracking
            adDetails.registerView(forImpressionAndClick: cell)
        }
        else {
            cell?.textLabel?.text = String(format: "Regular cell at row = %d", indexPath.row)
        }
        return cell!
    }
}
