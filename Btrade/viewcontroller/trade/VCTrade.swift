//
//  VCTrade.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/11.
//

import UIKit

class VCTrade: VCBase {

    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickedSearch(_ sender: Any) {
        let SIZE = 150.0
        self.searchField.translatesAutoresizingMaskIntoConstraints = true
        self.searchBtn.translatesAutoresizingMaskIntoConstraints = true
        if(searchField.frame.size.width <= (SIZE / 2)){
            searchBtn.frame.origin.x = searchBtn.frame.origin.x - SIZE
            searchField.frame.origin.x = searchField.frame.origin.x - SIZE
            searchField.frame.size.width = searchField.frame.size.width + SIZE
            searchField.becomeFirstResponder()
        }else{
            searchBtn.frame.origin.x = searchBtn.frame.origin.x + SIZE
            searchField.frame.origin.x = searchField.frame.origin.x + SIZE
            searchField.frame.size.width = searchField.frame.size.width - SIZE
            searchField.text = ""
        }
    }
}
