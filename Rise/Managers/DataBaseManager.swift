//
//  DataBaseManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import RealmSwift

class CalculatedPlan: Object {
    @objc dynamic var days: Int = 0
    @objc dynamic var minutesPerDay: Int = 0
}

struct DataBaseManager {
    private let realm = try! Realm()
    let calculatedPlan: CalculatedPlan
    
    func save() {
        do {
            try realm.write {
                realm.add(calculatedPlan)
            }
        } catch {
            print("error saving plan \(error)")
        }
    }
}
