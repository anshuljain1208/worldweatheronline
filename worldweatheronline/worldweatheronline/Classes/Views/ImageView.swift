//
//  ImageView.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 12/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
  var downloadOperation: Operation? = nil
  var placeholderImage: UIImage? = nil {
    didSet{
      if image == nil, image == oldValue {
        image = placeholderImage
      }
    }
  }

  deinit {
    downloadOperation?.cancel()
    downloadOperation = nil
  }

  func setImage(imageURL: URL, placeHolder: UIImage? = nil) {
    if let placeHolderImage = placeHolder {
      self.placeholderImage = placeHolderImage
    }
    downloadOperation?.cancel()
    downloadOperation = ImageManager.shared.fetechImage(forURL: imageURL) { (result) in
      switch result{
      case .success(let image):
        self.image = image
      case .failure(let error):
        self.image = self.placeholderImage
        print("image download error \(error)")
      }
    }
  }
}
