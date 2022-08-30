//
//  AddOrderViewModel.swift
//  MVVMDemo2
//
//  Created by M1092828 on 05/08/22.
//

import Foundation

struct AddOrderViewModel{
    var name:String?
    var email:String?
    var selectedType:String?
    var selectedSize:String?
    var types:[String]{
        return CoffeeType.allCases.map{(type) in type.rawValue.capitalized}
    }
    var sizes:[String]{
        return CoffeeSize.allCases.map{$0.rawValue.capitalized}
    }
    
}
