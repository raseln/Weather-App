//
//  CurrentWeatherTableViewCell.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 17/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelCurrentTemperature: UILabel!
    @IBOutlet weak var imageCurrentTemperature: UIImageView!
    @IBOutlet weak var labelSummary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
