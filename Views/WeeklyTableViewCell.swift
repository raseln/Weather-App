//
//  WeeklyTableViewCell.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 16/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var labelWeekName: UILabel!
    @IBOutlet weak var imageTemperature: UIImageView!
    @IBOutlet weak var labelMinTemperature: UILabel!
    @IBOutlet weak var labelMaxTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
