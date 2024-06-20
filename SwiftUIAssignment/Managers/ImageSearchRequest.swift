//
//  ImageSearchRequest.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import Foundation

struct ImageSearchRequest: RequestBuilder {
    var baseUrl: String { "https://api.pexels.com/v1" }
    var path: String? { "/search" }
    var method: HTTPMethod { .get }
    var headers: [String: String]? {
        ["Authorization": "Ou1dFhdt9Gl2Rcu7Xfv4MzThpOZaoXYaNBpy123sCWCCJWmBqUx0m1tG"]
    }
    var queryParam: [String: String]?

    init(query: String, page: Int = 1) {  
        self.queryParam = ["query": query, "per_page": "20", "page": "\(page)"]
    }
}
