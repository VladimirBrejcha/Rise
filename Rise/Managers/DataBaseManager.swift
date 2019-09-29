//
//  DataBaseManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

//class CalculatedPlan:  {
//    @objc dynamic var minutesOfSleep: Int = 0
//    @objc dynamic var days: Int = 0
//    @objc dynamic var minutesPerDay: Int = 0
//}

struct CalculatedPlan {
    var minutesOfSleep: Int
    var days: Int
    var minutesPerDay: Int
}


//class DataBaseManager {
//    private static let realm = try! Realm()
//    
//    class func save(plan: CalculatedPlan) {
//        do {
//            try realm.write {
//                realm.add(plan)
//            }
//        } catch {
//            print("error saving plan \(error)")
//        }
//    }
//
//    class func getPlan() -> CalculatedPlan? {
//         return realm.objects(CalculatedPlan.self).first
//    }
//
//    class func removePlan() {
//
//    }
//
//}

//// Queries are updated in realtime
//puppies.count // => 1
//
//// Query and update from any thread
//DispatchQueue(label: "background").async {
//    autoreleasepool {
//        let realm = try! Realm()
//        let theDog = realm.objects(Dog.self).filter("age == 1").first
//        try! realm.write {
//            theDog!.age = 3
//        }
//    }
//}

