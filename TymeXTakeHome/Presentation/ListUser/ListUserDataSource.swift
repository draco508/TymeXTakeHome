//
//  ListUserDataSource.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Foundation
import Base_swift

class ListUserDataSource: BaseTableViewDataSource {
    
    weak var presenter: PPresenter?
    
    override func getRegisteredCellTypes() -> [AnyClass] {
        return [UserCell.self]
    }
    
    override func getCellType(at position: Int) -> AnyClass {
        return UserCell.self
    }
    
    override func getDataForRow(position: Int) -> Any? {
        return data?[position]
    }
    
    override func getCount() -> Int {
        guard let d = data else {return 0}
        return d.count
    }
    
    
    override func initCell(cell: BaseTableCell, indexPath: IndexPath) {
        if let cell = cell as? UserCell {
            cell.onOpenUserLink = { [weak self] url in
                self?.presenter?.executeCommand(command: OpenHtmlUrlCmd(htmlUrl: url))
            }
            
            cell.setOnClickedListener { [weak self] in
                guard let self = self, let user = cell.currentData as? GitHubUser else {return}
                self.presenter?.executeCommand(command: ClickUserItemCmd(user: user))
            }
        }
    }
    
    struct OpenHtmlUrlCmd: PCommand {
        let htmlUrl: String
    }
    
    struct ClickUserItemCmd: PCommand {
        let user: GitHubUser
    }
}
