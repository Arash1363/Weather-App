//
//  AddCityTableViewController.swift
//  Weathers-App
//
//  Created by Arash on 8/23/19.
//  Copyright © 2019 Arash. All rights reserved.
//

import UIKit
import CoreData

protocol ManageCityDelegate {
    func managedCity (city : String)
}

class AddCityTableViewController: UITableViewController {

    var cityArray = [City]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate : ManageCityDelegate! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadItem()
     
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cityArray.count
        
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCityItem", for: indexPath)
        
        let item = cityArray[indexPath.row]
        cell.textLabel?.text = item.name
        
     return cell
     
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cityName = cityArray[indexPath.row].name
        delegate?.managedCity(city: cityName!)
        saveItem()
        dismiss(animated: true, completion: nil)
        
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            context.delete(cityArray[indexPath.row])
            cityArray.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItem()
            
        }
    }

    @IBAction func addButtonCity(_ sender: UIBarButtonItem!) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New City", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add City", style: .default) { (action) in
            
            let cityName = City(context: self.context)
            cityName.name = textField.text!
        
            self.cityArray.append(cityName)
            
            self.saveItem()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create New City"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        }
    
    @IBAction func doneButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func saveItem() {
        
        do {
            try context.save()
        } catch  {
            print("Error in save context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItem() {
        
        let request : NSFetchRequest<City> = City.fetchRequest()
        
        do {
            
            cityArray = try context.fetch(request)
            
        } catch  {
            
            print("Error in fetch data \(error)")
        }
        
    }
    
    }


