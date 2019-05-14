//
//  TemplateContentVM.swift
//  iOS_Starter
//
//  Created by Crocodic MBP-2 on 26/07/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import Foundation

class TemplateContentVM {
    private var contents = [TemplateContent]()
    
    private var offset = 0
    private var limit = 10
    var canLoadMore = false
    private var isLoading = false
    
    init() {
        
    }
    
    var isContentsEmpty: Bool {
        return contents.isEmpty
    }
    
    var numberOfItems: Int {
        return contents.count
    }
    
    func viewModelOfItem(at indexPath: IndexPath) -> TemplateContentItemVM {
        let content = contents[indexPath.row]
        return TemplateContentItemVM(content: content)
    }
    
    func fetch(isLoadMore: Bool = false, searchText: String, completion: ((String) -> Void)?) {
        if isLoading {
            return
        }
        if !isLoadMore {
            offset = 0
            limit = 10
            canLoadMore = false
        }
        
        // Dummy static content data
        if !isLoadMore {
            self.contents.removeAll()
        }
        isLoading = true
        for i in offset + 1 ... limit + offset {
            let content = TemplateContent(id: i, name: "Title of Content \(i)", detail: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum", image: "blank_image")
            
            self.contents.append(content)
        }
        if !searchText.isEmpty {
            self.contents = self.contents.filter({ $0.name.contains(searchText)})
        }
        self.canLoadMore = limit - offset >= limit
        self.offset += self.limit
        
        completion?("Sukses")
        
        isLoading = false
        
        // Example request & parsing response to your object model
        
//        isLoading = true
//        _ = ApiHelper.shared.exampleList(searchText: searchText, limit: limit, offset: offset, completion: { (json, isSuccess, message) in
//            if isSuccess {
//                let data = json["data"].arrayValue
//                self.canLoadMore = data.count >= limit
//                self.offset += self.limit
//
//                if !self.isLoadMore {
//                    self.contents.removeAll()
//                }
//
//                for aData in data {
//                    let content = TemplateContent(fromJson: aData)
//                    self.contents.append(content)
//                }
//            } else {
//
//            }
//            isLoading = false
//            completion?(message)
//        })
    }
}
