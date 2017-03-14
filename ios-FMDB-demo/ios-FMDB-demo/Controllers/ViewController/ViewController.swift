//
//  ViewController.swift
//  ios-FMDB-demo
//
//  Created by OkuderaYuki on 2017/03/13.
//  Copyright © 2017年 YukiOkudera. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    let starWarsPeopleDao = StarWarsPeopleDao()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.create()
        self.insert()
        self.insertUsingTransaction()
        self.update()
        self.delete()
    }
    
    /// StarWarsPeopleテーブルを作成する
    private func create() {
        let success = starWarsPeopleDao.createTable()
        if success {
            print("StarWarsPeopleテーブル作成成功")
        } else {
            print("StarWarsPeopleテーブル作成失敗")
        }
    }
    
    /// StarWarsPeopleテーブルに新規レコードを1件追加する
    private func insert() {
        let swPeopleDto = StarWarsPeopleDto()
        swPeopleDto.name = "Darth Vader"
        swPeopleDto.height = 202
        swPeopleDto.mass = 136
        swPeopleDto.birth_year = "41.9BBY"
        swPeopleDto.gender = "male"
        
        let success = starWarsPeopleDao.insert(swPeopleDto: swPeopleDto)
        if success {
            print("INSERT成功")
            self.select()
        } else {
            print("INSERT失敗")
        }
    }
    
    /// StarWarsPeopleテーブルに新規レコードを複数件追加する
    private func insertUsingTransaction() {
        
        var swPeopleDtos: [StarWarsPeopleDto] = []
        
        // append Luke Skywalker
        let swPeopleDto1 = StarWarsPeopleDto()
        swPeopleDto1.name = "Luke Skywalker"
        swPeopleDto1.height = 172
        swPeopleDto1.mass = 77
        swPeopleDto1.birth_year = "19BBY"
        swPeopleDto1.gender = "male"
        swPeopleDtos.append(swPeopleDto1)
        
        // append C-3PO
        let swPeopleDto2 = StarWarsPeopleDto()
        swPeopleDto2.name = "C-3PO"
        swPeopleDto2.height = 167
        swPeopleDto2.mass = 75
        swPeopleDto2.birth_year = "112BBY"
        swPeopleDto2.gender = "n/a"
        swPeopleDtos.append(swPeopleDto2)
        
        // append R2-D2
        let swPeopleDto3 = StarWarsPeopleDto()
        swPeopleDto3.name = "R2-D2"
        swPeopleDto3.height = 96
        swPeopleDto3.mass = 32
        swPeopleDto3.birth_year = "33BBY"
        swPeopleDto3.gender = "n/a"
        swPeopleDtos.append(swPeopleDto3)
        
        let success = starWarsPeopleDao.insert(swPeopleDtos: swPeopleDtos)
        if success {
            print("INSERT成功")
            self.select()
        } else {
            print("INSERT失敗")
        }
    }
    
    /// idを指定して、StarWarsPeopleテーブルの既存レコードのheight, massを更新する
    private func update() {
        let success = starWarsPeopleDao.update(id: 1, height: 200, mass: 999)
        if success {
            print("UPDATE成功")
            self.select()
        } else {
            print("UPDATE失敗")
        }
    }
    
    /// idを指定して、StarWarsPeopleテーブルの既存レコードを削除する
    private func delete() {
        let success = starWarsPeopleDao.delete(id: 2)
        if success {
            print("DELETE成功")
            self.select()
        } else {
            print("DELETE失敗")
        }
    }
    
    /// StarWarsPeopleテーブルのレコードを全件取得し、ログ出力する
    private func select() {
        if let selectAll = starWarsPeopleDao.selectAll() {
            print("|id|name|height|mass|birth_year|gender|")
            selectAll.forEach {
                print("|\($0.id)|\($0.name)|\($0.height)|\($0.mass)|\($0.birth_year)|\($0.gender)|")
            }
        }
    }
}

