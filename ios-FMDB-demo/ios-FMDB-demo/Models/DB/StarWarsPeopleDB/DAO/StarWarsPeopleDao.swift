//
//  StarWarsPeopleDao.swift
//  ios-FMDB-demo
//
//  Created by OkuderaYuki on 2017/03/14.
//  Copyright © 2017年 YukiOkudera. All rights reserved.
//

import Foundation

final class StarWarsPeopleDao: NSObject {
    let baseDao = DataAccessObject()
    
    // MARK:- Create Table
    
    /// StarWarsPeopleテーブルが存在しなければ、作成する
    func createTable() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS StarWarsPeople (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, height INTEGER, mass INTEGER, birth_year TEXT, gender TEXT)"
        
        _ = baseDao.dbOpen()
        let executeSQL = baseDao.db.executeUpdate(sql, withArgumentsIn: nil)
        _ = baseDao.dbClose()
        
        return executeSQL
    }
    
    // MARK:- INSERT
    
    /// StarWarsPeopleテーブルにレコードを追加する
    func insert(swPeopleDto: StarWarsPeopleDto) -> Bool {
        let sql = "INSERT INTO StarWarsPeople(name, height, mass, birth_year, gender) VALUES(?, ?, ?, ?, ?)"
        let swPeople: [Any] = [swPeopleDto.name,
                               swPeopleDto.height,
                               swPeopleDto.mass,
                               swPeopleDto.birth_year,
                               swPeopleDto.gender]
        _ = baseDao.dbOpen()
        let executeSQL = baseDao.db.executeUpdate(sql, withArgumentsIn: swPeople)
        _ = baseDao.dbClose()
        return executeSQL
    }
    
    /// トランザクションを使用してStarWarsPeopleテーブルに複数件レコードを追加する
    func insert(swPeopleDtos: [StarWarsPeopleDto]) -> Bool {
        let sql = "INSERT INTO StarWarsPeople(name, height, mass, birth_year, gender) VALUES(?, ?, ?, ?, ?)"
        var swPeopleArray: Array<Any> = []
        
        swPeopleDtos.forEach { (swPeopleDto) in
            swPeopleArray.append([swPeopleDto.name,
                                  swPeopleDto.height,
                                  swPeopleDto.mass,
                                  swPeopleDto.birth_year,
                                  swPeopleDto.gender])
        }
        _ = baseDao.dbOpen()
        _ = baseDao.beginTransaction()
        
        var success = true
        for swPeople in swPeopleArray {
            
            success = baseDao.db.executeUpdate(sql, withArgumentsIn: swPeople as! [Any])
            
            if !success {
                break
            }
        }
        if success {
            // 全てのINSERTが成功した場合はcommitする
            baseDao.db.commit()
        } else {
            baseDao.db.rollback()
        }
        _ = baseDao.dbClose()
        
        return success
    }
    
    // MARK:- SELECT
    
    /// StarWarsPeopleテーブルのレコードを全件取得する
    func selectAll() -> [StarWarsPeopleDto]? {
        let sql = "SELECT * FROM StarWarsPeople"
        
        var resultArray: [StarWarsPeopleDto] = []
        
        _ = baseDao.dbOpen()

        guard let result = baseDao.db.executeQuery(sql, withArgumentsIn: nil) else {return nil}
        while result.next() {
            
            let swPeopleDto = StarWarsPeopleDto()
            swPeopleDto.id = Int(result.int(forColumn: "id"))
            swPeopleDto.name = result.string(forColumn: "name")
            swPeopleDto.height = Int(result.int(forColumn: "height"))
            swPeopleDto.mass = Int(result.int(forColumn: "mass"))
            swPeopleDto.birth_year = result.string(forColumn: "birth_year")
            swPeopleDto.gender = result.string(forColumn: "gender")
            resultArray.append(swPeopleDto)
        }
        _ = baseDao.dbClose()
        return resultArray
    }
    
    // MARK:- UPDATE
    
    /// 指定idのレコードのheight, massを更新する
    func update(id: Int, height: Int, mass: Int) -> Bool {
        let sql = "UPDATE StarWarsPeople SET height = :HEIGHT, mass = :MASS WHERE id = :ID"
        let params = ["HEIGHT": height, "MASS": mass, "ID": id]
        
        _ = baseDao.dbOpen()
        let executeSQL = baseDao.db.executeUpdate(sql, withParameterDictionary: params)
        _ = baseDao.dbClose()
        return executeSQL
    }
    
    // MARK:- DELETE
    
    /// 指定idのレコードを削除する
    func delete(id: Int) -> Bool {
        let sql = "DELETE FROM StarWarsPeople WHERE id = ?"
        
        _ = baseDao.dbOpen()
        let executeSQL = baseDao.db.executeUpdate(sql, withArgumentsIn: [id])
        _ = baseDao.dbClose()
        return executeSQL
    }
}

// MARK:- BaseDao
extension StarWarsPeopleDao: BaseDao {}
