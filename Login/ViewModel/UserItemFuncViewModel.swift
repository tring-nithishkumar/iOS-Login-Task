//
//  ItemFuncViewModel.swift
//  Login
//
//  Created by Tringapps on 14/02/24.
//

import UIKit

class UserItemFuncViewModel {
    
    private var apiService: ApiService = ApiService()
    private var items: [ItemData] = []
    
    public var sections: [String] = []
    public var itemsGroupedByDate: [String: [ItemData]] = [:]
    
    public func callFuncRemoveItemData(indexPath: IndexPath){
        
        let id = idOfIndex(indexPath: indexPath)
            
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            print("Error: Item with ID \(id) not found")
            return
        }
        
        items.remove(at: index)
        apiService.removeItemData(data: items)
    }
    
    public func callFuncRemoveAllItemData(){
        items.removeAll()
        apiService.removeAllItemData()
    }
    
    public func itemOfIndex(indexPath: IndexPath) -> ItemData{
        let date = sections[indexPath.section]
        
        if let items = itemsGroupedByDate[date], indexPath.row < items.count {
            let summary = items[indexPath.row].summary
            let date = items[indexPath.row].date
            let id = items[indexPath.row].id ?? 0

            return ItemData(id: id, summary: summary, date: date)
        }

        return ItemData(id: 0, summary: "", date: "")
    }

    public func idOfIndex(indexPath: IndexPath)-> Int{
        let date = sections[indexPath.section]
        if let items = itemsGroupedByDate[date] {
            print(items)
            if indexPath.row < items.count{
                return items[indexPath.row].id ?? 0
            }
        }

        return 0;
    }
    
    public func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy hh:mm a"
        return formatter.string(from: date)
    }
    
    public func groupItemsByDate() {
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
    
    public func numberOfSections()-> Int{
        sections.count
    }
    
    public func numberOfItemsGroupedByDate(date: String)-> Int{
        itemsGroupedByDate[date]?.count ?? 0
    }
    
    public func selectedIndexPath(indexPath: IndexPath)-> Bool{
        let id = idOfIndex(indexPath: indexPath)
            
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            print("Error: Item with ID \(id) not found")
            return false;
        }
        
        return items[index].isExpanded
    }
    
    public func setExpandView(indexPath: IndexPath){
        let id = idOfIndex(indexPath: indexPath)
            
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            print("Error: Item with ID \(id) not found")
            return
        }
        
        if items[index].isExpanded{
            items[index].isExpanded = false
        }else{
            items[index].isExpanded = true
        }
    }
    
}
