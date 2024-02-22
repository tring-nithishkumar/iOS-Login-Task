//
//  CustomCollectionViewCell.swift
//  Login
//
//  Created by Tringapps on 20/02/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var handleImageTapped: (() -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped)
        )
//        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func imageTapped() {
        handleImageTapped()
    }
}
