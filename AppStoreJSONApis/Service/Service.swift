//
//  Service.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 16.02.23.
//

import Foundation

class Service {
    static let shared = Service()
    
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        fetchGenericJSONData(urlString: "https://itunes.apple.com/search?term=\(searchTerm)&entity=software", completion: completion)
  
    }
    
    func fetchTopFreeApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json", completion: completion)
    }
  
    func fetchTopFreeBooks(completion: @escaping (AppGroup?, Error?) -> ()) {
        fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/books/top-free/25/books.json", completion: completion)
    }
    
    func fetchMostPlayedMusics(completion: @escaping (AppGroup?, Error?) -> ()) {
        let UrlString = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json"
        fetchAppGroup(urlString: UrlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    //helper
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            if let err = err {
                print("error",err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

// STACK
// Generic is to declare the Type later on

class Stack<T: Decodable> {
    var items = [T]()
    func push(item: T) { items.append(item) }
    func pop() -> T? {return items.last}
}

import UIKit

func dummyFunc() {
    let stackOfStrings = Stack<String>()
    stackOfStrings.push(item: "Has to be string")
    
    let stackOfInt = Stack<Int>()
    stackOfInt.push(item: 1)
}
