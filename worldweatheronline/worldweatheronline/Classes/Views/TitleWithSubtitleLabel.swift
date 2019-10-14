//
//  TitleWithSubtitleLabel.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 14/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class TitleWithSubtitleLabel: UILabel {

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
      let attributedText = NSMutableAttributedString(attributedString: attributedTitle)
      attributedText.append(attributedSubtitle)
      self.attributedText = attributedText;
  }

//  override var text: String? {
//    set {
//
//    }
//    get {
//       return nil
//    }
//  }

}
