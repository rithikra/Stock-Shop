//
//  TradeViewCell.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/4/21.
//

import Foundation
import UIKit

class TradeViewCell: UICollectionViewCell{
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var targetDateLabel: UILabel!
    
    @IBOutlet weak var strikePriceLabel: UILabel!
    @IBOutlet weak var progressViewBar: UIProgressView!
}
