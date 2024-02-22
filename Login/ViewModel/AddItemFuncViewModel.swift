//
//  ItemFuncViewModel.swift
//  Login
//
//  Created by Tringapps on 14/02/24.
//

import UIKit

class AddItemFuncViewModel {

    private var apiService: ApiService = ApiService()
    private var items: [ItemData] = []

    func callFuncInsertItemData(summary: String, date: String) {
        apiService.insertItemData(item: ItemData(summary: summary, date: date))
    }

    func callFuncUpdateItemData(updatedSummary: String, updatedDate: String, id: Int) {
        apiService.updateItemData(updatedSummary: updatedSummary, updatedDate: updatedDate, id: id)
    }

    func summaryOfIndex(indexPath: IndexPath) -> String {
        if indexPath.row < items.count {
            return items[indexPath.row].summary
        }
        return ""
    }

    func dateOfIndex(indexPath: IndexPath) -> String {
        if indexPath.row < items.count {
            return items[indexPath.row].date
        }
        return ""
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy HH:mm a"
        return formatter.string(from: date)
    }
}
