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
//    private(set) lazy var apollo = ApolloClient(url: URL(string: Config.GRAPHQL_ENDPOINT)!)
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
//        let cache = nil
//        let store = ApolloStore(cache: cache)
        let apolloStore = ApolloStore()
        let provider = NetworkInterceptorProvider(client: client, store: apolloStore)
        let url = URL(string: Config.GRAPHQL_ENDPOINT)!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url)
        return ApolloClient(networkTransport: transport, store: apolloStore)
    }()


}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(CustomInterceptor(), at: 0)
        return interceptors
    }
}

class CustomInterceptor: ApolloInterceptor {
    
//    let token = "121436c7d02486ee124049af1e8aa35ff9c003125baa77c9e4e6ce6a6dd6aa51ebd8b26f880a05d279f1c5cac3e6b716970657c48c01d9077ab8c1ce784993b62eec46e9e168e5a6c53abdadb5b44121be25b149538b771d3a5c6d7b55ec2260d2c32ad16598d3495c2ddc211589bd59"
//    let userId = "5d987cacdef23b533dd00a36"
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        request.addHeader(name: "X-QZelaAccessToken", value: Config.qzelaToken)
        request.addHeader(name: "X-QZelaUserId", value: Config.qzelaUserId)

        print("request :\(request)")
//        print("response :\(String(describing: response))")
//        print("Completion :\(String(describing: completion))")

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
