//
//  UserViewController.swift
//  Login
//
//  Created by Tringapps on 06/02/24.
//

import UIKit

class TabelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var label: UILabel!
    private var tableItemFuncViewModel: TableItemFuncViewModel!
    private var tableView: UITableView!
    private var expandedCell: IndexSet = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userUI()
        setupTableView()
        createLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableItemFuncViewModel = TableItemFuncViewModel()
        tableItemFuncViewModel.groupItemsByDate()

        tableView.reloadData()
        handleTableView()
    }

    private func userUI() {
       view.backgroundColor = UIColor.systemBackground
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClear))

        navigationItem.rightBarButtonItems = [addButton, clearButton]
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableItemFuncViewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableItemFuncViewModel.sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = tableItemFuncViewModel.sections[section]
        return tableItemFuncViewModel.numberOfItemsGroupedByDate(date: date)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath
        ) as? CustomTableViewCell else { return UITableViewCell() }

        let date = tableItemFuncViewModel.sections[indexPath.section]
        if let items = tableItemFuncViewModel.itemsGroupedByDate[date] {
            let item = items[indexPath.row]
            cell.configure(summary: item.summary, date: item.date)
        }

        cell.selectionStyle = .none

        if tableItemFuncViewModel.selectedIndexPath(indexPath: indexPath) {
            cell.summaryButton.titleLabel?.numberOfLines = 0
            cell.moreButton.setTitle("See Less", for: .normal)
            cell.summaryButtonHeightConstraint.isActive = false
        } else {
            cell.summaryButton.titleLabel?.numberOfLines = 2
            cell.moreButton.setTitle("See More", for: .normal)
            cell.summaryButtonHeightConstraint.isActive = true
        }

        cell.moreButtonClicked = {
            self.tableItemFuncViewModel?.setExpandView(indexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }

        cell.summaryClicked = {
            let selectedItem = self.tableItemFuncViewModel.itemOfIndex(indexPath: indexPath)
            if let navigationController = self.navigationController {
                let updateItemViewController =
                AddItemViewController(summary: selectedItem.summary, date: selectedItem.date, id: selectedItem.id ?? 0)
                navigationController.pushViewController(updateItemViewController, animated: true)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableItemFuncViewModel.callFuncRemoveItemData(indexPath: indexPath)

            let date = tableItemFuncViewModel.sections[indexPath.section]
            tableItemFuncViewModel.itemsGroupedByDate[date]?.remove(at: indexPath.row)

            if tableItemFuncViewModel.itemsGroupedByDate[date]?.isEmpty ?? false {
                tableItemFuncViewModel.sections.remove(at: indexPath.section)

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
        tableItemFuncViewModel.callFuncRemoveAllItemData()
        tableView.reloadData()
    }

    private func handleTableView() {
        if tableItemFuncViewModel.numberOfSections() == 0 {
            label.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            label.isHidden = true
        }
    }
}
