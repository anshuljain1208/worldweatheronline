//
//  CityWeatherTableGenricCellTableViewCell.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 14/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class CityWeatherGenricTableCell: UITableViewCell {

  @IBOutlet weak var subtitleLabel: CityWeatherGenricLabel!
  @IBOutlet weak var titleLabel: CityWeatherGenricLabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
