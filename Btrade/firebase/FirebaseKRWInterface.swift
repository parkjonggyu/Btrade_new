//
//  FirebaseKRWInterface.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/05.
//

import Foundation
import FirebaseDatabase

protocol FirebaseKRWInterface{
    func onDataChangeKRW(dataSnapshot:DataSnapshot)
    func onDataChangeBTC(dataSnapshot:DataSnapshot)
}
