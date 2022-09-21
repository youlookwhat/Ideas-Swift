//
//  DatabaseUtil.swift
//  quote
//
//  Created by 景彬 on 2022/9/1.
//  Copyright © 2022 景彬. All rights reserved.
//

import Foundation
import RealmSwift

// 继承 object一定要有属性
class DatabaseUtil {

/// 配置数据库
    public class func configRealm() {
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
        let dbVersion : UInt64 = 1
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
//        Realm.asyncOpen { (realm, error) in
//                    if let _ = realm {
//                        print("Realm 服务器配置成功!")
//                    }else if let error = error {
//                        print("Realm 数据库配置失败：\(error.localizedDescription)")
//                    }
//                }
        Realm.asyncOpen(configuration: config, callbackQueue: .main) { result in
                switch result {
                case .failure(let error):
                    print("Async open failed: \(error)")
                                       
                case .success(let realm):
                    print("Async open success")
                }
            }

    }
    
    private class func getDB() -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
    }

}


/// 增
extension DatabaseUtil {
   
    public class func insertNote(by noteBean : NoteBean) -> Void {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(noteBean)
        }
        print(defaultRealm.configuration.fileURL ?? "")
    }
    
    /// 获取 所保存的 Note
       public class func getNotes() -> Results<NoteBean> {
           let defaultRealm = self.getDB()
           return defaultRealm.objects(NoteBean.self)
       }
    
    /// 获取 所保存的 Note 降序
       public class func getSortedNotes() -> Results<NoteBean> {
           let defaultRealm = self.getDB()
           return defaultRealm.objects(NoteBean.self).sorted(byKeyPath: "id", ascending: false)
       }
    
    
    /// 获取 指定id (主键) 的 Note
        public class func getNote(from id : Int) -> NoteBean? {
            let defaultRealm = self.getDB()
            return defaultRealm.object(ofType: NoteBean.self, forPrimaryKey: id)
        }

    /// 更新单个 Note
        public class func updateNote(note : NoteBean) {
            let defaultRealm = self.getDB()
            try! defaultRealm.write {
                defaultRealm.add(note, update: .modified)
            }
        }

        /// 删除单个 note
        public class func deleteNote(note : NoteBean) {
            let defaultRealm = self.getDB()
            try! defaultRealm.write {
                defaultRealm.delete(note)
            }
        }
        
        /// 删除多个 note
        public class func deleteNotes(notes : Results<NoteBean>) {
            let defaultRealm = self.getDB()
            try! defaultRealm.write {
                defaultRealm.delete(notes)
            }
        }

   
    

  
}


