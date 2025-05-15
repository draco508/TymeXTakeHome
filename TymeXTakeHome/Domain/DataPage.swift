//
//  DataPage.swift
//  123yo
//
//  Created by DracoNguyen on 17/7/24.
//

import Foundation

class DataPage<T> {
    var dataList: [T] = []
    var currentPage: Int = -1
    var lastPage: Int = 0
    var perPage: Int = 0
    var hasNextPage: Bool = false
}
