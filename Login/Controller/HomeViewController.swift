//
//  HomeViewController.swift
//  Login
//
//  Created by Tringapps on 19/02/24.
//

import UIKit

class HomeViewController: UIViewController {

    public var userName: String!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var titleItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        homeUI()
    }

    func userLogin(userName: String) {
        self.userName = userName
        homeUI()
    }

    private func homeUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Hello, \(userName ?? "User")"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.sizeToFit()

        titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem

        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))

        navigationItem.rightBarButtonItems = [logoutButton]

        navigationItem.setHidesBackButton(true, animated: false)
    }

    @objc private func handleLogOut() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func collectionViewButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        guard let collectionViewController =
                storyBoard.instantiateViewController(
                    withIdentifier: "CollectionViewController") as?
                CollectionViewController else {
                fatalError("InValid storyboard")
            }

        navigationController?.pushViewController(collectionViewController, animated: true)
    }

    @IBAction func tableViewButton(_ sender: Any) {
        let tableViewController = TabelViewController()
        navigationController?.pushViewController(tableViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
