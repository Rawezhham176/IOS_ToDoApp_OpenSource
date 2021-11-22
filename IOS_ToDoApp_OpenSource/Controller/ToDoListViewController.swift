//
//  ViewController.swift
//  IOS_ToDoApp_OpenSource
//
//  Created by Rawezh on 22.11.21.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = [Item()]
    
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        cell.textLabel?.text = item.todo

        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }


    
    //MARK - UITable Delaget
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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

              let newItem = Item()
              newItem.todo = textField.text!
              self.itemArray.append(newItem)

              self.saveData()
              self.tableView.reloadData()

          })

          // 4. Present the alert.
          self.present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: filePath!)
        } catch {
            print(error)
        }

    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try  decoder.decode([Item].self, from: data)
            } catch {
                print("Error with decoder")
            }
            
        }
    }
}
