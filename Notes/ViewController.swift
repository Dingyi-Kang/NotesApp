//
//  ViewController.swift
//  Notes
//
//  Created by OSU App Center on 6/6/21.
//

import UIKit

class ViewController: UIViewController, DetailViewProtocol {
    func reloadData() {
        notesModel.getNote()
        self.tableView.reloadData()
    }
    

    @IBOutlet weak var starFilterButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let notesModel = NotesModel()
    
    var notes = [Note]()
    
    var FilterMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilterMode = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        notesModel.delegate = self
        
        notesModel.getNote()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailNoteViewController
        
        //detailViewController.delegate = self
        
        if tableView.indexPathForSelectedRow != nil {
            detailViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            //very important
            //deselect row
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        else {
//            detailViewController.bodyView.text = ""
//            detailViewController.titleView.text = ""
            
            
        }
        detailViewController.notesModel = self.notesModel
        
    }
    
    
    @IBAction func starFilterTapped(_ sender: Any) {
        
        FilterMode.toggle()
        
        let imageName = FilterMode ? "star.fill" : "star"
        starFilterButton.image = UIImage(systemName: imageName)
        // TODO: add bool and change getNote
        notesModel.getNote(self.FilterMode)
        
    }
    


}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1) as? UILabel
        let contentLabel = cell.viewWithTag(2) as? UILabel
        
        titleLabel?.text = notes[indexPath.row].title
        contentLabel?.text = notes[indexPath.row].bodyContent
        
        return cell
    }
    
}

extension ViewController: notesModelProtocol{
    func retrieveNote(notes: [Note]) {
        
        self.notes = notes
        
        tableView.reloadData()
    }
    
}
