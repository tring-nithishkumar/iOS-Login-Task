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
    
    public func callFuncInsertItemData(summary: String, date: String){
        apiService.insertItemData(item: ItemData(summary: summary, date: date))
    }
    
    public func callFuncUpdateItemData(updatedSummary: String, updatedDate: String, id: Int){
        apiService.updateItemData(updatedSummary: updatedSummary, updatedDate: updatedDate, id: id)
    }
    
    public func summaryOfIndex(indexPath: IndexPath)-> String{
        if indexPath.row < items.count{
            return items[indexPath.row].summary
        }
        
        return "";
    }
    
    public func dateOfIndex(indexPath: IndexPath)-> String{
        if indexPath.row < items.count{
            return items[indexPath.row].date
        }
        
        return "";
    }
    
    public func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy HH:mm a"
        return formatter.string(from: date)
    }
}
