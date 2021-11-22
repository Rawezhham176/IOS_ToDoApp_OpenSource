//
//  ViewController.swift
//  IOS_ToDoApp_OpenSource
//
//  Created by Rawezh on 22.11.21.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = [Data()]

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Data()
        newItem.todo = "Hi"
        itemArray.append(newItem)
        if let items = defaults.array(forKey: "ToDoListArray") as? [Data] {
          itemArray = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.todo

        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()

        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                    if cell.accessoryType == .checkmark {
                        cell.accessoryType = .none
                    } else {
                        cell.accessoryType = .checkmark
                    }
                }
                tableView.deselectRow(at: indexPath, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }



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

              let newItem = Data()
              newItem.todo = textField.text!
              self.itemArray.append(newItem)

              self.defaults.set(self.itemArray, forKey: "ToDoListArray")

              self.tableView.reloadData()

          })

          // 4. Present the alert.
          self.present(alert, animated: true, completion: nil)
    }
}
