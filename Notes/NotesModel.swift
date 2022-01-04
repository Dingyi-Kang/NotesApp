//
//  NotesModel.swift
//  Notes
//
//  Created by OSU App Center on 6/6/21.
//

import Foundation
import Firebase

protocol notesModelProtocol {
    func retrieveNote(notes: [Note])
}

class NotesModel {
    
    var delegate:notesModelProtocol?
    
    var listener:ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func getNote(_ FilterMode:Bool = false){
        
        
        listener?.remove()
        
        
        let db = Firestore.firestore()
        
        var query:Query = db.collection("notes")
        
        if FilterMode{
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        listener = query.addSnapshotListener { (snapShot, error) in
            
            if snapShot != nil && error == nil {
                
                var notes = [Note]()
                
                for doc in snapShot!.documents {
                    
                    let createDate = Timestamp.dateValue(doc["createDate"] as! Timestamp)()
                    
                    let updataDate = Timestamp.dateValue(doc["updateDate"] as! Timestamp)()
                    
                    let note = Note(docID: doc["docID"] as! String, title: doc["title"] as! String, bodyContent: doc["bodyContent"] as! String, isStarred: doc["isStarred"] as! Bool, createDate: createDate, updateDate: updataDate)
                    
                    notes.append(note)
                    
                    //move this outter
                    DispatchQueue.main.async {
                        self.delegate?.retrieveNote(notes: notes)
                    }
                    
                }
                
            }
            
            
        }// end of the trailing closure
        
    }
    
    func deleteNote (_ n : Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docID).delete()
        
    }
    
    func saveNote (_ n:Note){
        
        let db = Firestore.firestore()
        db.collection("notes").document(n.docID).setData(noteToDict(n))
        
    }
    
    func saveStarCondition(_ n : Note){
        let db = Firestore.firestore()
        db.collection("notes").document(n.docID).updateData(["isStarred" : n.isStarred])
        
    }
    
    func noteToDict (_ n:Note) -> [String:Any] {
        var dict = [String:Any]()
        
        dict["docID"] = n.docID
        dict["title"] = n.title
        dict["bodyContent"] = n.bodyContent
        dict["isStarred"] = n.isStarred
        dict["createDate"] = n.createDate
        dict["updateDate"] = n.updateDate
        
        return dict
        
    }
    
    
}
