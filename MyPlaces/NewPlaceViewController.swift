//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Valentina Abramova on 30/07/2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    //    MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
    
}

// MARK: - Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    // скрываем клавиатуру по нажатию на done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
