//
//  EntryController.swift
//  JournalCK
//
//  Created by Travis Halle on 5/10/21.
//

import Foundation
import CloudKit

class EntryController {
    //MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    static let shared = EntryController()
    var entries: [Entry] = []
    
    //MARK: - Cloud Functions
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        saveEntry(entry: newEntry, completion: completion)
    }
    
    func saveEntry(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { record, error in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
                print(error.localizedDescription)
            }
            
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record)
            else {return completion(.failure(.unableToDecode))}
            
            print("Entry saved successfully")
            self.entries.insert(savedEntry, at: 0)
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping (_ result: Result<[Entry]?, EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query,inZoneWith: nil) { records, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let records = records else {return completion(.failure(.unableToDecode))}
            print("Succesfully fetched all entries")
            
            let entries = records.compactMap(({Entry(ckRecord: $0)}))
            
            self.entries = entries
            completion(.success(entries))
        }
    }
}//End of class
