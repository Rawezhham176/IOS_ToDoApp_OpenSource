//
//  ViewController.swift
//  IOS_ToDoApp_OpenSource
//
//  Created by Rawezh on 22.11.21.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        loadItems()
        
       // if let items = defaults.array(forKey: "ToDoListArray") as? [Data] {
        //  itemArray = items
       // }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - CellMethod

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title

        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }


    
    //MARK - UITable Delaget
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")

        itemArray.remove(at: indexPath.row)
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//                    if cell.accessoryType == .checkmark {
//                        cell.accessoryType = .none
//                    } else {
//                        cell.accessoryType = .checkmark
//                    }
//                }
//                tableView.deselectRow(at: indexPath, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }


    //MARK - Add Item to the list

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        //1. Create the alert controller.
          let alert = UIAlertController(title: "Add ToDO", message: "Description", preferredStyle: .alert)


          //2. Add the text field. You can configure it however you need.
          alert.addTextField { (alertTextField) in
              textField.placeholder = "Tex"
              textField = alertTextField
          }

          // 3. Grab the value from the text field, and print it when the user clicks OK.
          alert.addAction(UIAlertAction(title: "Add Item", style: .default) { (action) in

              let newItem = Item(context: self.context)
              newItem.title = textField.text!
              self.itemArray.append(newItem)

              self.saveData()

          })

          // 4. Present the alert.
          self.present(alert, animated: true, completion: nil)
    }
    
//    func saveData() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: filePath!)
//        } catch {
//            print(error)
//        }
//
//    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
//    func loadItems(){
//        if let data = try? Data(contentsOf: filePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try  decoder.decode([ItemCodable].self, from: data)
//            } catch {
//                print("Error with decoder")
//            }
//
//        }
//    }


    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
    do {
       itemArray = try context.fetch(request)
    } catch {
        print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}



//MARK: - UISearchBarDelegate

extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sort]
        
        loadItems(with: request)
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
