//
//  HourlyWeatherCollectionViewCell.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 13/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
