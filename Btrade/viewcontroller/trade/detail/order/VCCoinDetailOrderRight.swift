//
//  VCCoinDetailOrderRight.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/01.
//

import Foundation
import UIKit
import Alamofire
import FirebaseDatabase

class VCCoinDetailOrderRight: VCBase{
    var adapter:VCCoinDetailOrderRightAdapter?
    
    @IBOutlet weak var item1Back: UIView!
    @IBOutlet weak var item1Text: UILabel!
    
    
    @IBOutlet weak var item2Back: UIView!
    @IBOutlet weak var item2Text: UILabel!
    
    @IBOutlet weak var item3Back: UIView!
    @IBOutlet weak var item3Text: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedItem(0)
        
        item1Back.isUserInteractionEnabled = true
        item1Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item2Back.isUserInteractionEnabled = true
        item2Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item3Back.isUserInteractionEnabled = true
        item3Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item1Text.isUserInteractionEnabled = true
        item1Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item2Text.isUserInteractionEnabled = true
        item2Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
        item3Text.isUserInteractionEnabled = true
        item3Text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.objcItem)))
    }
    
    
    @objc func objcItem(sender:UITapGestureRecognizer){
        if(sender.view == item1Back || sender.view == item1Text){
            adapter?.setViewcontrollersFromIndex(index: 0)
        }else if(sender.view == item2Back || sender.view == item2Text){
            adapter?.setViewcontrollersFromIndex(index: 1)
        }else if(sender.view == item3Back || sender.view == item3Text){
            adapter?.setViewcontrollersFromIndex(index: 2)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VCCoinDetailOrderRightAdapter {
            adapter = vc
            adapter?.completeHandler = { idx in
                self.selectedItem(idx)
            }
        }
    }
    
    fileprivate func selectedItem(_ idx:Int){
        initItem()
        
        if(idx == 0){
            item1Back.backgroundColor = .white
            item1Text.textColor = UIColor(named: "HogaPriceRed")
        }else if(idx == 1){
            item2Back.backgroundColor = .white
            item2Text.textColor = UIColor(named: "HogaPriceBlue")
        }else if(idx == 2){
            item3Back.backgroundColor = .white
            item3Text.textColor = UIColor(named: "HogaPriceGray")
        }
    }
    
    fileprivate func initItem(){
        item1Back.backgroundColor = UIColor(named: "OrderItemBack")
        item2Back.backgroundColor = UIColor(named: "OrderItemBack")
        item3Back.backgroundColor = UIColor(named: "OrderItemBack")
        item1Text.textColor = UIColor(named: "OrderItemText")
        item2Text.textColor = UIColor(named: "OrderItemText")
        item3Text.textColor = UIColor(named: "OrderItemText")
    }
}

extension VCCoinDetailOrderRight: FirebaseInterface, ValueEventListener{
    func onDataChange(market: String) {
        if let sender = adapter?.getCurrentView() as? FirebaseInterface{
            sender.onDataChange(market: market)
        }
    
    }
    
    func onDataChange(snapshot: DataSnapshot) {
        if let sender = adapter?.getCurrentView() as? ValueEventListener{
            sender.onDataChange(snapshot: snapshot)
        }
    }
}
