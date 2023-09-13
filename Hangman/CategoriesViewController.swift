//
//  CategoriesViewController.swift
//  Hangman
//
//  Created by Ak on 08/06/23.
//

import UIKit

class CategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnNewPage() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(next, animated: true, completion: nil)
    }

}
