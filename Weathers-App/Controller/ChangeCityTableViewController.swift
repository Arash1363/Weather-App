//
//  ChangeCityViewController.swift
//  Weathers-App
//
//  Created by Arash on 8/22/19.
//  Copyright © 2019 Arash. All rights reserved.
//

import UIKit
import CoreData

protocol ChangeCityDelegate {
    
    func setCity(city : String)
    
}

class ChangeCityTableViewController: UITableViewController  {
    
    var delegate : ChangeCityDelegate! = nil
    let addCity = AddCityTableViewController()
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        //addCity.delegate = self
        managedCity()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addCity.cityArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCityItem", for: indexPath)
        
        let item = addCity.cityArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        addCity.cityArray[indexPath.row].done = !addCity.cityArray[indexPath.row].done
    
        let cityName = addCity.cityArray[indexPath.row].name
        addCity.saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
    }

    //MARK : - Manage City Protocol Implementation
    
    func managedCity() {
        let request : NSFetchRequest<City> = City.fetchRequest()
        do{
        addCity.cityArray = try addCity.context.fetch(request)
        }catch{
            print("Error in fetch data \(error)")
        }
    }
    
}
