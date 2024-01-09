//
//  NetworkServices.swift
//  uikit_viper_combine_try
//
//  Created by Muhammad Tafani Rabbani on 03/01/24.
//

import Foundation
import Combine


protocol NetworkLayerProtocol{
    func request <T:Decodable>(router : NetworkRoutes,args : [String:String]) -> AnyPublisher<T,Error>
}

class NetworkLayer : NetworkLayerProtocol{
    //MARK: generic network layer
    func request<T>(router: NetworkRoutes, args : [String:String]) -> AnyPublisher<T, Error> where T : Decodable {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.pageQuery(parameter: args)
        guard let url = components.url else {
            return Empty(completeImmediately: true).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw URLError(.badServerResponse)}
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
