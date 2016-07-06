//
//  DatabaseManager.swift
//
//  Created by Connor Murray on 5/26/16.
//

import SQLite

class DatabaseManager {
    let path = "\(NSHomeDirectory())/Library/Messages/"
    let file = "chat.db"
    var db:Connection!
    
    func deleteByGUID(guid: String) {
        do {
            try db.execute(
                "DELETE FROM attachment " +
                    "WHERE guid='" + guid + "';"
            )
        }
        catch let error as NSError {
            print("Here is the error: \(error)")
        }

    }
    func prepareForDeletes() {
        do {
            try db.execute(
                "drop trigger before_delete_on_attachment;" +
                "drop trigger after_delete_on_attachment;")
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    func finishedDeleting() {
        do {
            try db.execute(
                "CREATE TRIGGER before_delete_on_attachment BEFORE DELETE ON attachment BEGIN   SELECT " +  "before_delete_attachment_path(OLD.ROWID, OLD.guid); END;" +
                "CREATE TRIGGER after_delete_on_attachment AFTER DELETE ON attachment BEGIN   SELECT " + "delete_attachment_path(OLD.filename); END;")
        }
        catch let error as NSError {
            print("\(error)")
        }
    }
    
    init() {
        do {
            db = try Connection(path + file)
        }
        catch {
            print("Database connection failed")
        }
    }
    deinit {
        
    }
}
