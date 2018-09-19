//
//  PriceRanger.swift
//  PriceRanger
//
//  Created by Qbuser on 14/09/18.
//  Copyright © 2018 Qburst. All rights reserved.
//

import UIKit
public protocol PriceRangerDelegate {
    func priceRanger(currentRange: (Int, Int))
}
public class PriceRanger: UIView {
    let nibName = "PriceRanger"
    var contentView: UIView!
    let minimumDistance: CGFloat = 20
    let minimumDistanceBetweenButtons: CGFloat = 35
    
    var minimumRangeValue: CGFloat = 0
    var maximumRangeValue: CGFloat = 1000
    
    var leftEnd: CGFloat = 0
    var rightEnd: CGFloat = 0
    
    var factor : CGFloat = 0
    
    //current thumps value
    var currentLeftLabelValue: Int = 0
    var currentRightLabelValue: Int = 0
    public var delegate: PriceRangerDelegate?
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var rightPriceLabel: UILabel!
    @IBOutlet weak var leftPriceLabel: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupPriceRangerUI()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPriceRangerUI()
    }
    func setBlueViewFrame() {
        blueView.frame = CGRect(x: leftButton.center.x, y: leftButton.center.y, width: rightButton.center.x - leftButton.center.x, height: 2)
    }
    public override func awakeFromNib() {

    }
    
    public func setupInitialRange(minimum: CGFloat, maximum: CGFloat){
        self.minimumRangeValue = minimum
        self.maximumRangeValue = maximum
        factor = maximumRangeValue / (rightEnd - leftEnd)
        leftPriceLabel.text = "\(Int(minimum))"
        rightPriceLabel.text = "\(Int(maximum))"
    }
    
    //MARK:- RIGHT thumb handler
    @IBAction func didTouchedRightThumb(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: contentView)
        let buttonView = sender.view!
        switch sender.state {
        case .began, .changed:
            if rightButton.center.x >= UIScreen.main.bounds.size.width - minimumDistance {
                if translation.x > 0 {
                    break
                }
            }
            if leftButton.center.x + minimumDistanceBetweenButtons >= rightButton.center.x {
                if translation.x < 0 {
                    break
                }
            }
            buttonView.center = CGPoint(x: buttonView.center.x + translation.x, y: buttonView.center.y)
            sender.setTranslation(CGPoint.zero, in: contentView)
            currentRightLabelValue = Int((rightButton.center.x - leftEnd) * factor)
            self.setBlueViewFrame()
            if currentRightLabelValue <= Int(maximumRangeValue) {
                DispatchQueue.main.async {
                    self.rightPriceLabel.text = "\(self.currentRightLabelValue) ₹"
                }
            }
            delegate?.priceRanger(currentRange: (currentLeftLabelValue, currentRightLabelValue))
            break
        default:
            break
        }
    }
    //MARK:- LEFT thumb handler
    @IBAction func didTouchedLeftThumb(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: contentView)
        let buttonView = sender.view!
        switch sender.state {
        case .began, .changed:
            if leftButton.center.x <= minimumDistance {
                if translation.x < 0 {
                    break
                }
            }
            if leftButton.center.x + minimumDistanceBetweenButtons >= rightButton.center.x {
                if translation.x > 0 {
                    break
                }
            }
            currentLeftLabelValue = Int(((self.leftButton.center.x - self.leftEnd) / (self.rightEnd - self.leftEnd)) * self.maximumRangeValue)
            
            
            if currentLeftLabelValue >= Int(minimumRangeValue) {
                DispatchQueue.main.async {
                    self.setBlueViewFrame()
                    self.leftPriceLabel.text = "\(self.currentLeftLabelValue) ₹"
                }
            }
            delegate?.priceRanger(currentRange: (currentLeftLabelValue,currentRightLabelValue))
            buttonView.center = CGPoint(x: buttonView.center.x + translation.x, y: buttonView.center.y)
            sender.setTranslation(CGPoint.zero, in: contentView)
            break
        default:
            break
        }
    }
    public func setLeftThumbImage(as bgImage: UIImage) {
        leftButton.setTitle("", for: .normal)
        leftButton.setBackgroundImage(bgImage, for: .normal)
    }
    public func setRightThumbImage(as bgImage: UIImage) {
        rightButton.setTitle("", for: .normal)
        rightButton.setBackgroundImage(bgImage, for: .normal)
    }
    private func setupPriceRangerUI(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        rightButton.layer.cornerRadius = 15
        leftButton.layer.cornerRadius = 15
        
        leftEnd = leftButton.center.x
        rightEnd = rightButton.center.x
        factor = maximumRangeValue / (rightEnd - leftEnd)
    }
}

