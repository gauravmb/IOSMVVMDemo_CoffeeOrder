//
//  Order.swift
//  MVVMDemo2
//
//  Created by M1092828 on 05/08/22.
//

import Foundation

enum CoffeeType:String,CaseIterable,Codable{
    case cappuccino
    case latte
    case expression
    case cortado
}

enum CoffeeSize:String,CaseIterable,Codable{
    case small
    case medium
    case large
}

struct Order:Codable {
    let name:String
    let email:String
    let type:CoffeeType
    let size:CoffeeSize
}


extension Order
{
    init?(viewModel:AddOrderViewModel)
    {
        guard let name = viewModel.name,
              let email = viewModel.email,
              let selectedSize = viewModel.selectedSize,
              let selectedType = viewModel.selectedType else {
            return nil
        }
        self.name = name
        self.email = email
        self.type = CoffeeType(rawValue:selectedType.lowercased())!
        self.size = CoffeeSize(rawValue: selectedSize.lowercased())!
    }
}


extension Order {
    
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("Incorrect URL")
        }
        return Resource<[Order]>(url: url)
    }()
    
    static func create(addOrderViewModel:AddOrderViewModel)->Resource<Order?>
    {
        let order = Order(viewModel: addOrderViewModel)
        guard let data = try? JSONEncoder().encode(order) else
        {
            fatalError("Incorrect URL")
        }
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("Incorrect URL")
        }
        
        var resource = Resource<Order?>(url:url)
        resource.body = data
        resource.httpMethod = .post
        
        return resource
    }
}
