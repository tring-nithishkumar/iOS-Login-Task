//
//  ItemFuncViewModel.swift
//  Login
//
//  Created by Tringapps on 14/02/24.
//

import UIKit

class ItemFuncViewModel {
    
    private var apiService: ApiService = ApiService()
    private var items: [ItemData] = []
    public var updateable = false;
    private var count: Int = 0
    
    init() {
        self.items = apiService.getItemData()
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
