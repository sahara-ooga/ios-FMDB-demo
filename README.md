# ios-FMDB-demo
iOS FMDB2.6.2を利用したサンプル

## 1. PodFile

```
pod 'FMDB', '2.6.2'
```

## 2. import する
```
import FMDB
```
## 3 使い方
### 3.1 FMDatabaseクラスのインスタンスを生成
```swift
let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
 	.userDomainMask, 
 	true).last!.appendingPathComponent("foo.db")
var db: FMDatabase(path: dbPath)

```
### 3.2 データベースのオープン
```swift
func dbOpen() -> Bool {
    let isOpened = db.open()
    if !isOpened {
        fatalError("Failed to open database.")
    }
    return isOpened
}                        
```

### 3.3 データベースのクローズ
```swift
func dbClose() -> Bool {
    let isClosed = db.close()     
    if !isClosed {
        fatalError("Failed to close database.")
    }
    return isClosed
}

```

### 3.4 テーブル作成
```swift
/// StarWarsPeopleテーブルが存在しなければ、作成する
func createTable() -> Bool {
    let sql = "CREATE TABLE IF NOT EXISTS StarWarsPeople (id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name TEXT, 
    height INTEGER, 
    mass INTEGER, 
    birth_year TEXT, 
    gender TEXT)"
    
    _ = baseDao.dbOpen()
    
    // SQL実行
    let executeSQL = baseDao.db.executeUpdate(sql, 
    withArgumentsIn: nil)
    
    _ = baseDao.dbClose()
        
    return executeSQL
}

```

### 3.5 INSERT
```swift
/// StarWarsPeopleテーブルにレコードを追加する
func insert(swPeopleDto: StarWarsPeopleDto) -> Bool {
    let sql = "INSERT INTO StarWarsPeople(name, height, mass, birth_year, gender) 
    							VALUES(?, ?, ?, ?, ?)"
    
    // SQLの?の箇所に入れる要素の配列
    let swPeople: [Any] = [swPeopleDto.name,
                           swPeopleDto.height,
                           swPeopleDto.mass,
                           swPeopleDto.birth_year,
                           swPeopleDto.gender]
                           
    _ = baseDao.dbOpen()
    
    // withArgumentsIn: に配列をセットしてSQL実行
    let executeSQL = baseDao.db.executeUpdate(sql, withArgumentsIn: swPeople)
    
    _ = baseDao.dbClose()
    return executeSQL
}

```

### 3.6 SELECT
```swift
/// StarWarsPeopleテーブルのレコードを全件取得
func selectAll() -> [StarWarsPeopleDto]? {
    let sql = "SELECT * FROM StarWarsPeople"
        
    var resultArray: [StarWarsPeopleDto] = []
        
    _ = baseDao.dbOpen()
 
    // SQL実行
    guard let result = baseDao.db.executeQuery(sql, withArgumentsIn: nil) else {return nil}
    
    // SELECTで取得した件数分ループ
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

```

### 3.7 UPDATE
```swift
/// 指定idのレコードのheight, massを更新する
func update(id: Int, height: Int, mass: Int) -> Bool {
    let sql = "UPDATE StarWarsPeople SET height = :HEIGHT, mass = :MASS WHERE id = :ID"
    
    // 更新するcolumnの値の配列
    let params = ["HEIGHT": height, "MASS": mass, "ID": id]
        
    _ = baseDao.dbOpen()
    
    // withParameterDictionary: に配列をセットしてSQL実行
    let executeSQL = baseDao.db.executeUpdate(sql, withParameterDictionary: params)
    
    _ = baseDao.dbClose()
    return executeSQL
}

```

### 3.8 DELETE
```swift
/// 指定idのレコードを削除する
func delete(id: Int) -> Bool {
    let sql = "DELETE FROM StarWarsPeople WHERE id = ?"
        
    _ = baseDao.dbOpen()
    
    // ?の箇所に入れる要素の配列をセットして、SQL実行
    let executeSQL = baseDao.db.executeUpdate(sql, withArgumentsIn: [id])
    
    _ = baseDao.dbClose()
    return executeSQL
}

```

## 環境

|category | Version| 
|---|---|
| Swift | 3.0 |
| XCode | 8.2.1 |
| Cocoa Pods | 1.2.0 |
| iOS | 10.0〜 |

## OSS 

|OSS name | Version| 
|---|---|
| FMDB | 2.6.2 |
