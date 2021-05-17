//
//  ImageCollectionViewCell.swift
//  GalleryApp
//
//  Created by surya-zstk231 on 16/05/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewArea: UIImageView!
    @IBOutlet weak var mainViewArea: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainViewArea.layer.borderWidth = CGFloat(1)
        mainViewArea.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
    }

}
