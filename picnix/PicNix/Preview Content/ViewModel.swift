//
//  ViewModel.swift
//  PicNix
//
//  Created by Abdalla Abdelmagid on 10/20/24.
//

import SwiftUI

class ViewModel : ObservableObject {
    @Published var isLoading = false
    @Published var posts : [Model] = []
    let url = "https://www.jalirani.com/files/picnix.json"
    
    func pullPosts(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        isLoading = true
        
        // Fetch data
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Model].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.posts = decodedData
                        self.isLoading = false
                    }
                } catch {
                    print("error decoding JSON: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
        }.resume()
    }
}
