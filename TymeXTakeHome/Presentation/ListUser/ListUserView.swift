//
//  ListUserView.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import UIKit
import Base_swift

class ListUserView: MVPUIView {

    @IBOutlet weak var tbvListUser: UITableView!
    
    private var datasource = ListUserDataSource()
    
    
    override func onInitView() {
        super.onInitView()
        datasource.registerDataSource(tableView: tbvListUser)
        datasource.presenter = presenter
        
    }
    
    func updateListUser(_ users: [GitHubUser]) {
        datasource.reset(data: users)
        tbvListUser.reloadData()
    }

}
