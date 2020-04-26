//
//  SingleSelectable.swift
//  Rise
//
//  Created by Владимир Королев on 18.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol SingleSelectable: MultipleSelectable { }

extension SingleSelectable {
    mutating func setSelected(_ selected: Bool, item: inout Item) {
        if selected,
            let index = items.firstIndex(where: \.isSelected) {
            items[index].isSelected = false
        }
        item.isSelected = selected
    }
    
    mutating func setSelected(_ selected: Bool, at index: Int) {
        if !items.indices.contains(index) { return } // todo throw?
        if selected,
            let index = items.firstIndex(where: \.isSelected) {
            items[index].isSelected = false
        }
        items[index].isSelected = selected
    }
}
