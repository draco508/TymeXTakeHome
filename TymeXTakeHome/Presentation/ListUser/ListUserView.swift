//
//  ListUserView.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import UIKit
import Base_swift

class ListUserView: MVPUIView {

    @IBOutlet weak var tbvListUser: LoadMoreTableView!
    
    private var datasource = ListUserDataSource()
    
    
    override func onInitView() {
        super.onInitView()
        datasource.registerDataSource(tableView: tbvListUser)
        datasource.presenter = presenter
        
        tbvListUser.addLoadMore { [weak self] in
            guard let self = self else {return}
            self.presenter?.executeCommand(command: LoadMoreCmd())
        }
    }
    
    func updateListUser(_ users: [GitHubUser], _ hasLoadMore: Bool = false) {
        if !hasLoadMore {
            datasource.reset(data: users)
        } else {
            datasource.add(data: users)
        }
        
        tbvListUser.reloadData()
    }

    struct LoadMoreCmd: PCommand {}
}
