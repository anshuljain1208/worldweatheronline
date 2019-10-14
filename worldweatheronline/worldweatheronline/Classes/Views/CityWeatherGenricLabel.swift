//
//  TitleWithSubtitleLabel.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 14/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class CityWeatherGenricLabel: UILabel {

  let subtitleLabel = UILabel()
  let titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  func setup() {
    super.text = ""
    super.attributedText = nil
    self.addSubview(subtitleLabel)
    self.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    let views: [String: UIView] = ["titleLabel": self.titleLabel,"subtitleLabel": self.subtitleLabel]
    let subtitleLabelVertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subtitleLabel]|", metrics: nil,views: views)
    let titleLabelVertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]|", metrics: nil,views: views)
    let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel][subtitleLabel]|", metrics: nil,views: views)
    let widthConstraint = NSLayoutConstraint(item: subtitleLabel, attribute: .width, relatedBy: .equal, toItem: titleLabel, attribute: .width, multiplier: 1, constant: 0)
    addConstraints(subtitleLabelVertical)
    addConstraints(titleLabelVertical)
    addConstraints(horizontal)
    addConstraint(widthConstraint)

}
  private var attributedSubtitle = NSAttributedString()
  private var attributedTitle = NSAttributedString()

  internal var titleAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.boldSystemFont(ofSize: 16)] {
    didSet {
      updateAttributedText()
    }
  }

  internal var subtitleAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 16)] {
    didSet {
      updateAttributedText()
    }
  }

  internal var subtitle: String? {
    set {
      if let value = newValue {
        attributedSubtitle = NSAttributedString(string: value, attributes: subtitleAttributes)
      } else {
        attributedSubtitle = NSAttributedString()
      }
      updateAttributedText()
    }
    get {
      return attributedSubtitle.string
    }
  }

  internal var title: String? {
    set {
      if let value = newValue {
        attributedTitle = NSAttributedString(string: value, attributes: titleAttributes)
      } else {
        attributedTitle = NSAttributedString()
      }
      updateAttributedText()
    }
    get {
      return attributedTitle.string
    }
  }

  func updateAttributedText() {
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.right
    let attributedText = NSMutableAttributedString(attributedString: attributedTitle)
    attributedText.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attributedText.string.count))
    subtitleLabel.attributedText = attributedSubtitle
    titleLabel.attributedText = attributedText
  }

  override var text: String? {
    set {

    }
    get {
       return nil
    }
  }

}
