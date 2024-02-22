//
//  CollectionFuncViewModel.swift
//  Login
//
//  Created by Tringapps on 20/02/24.
//

import UIKit

class CollectionFuncViewModel {

    private var networkService: NetworkService = NetworkService()
    private var photoItems: [PhotoData] = []

    func callgetFuncPhotoData(completion: @escaping () -> Void) {
        networkService.getImage { (imageDetails) in
            self.photoItems = imageDetails ?? []
            completion()
        }
    }

    func callDownloadImageFunc(imageUrl: URL, completion: @escaping (UIImage?) -> Void) {
        networkService.downloadImage(from: imageUrl) { (image) in
            completion(image)
        }
    }

    func numberOfPhotoItems() -> Int {
        photoItems.count
    }

    func photoDetailOfIndex(indexPath: IndexPath) -> String {
        if indexPath.item < photoItems.count {
            return photoItems[indexPath.item].thumbnailUrl
        }

        return ""
    }
}
