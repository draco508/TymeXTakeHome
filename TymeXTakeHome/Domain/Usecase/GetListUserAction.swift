//
//  GetListUserAction.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Foundation
import Base_swift

class GetListUserAction: Action<GetListUserAction.RV, DataPage<GitHubUser>> {
    
    override func onExecute(input: RV) throws -> DataPage<GitHubUser>? {
        return try RepoFactory.getGithubUserRepo().getListUser(perPage: input.perPage, since: input.since)
    }
    
    struct RV {
        let perPage: Int
        let since: Int
    }
}
