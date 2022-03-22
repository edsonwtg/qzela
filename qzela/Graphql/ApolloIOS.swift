//
//  ApolloIOS.swift
//  qzela
//
//  Created by Edson Rocha on 05/12/21.
//

import Foundation
import Apollo

class ApolloIOS {

    static let shared = ApolloIOS()
//    private(set) lazy var apollo = ApolloClient(url: URL(string: Config.GRAPHQL_ENDPOINT)!)
    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
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

    func interceptAsync<Operation: GraphQLOperation>(
            chain: RequestChain,
            request: HTTPRequest<Operation>,
            response: HTTPResponse<Operation>?,
            completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        request.addHeader(name: "X-QZelaAccessToken", value: Config.SAV_ACCESS_TOKEN)
        request.addHeader(name: "X-QZelaUserId", value: Config.SAV_CD_USUARIO)
//        print("request :\(request)")
//        print("response :\(String(describing: response))")
//        print("Completion :\(String(describing: completion))")

        chain.proceedAsync(request: request,
                response: response,
                completion: completion)
    }
}
