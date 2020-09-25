//
//  NetworkLayer.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

import Foundation

// MARK: - NetworkLayer

final class NetworkLayer: INetworkLayer {
    
    // MARK: - Public methods
    
    func getBeerList(api: String, complition: @escaping ([ChooseBeerModel]) -> Void) {
        let urlString = api
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { ( data, _, error ) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode([ChooseBeerModel].self, from: data)
                complition(results)
            } catch {
                print("Json Error")
            }
        } .resume()
    }
    
    func getBeerInfo(api: String, complition: @escaping ([BeerDetailModel]) -> Void) {
        let urlString = api
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { ( data, _, error ) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode([BeerDetailModel].self, from: data)
                complition(results)
            } catch {
                print("Json Error")
            }
        } .resume()
    }
}
