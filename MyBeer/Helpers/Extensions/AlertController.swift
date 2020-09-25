//
//  AlertController.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 25.09.2020.
//

import UIKit

// MARK: - Alert Controller extension

extension UIViewController {
    
    func alert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(doneButton)
        present(alertController, animated: true, completion: nil)
    }
}
