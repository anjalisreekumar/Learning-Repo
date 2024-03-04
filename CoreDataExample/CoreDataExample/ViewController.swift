//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Bridge on 04/03/24.
//

import UIKit

class ViewController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        
        title = "Todo List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        
    }
    
    func reloadData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @objc func addNewItem(){
        
        let ac = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] action in
            guard let note = ac?.textFields![0].text else {return}
            self?.createItems(name: note)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }

    
    func getAllItems(){
        do {
           models = try context.fetch(ToDoListItem.fetchRequest())
            reloadData()
        }
        catch {
            //error
        }
    }
    func createItems(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.created_at = Date()
        do {
            try context.save()
            getAllItems()
        }
        catch {
            //error
        }
        
    }
    func deleteItem(item: ToDoListItem){
        context.delete(item)
        do {
            try context.save()
           getAllItems()
        }
        catch {
            //error
        }
        
    }
    func updateItem(newName: String , item: ToDoListItem){
        item.name = newName
        do {
          try context.save()
           getAllItems()
        }
        catch {
            //error
        }
    }
    
    //tableview functions

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]

        let alertSheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Edit", style: .default){[weak self] _ in
          
            let ac = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.textFields![0].text = item.name
            let saveAction = UIAlertAction(title: "Save", style: .default) {[weak self, weak ac] _ in
                guard let note = ac?.textFields![0].text else {return}
                self?.updateItem(newName: note, item: item)
            }
            ac.addAction(saveAction)
            self?.present(ac, animated: true)
        })
       
        alertSheet.addAction(UIAlertAction(title: "Delete", style: .destructive){[weak self] _ in
            self?.deleteItem(item: item)
        })
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertSheet, animated: true)
        
    }
    
}

