//
//  VCExchangePopup.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/18.
//

import Foundation
import UIKit
import FirebaseDatabase

class VCExchangePopup:VCBase, FirebaseInterface, ValueEventListener{
    
    var vcExchange:VCExchange?
    var curCoinCode:String?
    var detailDelegate:((CoinVo) -> Void)?
    var mArray:Array<Finance> = Array<Finance>()
    
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var backBnt: UIImageView!
    @IBOutlet weak var totalAssetText: UILabel!
    @IBOutlet weak var mList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mList.dataSource = self
        mList.delegate = self
        mList.separatorInset.left = 0
        mList.separatorStyle = .none
        
        mArray = vcExchange?.mALLArray ?? Array<Finance>()
        mList.reloadData()
        
        initLayout()
    }
    
    fileprivate func initLayout(){
        viewLayout.clipsToBounds = true
        viewLayout.layer.cornerRadius = 30
        viewLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        backBnt.isUserInteractionEnabled = true
        backBnt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickEvent)))
        
        totalAssetText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(vcExchange!.totalAsset))) + " BTC"
    }
    
    @objc func onClickEvent(sender:UITapGestureRecognizer){
        if(sender.view == backBnt){
            self.dismiss(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appInfo.setBtcInterface(nil)
        appInfo.setKrwInterface(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appInfo.setBtcInterface(self)
        appInfo.setKrwInterface(self)
    }
    
    func onDataChange(market: String) {}
    
    func onDataChange(snapshot: DataSnapshot) {
        mList.reloadData()
    }
}


//MARK: - TableView
extension VCExchangePopup: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangePopupCell", for: indexPath) as? ExchangePopupCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        cell.coinNameText.text = ""
        cell.coinPriceText.text = "0"
        cell.coinCodeText.text = ""
        cell.krwPriceText.text = "0 KRW"
        
        if let item = mArray[indexPath.row] as? Finance{
            let krw = appInfo.krwValue! * DoubleDecimalUtils.newInstance(item.btcBalance)
            cell.krwPriceText.text = CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(decimal: krw, scale: 0)) + " KRW"
            
            if(item.marketStatus == "Y" || item.marketHupStatus == "Y" || item.coinCode == "BTC"){
                cell.coinCodeText.text = item.coinCode
                cell.coinPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.setMaximumFractionDigits(item.localBlnc!, scale: 8)))
            }
            cell.coinNameText.text = item.coinName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = mArray[indexPath.row] as? Finance{
            if self.curCoinCode == item.coinCode {
                self.dismiss(animated: true)
                return
            }
            
            let sb = UIStoryboard.init(name:"Exchange", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "VCExchangeDetail") as? VCExchangeDetail else {
                return
            }
            vc.vcExchange = vcExchange
            vc.coinCode = item.coinCode
            vc.coinName = item.coinName
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

class ExchangePopupCell: UITableViewCell{
    @IBOutlet weak var coinNameText: UILabel!
    @IBOutlet weak var coinCodeText: UILabel!
    @IBOutlet weak var coinPriceText: UILabel!
    @IBOutlet weak var krwPriceText: UILabel!
}
