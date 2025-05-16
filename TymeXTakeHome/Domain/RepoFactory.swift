//
//  RepoFactory.swift
//  123yo
//
//  Created by NguyenNV on 15/11/2023.
//

import Foundation

protocol PFactory {
    func getGithubUserRepo() -> PGithubUserRepo
}

class RepoFactory: PFactory {
    
    func getGithubUserRepo() -> PGithubUserRepo {
        return GitHubUserRepoImpl()
    }
}
