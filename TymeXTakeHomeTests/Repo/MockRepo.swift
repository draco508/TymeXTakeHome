//
//  MockRepo.swift
//  TymeXTakeHomeTests
//
//  Created by  NguyenNV on 19/5/25.
//

import Base_swift
import XCTest
@testable import TymeXTakeHome


enum DataStage: Int {
    case full = 0
    case notFull = 1
    case fail = -1
}

class MockRepo: PGithubUserRepo {
    
    private var stage: DataStage
    
    init(stage: DataStage) {
        self.stage = stage
    }
    
    func getListUser(perPage: Int, since: Int) throws -> [TymeXTakeHome.GitHubUser] {
        
        switch stage {
        case .fail:
            throw BaseError(code: "404", message: "Not found")
        case .full:
            
            guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
                throw BaseError(code: "404", message: "Not found")
            }
            
            do {
                let data = try Data(contentsOf: url)
                let users = try JSONDecoder().decode([GitHubUserData].self, from: data)
                return users.compactMap({
                    return GithubUserDataToGithubUser().convert(input: $0)
                })
            } catch {
                print("❌ Error decoding JSON: \(error)")
                throw BaseError(code: "404", message: "Not found")
            }
            
        case .notFull:
          
            let mockJSON = """
           
           [
               {
                   "login": "jvantuyl",
                   "id": 101,
                   "node_id": "MDQ6VXNlcjEwMQ==",
                   "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
                   "gravatar_id": "",
                   "url": "https://api.github.com/users/jvantuyl",
                   "html_url": "https://github.com/jvantuyl",
                   "followers_url": "https://api.github.com/users/jvantuyl/followers",
                   "following_url": "https://api.github.com/users/jvantuyl/following{/other_user}",
                   "gists_url": "https://api.github.com/users/jvantuyl/gists{/gist_id}",
                   "starred_url": "https://api.github.com/users/jvantuyl/starred{/owner}{/repo}",
                   "subscriptions_url": "https://api.github.com/users/jvantuyl/subscriptions",
                   "organizations_url": "https://api.github.com/users/jvantuyl/orgs",
                   "repos_url": "https://api.github.com/users/jvantuyl/repos",
                   "events_url": "https://api.github.com/users/jvantuyl/events{/privacy}",
                   "received_events_url": "https://api.github.com/users/jvantuyl/received_events",
                   "type": "User",
                   "user_view_type": "public",
                   "site_admin": false
               },
               {
                   "login": "BrianTheCoder",
                   "id": 102,
                   "node_id": "MDQ6VXNlcjEwMg==",
                   "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
                   "gravatar_id": "",
                   "url": "https://api.github.com/users/BrianTheCoder",
                   "html_url": "https://github.com/BrianTheCoder",
                   "followers_url": "https://api.github.com/users/BrianTheCoder/followers",
                   "following_url": "https://api.github.com/users/BrianTheCoder/following{/other_user}",
                   "gists_url": "https://api.github.com/users/BrianTheCoder/gists{/gist_id}",
                   "starred_url": "https://api.github.com/users/BrianTheCoder/starred{/owner}{/repo}",
                   "subscriptions_url": "https://api.github.com/users/BrianTheCoder/subscriptions",
                   "organizations_url": "https://api.github.com/users/BrianTheCoder/orgs",
                   "repos_url": "https://api.github.com/users/BrianTheCoder/repos",
                   "events_url": "https://api.github.com/users/BrianTheCoder/events{/privacy}",
                   "received_events_url": "https://api.github.com/users/BrianTheCoder/received_events",
                   "type": "User",
                   "user_view_type": "public",
                   "site_admin": false
               },
               {
                   "login": "freeformz",
                   "id": 103,
                   "node_id": "MDQ6VXNlcjEwMw==",
                   "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
                   "gravatar_id": "",
                   "url": "https://api.github.com/users/freeformz",
                   "html_url": "https://github.com/freeformz",
                   "followers_url": "https://api.github.com/users/freeformz/followers",
                   "following_url": "https://api.github.com/users/freeformz/following{/other_user}",
                   "gists_url": "https://api.github.com/users/freeformz/gists{/gist_id}",
                   "starred_url": "https://api.github.com/users/freeformz/starred{/owner}{/repo}",
                   "subscriptions_url": "https://api.github.com/users/freeformz/subscriptions",
                   "organizations_url": "https://api.github.com/users/freeformz/orgs",
                   "repos_url": "https://api.github.com/users/freeformz/repos",
                   "events_url": "https://api.github.com/users/freeformz/events{/privacy}",
                   "received_events_url": "https://api.github.com/users/freeformz/received_events",
                   "type": "User",
                   "user_view_type": "public",
                   "site_admin": false
               }
           ]
           """
            
            
            if let jsonData = mockJSON.data(using: .utf8) {
                let users = try JSONDecoder().decode([GitHubUserData].self, from: jsonData)
                
                return users.compactMap({
                    return GithubUserDataToGithubUser().convert(input: $0)
                })
            } else {
                throw BaseError(code: "404", message: "Data Not found")
            }
            
        }
        
    }
    
    func getUserDetail(userName: String) throws -> TymeXTakeHome.GitHubUser {
        
        let mockJSON = """
        {
                "login": "freeformz",
                "id": 103,
                "node_id": "MDQ6VXNlcjEwMw==",
                "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/freeformz",
                "html_url": "https://github.com/freeformz",
                "followers_url": "https://api.github.com/users/freeformz/followers",
                "following_url": "https://api.github.com/users/freeformz/following{/other_user}",
                "gists_url": "https://api.github.com/users/freeformz/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/freeformz/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/freeformz/subscriptions",
                "organizations_url": "https://api.github.com/users/freeformz/orgs",
                "repos_url": "https://api.github.com/users/freeformz/repos",
                "events_url": "https://api.github.com/users/freeformz/events{/privacy}",
                "received_events_url": "https://api.github.com/users/freeformz/received_events",
                "type": "User",
                "user_view_type": "public",
                "site_admin": false,
                "name": "Edward Muller",
                "company": "Fastly",
                "blog": "icanhazdowntime.org",
                "location": "PDX Area, OR",
                "email": null,
                "hireable": null,
                "bio": "Staff @Fastly  -  Formerly @SalesForce/@Heroku, @engineyard, Interlix, Geekerz, @learningpatterns & UBS (Via PaineWebber)",
                "twitter_username": null,
                "public_repos": 199,
                "public_gists": 73,
                "followers": 243,
                "following": 40,
                "created_at": "2008-01-30T06:19:57Z",
                "updated_at": "2025-05-13T20:04:00Z"
        }
        """
        
        if let jsonData = mockJSON.data(using: .utf8) {
            let userData = try JSONDecoder().decode(GitHubUserDetailData.self, from: jsonData)
            
            return TymeXTakeHome.GithubUserDetailDataToGithubUserDetail().convert(input: userData)
        } else {
            throw BaseError(code: "404", message: "Data Not found")
        }
        
    }
    
}

