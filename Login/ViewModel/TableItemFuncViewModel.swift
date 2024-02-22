//
//  ItemFuncViewModel.swift
//  Login
//
//  Created by Tringapps on 14/02/24.
//

import UIKit

class TableItemFuncViewModel {

    private var apiService: ApiService = ApiService()
    private var items: [ItemData] = []
    var sections: [String] = []
    var itemsGroupedByDate: [String: [ItemData]] = [:]

    func callFuncRemoveItemData(indexPath: IndexPath) {

        let index = findIndex(indexPath: indexPath)

        items.remove(at: index)
        apiService.removeItemData(data: items)
    }

    func callFuncRemoveAllItemData() {
        items.removeAll()
        apiService.removeAllItemData()
    }

    func itemOfIndex(indexPath: IndexPath) -> ItemData {
        let date = sections[indexPath.section]

        if let items = itemsGroupedByDate[date], indexPath.row < items.count {
            let summary = items[indexPath.row].summary
            let date = items[indexPath.row].date
            let id = items[indexPath.row].id ?? 0

            return ItemData(id: id, summary: summary, date: date)
        }

        return ItemData(id: 0, summary: "", date: "")
    }

    func idOfIndex(indexPath: IndexPath) -> Int {
        let date = sections[indexPath.section]
        if let items = itemsGroupedByDate[date] {
            if indexPath.row < items.count {
                return items[indexPath.row].id ?? 0
            }
        }

        return 0
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy hh:mm a"
        return formatter.string(from: date)
    }

    func groupItemsByDate() {
        items = apiService.getItemData()

        for item in items {
            let date = item.date

            if !sections.contains(date) {
                sections.append(date)
            }

            if itemsGroupedByDate[date] == nil {
                itemsGroupedByDate[date] = [item]
            } else {
                itemsGroupedByDate[date]?.append(item)
            }
        }

        sections.sort { $0 < $1 }
    }

    func numberOfSections() -> Int {
        sections.count
    }

    func numberOfItemsGroupedByDate(date: String) -> Int {
        itemsGroupedByDate[date]?.count ?? 0
    }

    func findIndex(indexPath: IndexPath) -> Int {
        let id = idOfIndex(indexPath: indexPath)

        guard let index = items.firstIndex(where: { $0.id == id }) else {
            print("Error: Item with ID \(id) not found")
            return 0
        }

        return index
    }

    func selectedIndexPath(indexPath: IndexPath) -> Bool {
        let index = findIndex(indexPath: indexPath)

        return items[index].isExpanded
    }

    func setExpandView(indexPath: IndexPath) {
        let index = findIndex(indexPath: indexPath)

        items[index].isExpanded.toggle()
    }

}
