//
//  ItemModel.swift
//  Login
//
//  Created by Tringapps on 09/02/24.
//

import UIKit

class ItemViewModel{
    private var apiService: ApiService = ApiService()
    private var items: [ItemData] = []
    
    public func callFuncGetItemData(){
        items = apiService.getItemData()
    }
    
    public func callFuncInsertItemData(summary: String, date: String){
        apiService.insertItemData(item: ItemData(summary: summary, date: date))
    }
    
    public func callFuncUpdateItemData(updatedSummary: String, updatedDate: String, indexPath: Int){
        apiService.updateItemData(updatedSummary: updatedSummary, updatedDate: updatedDate, indexPath: indexPath)
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
}
