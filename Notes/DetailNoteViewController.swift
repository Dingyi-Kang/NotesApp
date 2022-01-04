//
//  DetailNoteViewController.swift
//  Notes
//
//  Created by OSU App Center on 6/8/21.
//

import UIKit

protocol DetailViewProtocol{
    func reloadData()
}

class DetailNoteViewController: UIViewController {
    
    var note:Note?
    
    var notesModel:NotesModel?
    
    //var delegate:DetailViewProtocol?
    
    @IBOutlet weak var titleView: UITextField!
    
    @IBOutlet weak var bodyView: UITextView!
    
    @IBOutlet weak var buttonImage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            titleView.text = note!.title
            bodyView.text = note!.bodyContent
            if note!.isStarred {
                buttonImage.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            else {
                buttonImage.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        else{
            titleView.text = ""
            bodyView.text = ""
            buttonImage.setImage(UIImage(systemName: "star"), for: .normal)
            
        }
        
        
    }
    
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        if note != nil{
            notesModel?.deleteNote(self.note!)
        }
        
        //delegate?.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if note != nil{
            //update an existing note
            self.note?.title = titleView.text ?? ""
            self.note?.bodyContent = bodyView.text ?? ""
            self.note?.updateDate = Date()
            
        }
        else {
            //for a brand new note
            let note = Note(docID: UUID().uuidString, title: titleView.text ?? "", bodyContent: bodyView.text ?? "", isStarred: false, createDate: Date(), updateDate: Date())
            self.note = note
        }
        
        notesModel?.saveNote(self.note!)
        //delegate?.reloadData()// no need, cuz the listerner for the change in dataBase will call retrieve(), which includes update the notes and call tableView.reload
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func starButtonTapped(_ sender: Any) {
        
        if note != nil {
        self.note!.isStarred.toggle()
            
            let imageName = self.note!.isStarred ? "star.fill" : "star"
            buttonImage.setImage(UIImage(systemName: imageName), for: .normal)
            saveStarCondition(self.note!)
            
        }
        
    }
    
    func saveStarCondition(_ n:Note){
        
        notesModel?.saveStarCondition(n)
        
    }
    
    
}
