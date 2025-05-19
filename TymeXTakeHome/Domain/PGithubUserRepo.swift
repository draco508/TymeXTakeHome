//
//  PGithubUserRepo.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Foundation

protocol PGithubUserRepo: PRepo {
    func getListUser(perPage: Int, since: Int) throws -> [GitHubUser]
    func getUserDetail(userName: String) throws -> GitHubUser
}
