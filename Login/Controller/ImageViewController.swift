//
//  ImageViewController.swift
//  Login
//
//  Created by Tringapps on 22/02/24.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var passedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = passedImage {
            imageView.image = image
        } else {
            print("Error: passedImage is nil")
        }
    }
}
