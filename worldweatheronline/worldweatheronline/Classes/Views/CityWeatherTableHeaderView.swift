//
//  CityWeatherTableHeaderView.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 14/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class CityWeatherTableHeaderView: UITableViewHeaderFooterView {


  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    self.backgroundView = UIView()
    self.backgroundView?.backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
