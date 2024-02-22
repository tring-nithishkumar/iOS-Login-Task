//
//  ApiService.swift
//  Login
//
//  Created by Tringapps on 09/02/24.
//

import UIKit

class ApiService {

    func getItemData() -> [ItemData] {
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

    func insertItemData(item: ItemData) {
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

    func updateItemData(updatedSummary: String, updatedDate: String, id: Int) {
        var items = getItemData()

        guard let index = items.firstIndex(where: { $0.id == id }) else {
            print("Error: Item with ID \(id) not found")
            return
        }

        items[index].summary = updatedSummary
        items[index].date = updatedDate

        do {
            let encodedData = try JSONEncoder().encode(items)
            UserDefaults.standard.set(encodedData, forKey: "data")
            print("Success: Data updated")
        } catch {
            print("Error updating data: \(error)")
        }
    }

    func removeItemData(data: [ItemData]) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: "data")
            print("Success")
        } catch {
            print("Error encoding data: \(error)")
        }
    }

    func removeAllItemData() {
        UserDefaults.standard.removeObject(forKey: "data")
        print("Success")
    }
}
