//
//  BeerDetailModel.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 25.09.2020.
//

// MARK: - BeerDetailModel

struct BeerDetailModel: Decodable {
    
    var name: String?
    var image_url: String?
    var description: String?
    var attenuation_level: Double?
    var abv: Double?
    var ibu: Int?
}
