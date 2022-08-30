//
//  OrdersTableViewController.swift
//  MVVMDemo2
//
//  Created by M1092828 on 04/08/22.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders()
    {

        WebService().load(resource: Order.all) { result in
            switch result{
            case .success(let orders):
                self.orderListViewModel.ordersViewModel = orders.map{ (order) in
                    OrderViewModel(order: order)
                }
                self.tableView?.reloadData()
                print(orders)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderViewModel = orderListViewModel.orderViewModel(at: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") else {
            fatalError("No Cell Found")
        }
        cell.textLabel?.text = orderViewModel.type
        cell.detailTextLabel?.text = orderViewModel.size
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,  let addOrderViewController = navigationController.viewControllers.first as? AddOrderViewController else {
            fatalError()
        }
        addOrderViewController.delegate = self
        
    }
}

extension OrdersTableViewController:AddOrderViewControllerDelegate
{
    func addOrderViewControllerDidSaveOrder(order: Order, viewController: AddOrderViewController) {
        viewController.dismiss(animated: true)
        let orderViewModel = OrderViewModel(order: order)
        orderListViewModel.ordersViewModel.append(orderViewModel)
        tableView.insertRows(at: [IndexPath(row: orderListViewModel.ordersViewModel.count-1, section: 0)], with: .automatic)

    }
    
    func addOrderViewControllerDidClosed(viewController: AddOrderViewController) {
        viewController.dismiss(animated: true)
        
    }
}






