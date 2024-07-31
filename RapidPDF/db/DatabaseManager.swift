import SQLite
import Foundation

class DatabaseManager {
    private var db: Connection?
    private let table = Table("records")
    
    // 定义表格字段
    private let id = Expression<Int64>("id")
    private let url = Expression<String>("url")
    private let type = Expression<Int>("type")
    private let date = Expression<String>("date") // 修改为 String 类型

    static let shared = DatabaseManager() // 单例模式

    private init() {
        do {
            // 获取文档目录并创建数据库文件的路径
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("translations").appendingPathExtension("sqlite3")
            
            // 连接数据库
            db = try Connection(fileUrl.path)
            
            // 创建表格
            try createTable()
        } catch {
            print("无法连接到数据库: \(error)")
        }
    }
    
    private func createTable() throws {
        // 创建表格
        try db?.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(url)
            t.column(type)
            t.column(date)
        })
    }
    
    func insert(url: String, type: Int, date: String) {
        do {
            let insert = table.insert(self.url <- url, self.type <- type, self.date <- date)
            try db?.run(insert)
        } catch {
            print("插入记录失败: \(error)")
        }
    }
    
    func delete(id: Int64) {
        do {
            let record = table.filter(self.id == id)
            try db?.run(record.delete())
        } catch {
            print("删除记录失败: \(error)")
        }
    }
    
    func update(id: Int64, url: String, type: Int, date: String) {
        do {
            let record = table.filter(self.id == id)
            try db?.run(record.update(self.url <- url, self.type <- type, self.date <- date))
        } catch {
            print("更新记录失败: \(error)")
        }
    }
    
    func fetchAllRecords() -> [Record] {
        var records: [Record] = []
        do {
            // 使用 prepare() 进行查询并确保其返回的类型正确
            let query = table
            for row in try db?.prepare(query) ?? AnySequence<Row>([]) {
                let id = row[self.id]
                let url = row[self.url]
                let type = row[self.type]
                let date = row[self.date]
                records.append(Record(id: id, url: url, type: type, date: date))
            }
        } catch {
            print("查询记录失败: \(error)")
        }
        return records
    }
    
    func fetchRecords(byType typeValue: Int) -> [Record] {
        var records: [Record] = []
        do {
            // 使用 filter() 和 prepare() 进行查询
            let query = table.filter(self.type == typeValue)
            for row in try db?.prepare(query) ?? AnySequence<Row>([]) {
                let id = row[self.id]
                let url = row[self.url]
                let type = row[self.type]
                let date = row[self.date]
                records.append(Record(id: id, url: url, type: type, date: date))
            }
        } catch {
            print("根据 type 查询记录失败: \(error)")
        }
        return records
    }
    
    func fetchLatestRecord() -> Record? {
        do {
            // 获取最新记录的查询
            let query = table.order(id.desc).limit(1)
            if let row = try db?.pluck(query) {
                let id = row[self.id]
                let url = row[self.url]
                let type = row[self.type]
                let date = row[self.date]
                return Record(id: id, url: url, type: type, date: date)
            }
        } catch {
            print("查询最新记录失败: \(error)")
        }
        return nil
    }
    
   
}
