//
//  GetListUserAction.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Foundation
import Base_swift

class GetListUserUsecase: Action<GetListUserUsecase.RV, [GitHubUser]> {
    
    private var repository: PGithubUserRepo
    
    init(_ repository: PGithubUserRepo = GitHubUserRepoImpl()) {
        self.repository = repository
    }
    
    override func onExecute(input: RV) throws -> [GitHubUser] {
        return try repository.getListUser(perPage: input.perPage, since: input.since)
    }
    
    struct RV {
        let perPage: Int
        let since: Int
    }
}
