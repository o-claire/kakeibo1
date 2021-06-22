//
//  ShareData.swift
//  20210608
//
//  Created by 岡部 紅有 on 2021/06/22.
//

import Foundation

//共有するデータ
class ShareData: ObservableObject {
//    @Published var yesNo = false
//    @Published var num = 1
    @Published var mokuhyo = ""
    @Published var selected = 0
    @Published var date = Date()
}
