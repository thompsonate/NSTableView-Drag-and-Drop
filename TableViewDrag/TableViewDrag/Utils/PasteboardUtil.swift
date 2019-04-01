//
//  PasteboardUtil.swift
//  TableViewDrag
//
//  Created by Nate Thompson on 3/21/19.
//  Copyright © 2019 Nate Thompson. All rights reserved.
//

import Cocoa

class FruitPasteboardWriter: NSObject {
    var fruit: String
    var index: Int
    
    init(fruit: String, at index: Int) {
        self.fruit = fruit
        self.index = index
    }
    
    
    
    
    
}


extension NSPasteboardItem {
    open func integer(forType type: NSPasteboard.PasteboardType) -> Int? {
        guard let data = data(forType: type) else { return nil }
        let plist = try? PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil)
        return plist as? Int
    }
}
