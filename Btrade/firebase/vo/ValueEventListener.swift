//
//  ValueEventListener.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/09/29.
//

import Foundation
import FirebaseDatabase

protocol ValueEventListener{
    func onDataChange(snapshot:DataSnapshot)
}
