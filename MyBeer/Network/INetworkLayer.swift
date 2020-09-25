//
//  INetworkLayer.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

// MARK: - INetworkLayer

protocol INetworkLayer {
    
    func getBeerList(api: String, complition: @escaping ([ChooseBeerModel]) -> Void)
    func getBeerInfo(api: String, complition: @escaping ([BeerDetailModel]) -> Void)

}
