//
//  CityWeatherTableCellTableViewCell.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 13/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class CityWeatherTableCellTableViewCell: UITableViewCell {

  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconView: ImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
