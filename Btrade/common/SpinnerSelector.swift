//
//  SpinnerSelector.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/02.
//

import Foundation
import DropDown

class SpinnerSelector{
    let WHERE:Int!
    let mArray:Array<KycVo.SMAP>!
    let interface:SpinnerSelectorInterface!
    let dropdown = DropDown()
    var itemList:[String]!
    var textField: AnchorView
    
    init(_ interface:SpinnerSelectorInterface,_ textField: AnchorView, _ array:Array<KycVo.SMAP>, _ WHERE:Int){
        self.WHERE = WHERE
        self.mArray = array
        self.interface = interface
        self.textField = textField
    }
    
    func start(){
        initUI()
        setDropdown()
    }
    
    // DropDown UI 커스텀
    func initUI() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = .darkGray // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        dropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        
        itemList = [String]()
        
        for item in mArray{
            itemList.append(item.key)
        }
    }
    
    func setDropdown() {
        // dataSource로 ItemList를 연결
        dropdown.dataSource = itemList
        dropdown.anchorView = textField
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        
        // Item 선택 시 처리
        dropdown.selectionAction = { (index, item) in
            self.interface.onSelect(self.mArray[index], self.WHERE!)
        }
        
        // 취소 시 처리
//        dropdown.cancelAction = { [weak self] in
//            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
//            
//        }
        dropdown.show()
    }
}
