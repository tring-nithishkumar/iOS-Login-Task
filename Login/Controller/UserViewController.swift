//
//  UserViewController.swift
//  Login
//
//  Created by Tringapps on 06/02/24.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let userName: String
    private var label: UILabel!
    private var itemViewModel: ItemViewModel = ItemViewModel()
    private var itemFuncViewModel: ItemFuncViewModel!
    private var tableView: UITableView!
    private var expandedCell: IndexSet = []

    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userUI()
        setupTableView()
        createLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemFuncViewModel = ItemFuncViewModel()
        itemViewModel.callFuncGetItemData()
        tableView.reloadData()
        handleTableView()
    }

    private func userUI() {
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "Hello, \(userName)"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.sizeToFit()

        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem

        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClear))

        navigationItem.rightBarButtonItems = [logoutButton, addButton, clearButton]

        navigationItem.setHidesBackButton(true, animated: false)
    }

    private func createLabel() {
        label = UILabel()
        label.text = "Nothing to display"
        
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViewModel.numberOfItems()
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.configure(summary: itemFuncViewModel.summaryOfIndex(indexPath: indexPath), date: itemFuncViewModel.dateOfIndex(indexPath: indexPath))
        cell.selectionStyle = .none
        
        if expandedCell.contains(indexPath.row){
            cell.summaryButton.titleLabel?.numberOfLines = 0
            cell.moreButton.setTitle("See Less", for: .normal)
            cell.summaryButtonHeightConstraint.isActive = false
        }else{
            cell.summaryButton.titleLabel?.numberOfLines = 2
            cell.moreButton.setTitle("See More", for: .normal)
            cell.summaryButtonHeightConstraint.isActive = true
        }
           
        cell.moreButtonClicked = {
            print(indexPath.row)
            if self.expandedCell.contains(indexPath.row){
                self.expandedCell.remove(indexPath.row)
            } else {
                self.expandedCell.insert(indexPath.row)
            }
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }

        cell.summaryClicked = {
            self.itemFuncViewModel.updateable = true
            let selectedSummary = self.itemFuncViewModel.summaryOfIndex(indexPath: indexPath)
            let selectedDate = self.itemFuncViewModel.dateOfIndex(indexPath: indexPath)
            if let navigationController = self.navigationController {
                let updateItemViewController = AddItemViewController(summary: selectedSummary, date: selectedDate, indexPath: indexPath.row)
                navigationController.pushViewController(updateItemViewController, animated: true)
            }
        }
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemViewModel.callFuncRemoveItemData(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            handleTableView()
        }
    }
    
    @objc private func handleLogOut() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleAdd() {
        let addItemViewController = AddItemViewController()
        navigationController?.pushViewController(addItemViewController, animated: true)
    }

    @objc private func handleClear() {
        label.isHidden = false
        tableView.isHidden = true
        itemViewModel.callFuncRemoveAllItemData()
        tableView.reloadData()
    }
    
    private func handleTableView(){
        if itemViewModel.numberOfItems() == 0 {
            label.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            label.isHidden = true
        }
    }
}
