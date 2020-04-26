//
//  MultipleSelectable.swift
//  Rise
//
//  Created by Владимир Королев on 18.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol MultipleSelectable: ItemsContainable where Item: SelectableItem { }

extension MultipleSelectable {
    func setSelected(_ selected: Bool, item: inout Item) {
        item.isSelected = selected
    }
    
    mutating func setSelected(_ selected: Bool, at index: Int) {
        if items.indices.contains(index) { // todo throw?
            items[index].isSelected = selected
        }
    }
}
