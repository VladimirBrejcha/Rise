//
//  IndexSelecting.swift
//  Rise
//
//  Created by Владимир Королев on 12.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol IndexSelecting: ItemsContainable where Item: SelectableItem {
    mutating func select(_ selected: Bool, at index: Int) throws
}

extension IndexSelecting {
    mutating func select(_ selected: Bool, at index: Int) throws {
        if !items.indices.contains(index) { throw SingleElementSelectableArrayError.indexOutOfBounds }
        items[index].isSelected = selected
    }
}

protocol SingleIndexSelecting: IndexSelecting { }

extension SingleIndexSelecting {
    var selectedIndex: Int? { items.firstIndex(where: \.isSelected) }
    
    mutating func select(_ selected: Bool, at index: Int) throws {
        if !items.indices.contains(index) { throw SingleElementSelectableArrayError.indexOutOfBounds }
        
        if selected { clearSelection() }
        
        items[index].isSelected = selected
    }
            
    mutating func clearSelection() {
        if let selectedIndex = selectedIndex {
            if items.indices.contains(selectedIndex) {
                items[selectedIndex].isSelected = false
            }
        }
    }
}
