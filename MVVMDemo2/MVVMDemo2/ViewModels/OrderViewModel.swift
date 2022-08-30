//
//  OrderViewModel.swift
//  MVVMDemo2
//
//  Created by M1092828 on 05/08/22.
//

import Foundation

class OrderListViewModel
{
    var ordersViewModel:[OrderViewModel]
    init()
    {
        self.ordersViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel{
    func orderViewModel(at index:Int)->OrderViewModel
    {
        return self.ordersViewModel[index]
    }
}

struct OrderViewModel
{
    let order:Order
}

extension OrderViewModel{
    var name:String {
        return order.name
    }
    
    var email:String{
        return order.email
    }
    
    var type:String
    {
        return order.type.rawValue.capitalized
    }
    
    var size:String
    {
        return order.size.rawValue.capitalized
    }
}


