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
    private var userItemFuncViewModel: UserItemFuncViewModel!
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
        userItemFuncViewModel = UserItemFuncViewModel()
//        updateItemFuncViewModel.callFuncGetItemData()
        
        userItemFuncViewModel.groupItemsByDate()
        
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
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
//        print(updateItemFuncViewModel.numberOfSections())
        return userItemFuncViewModel.numberOfSections()
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userItemFuncViewModel.sections[section]
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = userItemFuncViewModel.sections[section]
        return userItemFuncViewModel.numberOfItemsGroupedByDate(date: date)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        let date = userItemFuncViewModel.sections[indexPath.section]
        if let items = userItemFuncViewModel.itemsGroupedByDate[date] {
            let item = items[indexPath.row]
            cell.configure(summary: item.summary, date: item.date)
        }
        
        cell.selectionStyle = .none
        
        if userItemFuncViewModel.selectedIndexPath(indexPath: indexPath){
            cell.summaryButton.titleLabel?.numberOfLines = 0
            cell.moreButton.setTitle("See Less", for: .normal)
            cell.summaryButtonHeightConstraint.isActive = false
        }else{
            cell.summaryButton.titleLabel?.numberOfLines = 2
            cell.moreButton.setTitle("See More", for: .normal)
            cell.summaryButtonHeightConstraint.isActive = true
        }
           
        cell.moreButtonClicked = {
            if self.userItemFuncViewModel.selectedIndexPath(indexPath: indexPath){
                self.userItemFuncViewModel.setExpandView(indexPath: indexPath)
            } else {
                self.userItemFuncViewModel.setExpandView(indexPath: indexPath)
            }
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }

        cell.summaryClicked = {
            let selectedItem = self.userItemFuncViewModel.itemOfIndex(indexPath: indexPath)
            if let navigationController = self.navigationController {
                let updateItemViewController = AddItemViewController(summary: selectedItem.summary, date: selectedItem.date, id: selectedItem.id ?? 0)
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
            userItemFuncViewModel.callFuncRemoveItemData(indexPath: indexPath)
            
            let date = userItemFuncViewModel.sections[indexPath.section]
            userItemFuncViewModel.itemsGroupedByDate[date]?.remove(at: indexPath.row)

            if userItemFuncViewModel.itemsGroupedByDate[date]?.isEmpty ?? false {
                userItemFuncViewModel.sections.remove(at: indexPath.section)

                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
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
        userItemFuncViewModel.callFuncRemoveAllItemData()
        tableView.reloadData()
    }
    
    private func handleTableView(){
        if userItemFuncViewModel.numberOfSections() == 0 {
            label.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            label.isHidden = true
        }
    }
}
