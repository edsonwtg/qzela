//
//  Apollo.swift
//  qzela
//
//  Created by Edson Rocha on 05/12/21.
//

import Foundation
import Apollo

class Apollo {
    
    static let shared = Apollo()
    private(set) lazy var apollo = ApolloClient(url: URL(string: Config.GRAPHQL_ENDPOINT)!)
    
}
