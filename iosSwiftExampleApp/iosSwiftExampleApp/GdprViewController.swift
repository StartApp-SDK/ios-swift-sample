//
//  GdprViewController.swift
//  iosSwiftExampleApp
//
//  Created by tto on 11/2/18.
//  Copyright © 2018 StartApp. All rights reserved.
//

import UIKit

class GdprViewController: UIViewController {
    
    var completionHandler: ((Bool) -> Void)?
    
    @IBAction func onOkPressed() {
        completionHandler?(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelPressed() {
        completionHandler?(false)
        dismiss(animated: true, completion: nil)
    }
}
