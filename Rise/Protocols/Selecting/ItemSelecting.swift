//
//  ItemSelecting.swift
//  Rise
//
//  Created by Владимир Королев on 12.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ItemSelecting: ItemsContainable where Item: SelectableItem  {
    mutating func select(_ selected: Bool, item: Item) throws
}

extension ItemSelecting {
    mutating func select(_ selected: Bool, item: Item) throws {
        guard let index = items.firstIndex(of: item) else {
            throw SingleElementSelectableArrayError.elementDoesntExist
        }
        items[index].isSelected = selected
    }
}

protocol SingleItemSelecting: ItemSelecting { }

extension SingleItemSelecting {
    var selectedItem: Item? { items.first(where: \.isSelected) }
    
    mutating func select(_ selected: Bool, item: Item) throws {
        guard let index = items.firstIndex(of: item) else {
            throw SingleElementSelectableArrayError.elementDoesntExist
        }
        if selected { clearSelection() }
        items[index].isSelected = selected
    }

    mutating func clearSelection() {
        guard let selectedItem = selectedItem else { return }
        if let selectedIndex = items.firstIndex(of: selectedItem) {
            if items.indices.contains(selectedIndex) {
                items[selectedIndex].isSelected = false
            }
        }
    }
}
