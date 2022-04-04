//
//  DatabaseHelper.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 10/10/17.
//  Copyright © 2017 WahyuAdyP. All rights reserved.
//

//import Foundation
//import RealmSwift
//
//class DatabaseHelper {
//    static let shared: DatabaseHelper = DatabaseHelper()
//    
//    var realm: Realm?
//
//    // MARK: - Initialization
//    init() {
//        migration()
//        do {
//            self.realm = try Realm()
//        } catch let error {
//            print("Error initialization realm: \(error)")
//            self.realm = nil
//        }
//    }
//
//    // MARK: - Functions
//    func migration() {
//        // Documentation: https://docs.mongodb.com/realm/sdk/ios/examples/modify-an-object-schema/#perform-a-schema-migration
//        let config = Realm.Configuration(schemaVersion: 1)
//        Realm.Configuration.defaultConfiguration = config
//    }
//
//    func checkData<T: Object>(objectType: T.Type, filter predicate: NSPredicate) -> Bool {
//        guard ((self.realm?.objects(objectType).filter(predicate).map({$0}).first) != nil) else {
//            return false
//        }
//        return true
//    }
//
//    func getData<T: Object>(objectType: T.Type) -> T {
//        return self.realm?.objects(objectType).first ?? T()
//    }
//
//    func getData<T: Object>(objectType: T.Type, filter predicate: NSPredicate) -> T {
//        return self.realm?.objects(objectType).filter(predicate).map({$0}).first ?? T()
//    }
//
//    func getData<T: Object>(objectType: T.Type, key: AnyObject) -> T {
//        return self.realm?.object(ofType: objectType, forPrimaryKey: key) ?? T()
//    }
//
//    func getData<T: Object>(objectType: T.Type, sortBy property: String, ascending: Bool = true, limit: Int) -> [T] {
//        guard let datas: Results<T> = self.realm?.objects(objectType).sorted(byKeyPath: property, ascending: ascending) else { return [] }
//        return (0 ..< min(limit, datas.count)).map({datas[$0]})
//    }
//
//    func getData<T: Object>(objectType: T.Type, filter predicate: NSPredicate, sortBy property: String, ascending: Bool = true, limit: Int) -> [T] {
//        guard let datas: Results<T> = self.realm?.objects(objectType).filter(predicate).sorted(byKeyPath: property, ascending: ascending) else { return [] }
//        return (0 ..< min(limit, datas.count)).map({datas[$0]})
//    }
//
//    func getAllData<T: Object>(objectType: T.Type) -> [T] {
//        return self.realm?.objects(objectType).map({$0}) ?? []
//    }
//
//    func getAllData<T: Object>(objectType: T.Type, filter predicate: NSPredicate) -> [T] {
//        return self.realm?.objects(objectType).filter(predicate).map({$0}) ?? []
//    }
//
//    func getAllData<T: Object>(objectType: T.Type, sortBy property: String, ascending: Bool) -> [T] {
//        return self.realm?.objects(objectType).sorted(byKeyPath: property).map({$0}) ?? []
//    }
//
//    func getAllData<T: Object>(objectType: T.Type, filter predicate: NSPredicate, sortBy property: String, ascending: Bool = true) -> [T] {
//        return self.realm?.objects(objectType).filter(predicate).sorted(byKeyPath: property, ascending: ascending).map({$0}) ?? []
//    }
//
//    func getAllData<T: Object>(objectType: T.Type, sortBy property: [RealmSwift.SortDescriptor]) -> [T] {
//        return self.realm?.objects(objectType).sorted(by: property).map({$0}) ?? []
//    }
//
//    func getAllData<T: Object>(objectType: T.Type, filter predicate: NSPredicate, sortBy property: [RealmSwift.SortDescriptor]) -> [T] {
//        return self.realm?.objects(objectType).filter(predicate).sorted(by: property).map({$0}) ?? []
//    }
//
//    func write(writeBlock: (Realm) -> Void) -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                writeBlock(realm)
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//
//    func addData(object: Object, update: Bool = true) -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                realm.add(object, update: update ? .modified : .error)
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//
//    func addData(objects: [Object], update: Bool = true) -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                realm.add(objects, update: update ? .modified : .error)
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//
//    func deleteData(object: Object) -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                realm.delete(object)
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//
//    func deleteData(objects: [Object]) -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                realm.delete(objects)
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//
//    func deleteAllData<T: Object>(objectType: T.Type) -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                realm.delete(realm.objects(objectType))
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//
//    func deleteAllData() -> Bool {
//        guard let realm: Realm = self.realm else { return false }
//
//        do {
//            try realm.write({
//                realm.deleteAll()
//            })
//
//            return true
//
//        } catch _ as NSError {
//            return false
//        }
//    }
//}
