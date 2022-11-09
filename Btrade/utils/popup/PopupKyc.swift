//
//  PopupKyc.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/11/05.
//

import Foundation
import UIKit
import DropDown

class PopupKyc:UIViewController{
    var mArray:Array<KycVo.SMAP>?
    var delegate:((KycVo.SMAP) -> ())?
    var titleString:String?
    
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    fileprivate func setLayout(){
        popupLayout.clipsToBounds = true
        popupLayout.layer.cornerRadius = 30
        popupLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        
        if let s = titleString{
            titleText.text = s
        }
    }
    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            self.dismiss(animated: true)
        }
    }
}

//MARK: - TableView
class PopupKycCell: UITableViewCell{
    @IBOutlet weak var contentText: UILabel!
    
}

extension PopupKyc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopupKycCell", for: indexPath) as? PopupKycCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if let item = mArray?[indexPath.row] as? KycVo.SMAP{
            cell.contentText.text = item.key
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = mArray?[indexPath.row] as? KycVo.SMAP{
            if let d = delegate{
                d(item)
            }
            self.dismiss(animated: true)
        }
    }
}

