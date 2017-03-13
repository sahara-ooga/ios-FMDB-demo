//
//  DataAccessObject.swift
//  ios-FMDB-demo
//
//  Created by OkuderaYuki on 2017/03/13.
//  Copyright © 2017年 YukiOkudera. All rights reserved.
//

import Foundation
import FMDB

protocol BaseDao {
    var baseDao: DataAccessObject {get}
}

final class DataAccessObject: NSObject {
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!.appendingPathComponent("sw.db")
    
    var db: FMDatabase
    
    override init() {
        db = FMDatabase(path: dbPath)
    }
    
    func dbOpen() -> Bool {
        let isOpen = db.open()
        
        if !isOpen {
            fatalError("Failed to open database.")
        }
        return isOpen
    }
    
    func dbClose() -> Bool {
        let isClose = db.close()
        
        if !isClose {
            fatalError("Failed to close database.")
        }
        return isClose
    }
    
    func beginTransaction() -> Bool {
        let beginTran = db.beginTransaction()
        
        if !beginTran {
            fatalError("Failed to begin transaction.")
        }
        return beginTran
    }
}
