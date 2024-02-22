//
//  CollectionViewController.swift
//  Login
//
//  Created by Tringapps on 20/02/24.
//

// ViewController.swift
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    private var collectionFuncViewModel: CollectionFuncViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionFuncViewModel = CollectionFuncViewModel()
        collectionFuncViewModel.callgetFuncPhotoData {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        setupCollectionView()
    }

    func setupCollectionView() {
        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionFuncViewModel.numberOfPhotoItems()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "CustomCollectionViewCell",
                    for: indexPath) as? CustomCollectionViewCell else {
                        fatalError("Unable to dequeue CustomCollectionViewCell")
                    }

        if let imageUrl = URL(string: collectionFuncViewModel.photoDetailOfIndex(indexPath: indexPath)) {
            collectionFuncViewModel.callDownloadImageFunc(imageUrl: imageUrl) { (image) in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.handleTapped = {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        guard let imageViewController = storyBoard.instantiateViewController(
                            withIdentifier: "ImageViewController"
                        ) as? ImageViewController else {
                            fatalError("Invalid storyboard")
                        }
                        imageViewController.passedImage = image
                        self.navigationController?.pushViewController(imageViewController, animated: true)
                    }
                }
            }
        }

//        cell.handleImageTapped = {
//            if let imageUrl = URL(string: self.collectionFuncViewModel.photoDetailOfIndex(indexPath: indexPath)) {
//                self.collectionFuncViewModel.callDownloadImageFunc(imageUrl: imageUrl) { (image) in
//                    DispatchQueue.main.async {
//                        if let image = image {
//                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                            guard let imageViewController =
//                                    storyBoard.instantiateViewController(
//                                        withIdentifier: "ImageViewController"
//                                    ) as? ImageViewController else {
//                                    fatalError("Invalid storyboard")
//                                }
//                            imageViewController.passedImage = image
//                            self.navigationController?.pushViewController(imageViewController, animated: true)
//                        } else {
//                            print("Error: Downloaded image is nil")
//                        }
//                    }
//                }
//            }
//        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width

        let isiPad = UIDevice.current.userInterfaceIdiom == .pad

        let numberOfColumns = isiPad ? 7 : 4

        let cellWidth = collectionViewWidth / CGFloat(numberOfColumns)

        return CGSize(width: cellWidth, height: cellWidth)
    }
}
