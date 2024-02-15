//
//  ApiService.swift
//  Login
//
//  Created by Tringapps on 09/02/24.
//

import UIKit

class ApiService{

    public func getItemData() -> [ItemData] {
        guard let returnData = UserDefaults.standard.data(forKey: "data") else {
            print("Error retrieving data from UserDefaults")
            return []
        }

        do {
            let decodedData = try JSONDecoder().decode([ItemData].self, from: returnData)
            return decodedData
        } catch {
            print("Error decoding data: \(error)")
            return []
        }
    }
    
    public func insertItemData(item: ItemData) {
        do {
            var decodedData = getItemData()
            let newId = decodedData.count + 1
            decodedData.append(ItemData(id: newId, summary: item.summary, date: item.date))

            let encodedData = try JSONEncoder().encode(decodedData)
            UserDefaults.standard.set(encodedData, forKey: "data")
            print("Success")
        } catch {
            print("Error insert data: \(error)")
        }
    }
    
    public func updateItemData(updatedSummary: String, updatedDate: String, indexPath: Int) {
        var items = getItemData()
        
        guard indexPath < items.count else {
            print("Error: IndexPath is out of bounds")
            return
        }
        
        items[indexPath].summary = updatedSummary
        items[indexPath].date = updatedDate
        
        do {
            let encodedData = try JSONEncoder().encode(items)
            UserDefaults.standard.set(encodedData, forKey: "data")
            print("Success: Data updated")
        } catch {
            print("Error updating data: \(error)")
        }
    }

    
    public func removeItemData(data: [ItemData]) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: "data")
            print("Success")
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    public func removeAllItemData() {
        UserDefaults.standard.removeObject(forKey: "data")
        print("Success")
    }
}
