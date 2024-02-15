//
//  ItemFuncViewModel.swift
//  Login
//
//  Created by Tringapps on 14/02/24.
//

import UIKit

class UpdateItemFuncViewModel {
    
    private var apiService: ApiService = ApiService()
    private var items: [ItemData] = []
    
    public func callFuncGetItemData(){
        items = apiService.getItemData()
    }
    
    public func callFuncRemoveItemData(index: Int){
        items.remove(at: index)
        apiService.removeItemData(data: items)
    }
    
    public func callFuncRemoveAllItemData(){
        items.removeAll()
        apiService.removeAllItemData()
    }
    
    public func numberOfItems()-> Int{
        items.count
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
