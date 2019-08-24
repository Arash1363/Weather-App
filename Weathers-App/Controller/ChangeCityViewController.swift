//
//  ChangeCityViewController.swift
//  Weathers-App
//
//  Created by Arash on 8/22/19.
//  Copyright © 2019 Arash. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    
    func setCity(city : String)
    
}

class ChangeCityViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var delegate : ChangeCityDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SetCityButton(_ sender: Any) {
    
    delegate?.setCity(city: textField.text!)
    dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
