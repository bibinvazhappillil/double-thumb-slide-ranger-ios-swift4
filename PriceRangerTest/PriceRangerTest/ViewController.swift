//
//  ViewController.swift
//  PriceRangerTest
//
//  Created by Qbuser on 14/09/18.
//  Copyright © 2018 Qburst. All rights reserved.
//

import UIKit
import PriceRanger

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var blueView: PriceRanger!
    override func viewDidLoad() {
        super.viewDidLoad()
        blueView.delegate = self as PriceRangerDelegate
        blueView.setLeftThumbImage(as: UIImage(named: "pickerCircle")!)
        blueView.setRightThumbImage(as: UIImage(named: "pickerCircle")!)
        blueView.setupInitialRange(minimum: 0, maximum: 100)
    }
}
extension ViewController: PriceRangerDelegate {
    func priceRanger(currentRange: (Int, Int)) {
        print(currentRange)
    }
}
