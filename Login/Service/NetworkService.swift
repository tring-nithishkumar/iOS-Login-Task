//
//  NetworkService.swift
//  Login
//
//  Created by Tringapps on 20/02/24.
//

import Foundation
import UIKit

class NetworkService {

    func getImage(completion: @escaping ([PhotoData]?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let imageDetails = try decoder.decode([PhotoData].self, from: data)
                completion(imageDetails)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
