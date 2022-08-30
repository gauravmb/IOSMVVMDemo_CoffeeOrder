//
//  AddOrderViewController.swift
//  MVVMDemo2
//
//  Created by M1092828 on 05/08/22.
//

import UIKit

protocol AddOrderViewControllerDelegate{
    func addOrderViewControllerDidSaveOrder(order:Order,viewController:AddOrderViewController)
    func addOrderViewControllerDidClosed(viewController:AddOrderViewController)
}

class AddOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var delegate:AddOrderViewControllerDelegate?
    var addOrderViewModel = AddOrderViewModel()
    private var coffeeSizeSegmentedControl:UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI()
    {
        coffeeSizeSegmentedControl = UISegmentedControl(items: self.addOrderViewModel.sizes)
        self.view.addSubview(coffeeSizeSegmentedControl)
        coffeeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints=false
        coffeeSizeSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive=true
        coffeeSizeSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive=true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addOrderViewModel.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell") else {
            fatalError("No Cell Found")
        }
        cell.textLabel?.text = addOrderViewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func close()
    {
        if let delegate = delegate {
            delegate.addOrderViewControllerDidClosed(viewController: self)
        }
    }
    
    @IBAction func save()
    {
        self.addOrderViewModel.name=self.name.text
        self.addOrderViewModel.email=self.email.text
        let selectedTypeIndexPath = self.tableView.indexPathForSelectedRow
        let selectedSize = self.coffeeSizeSegmentedControl.titleForSegment(at: self.coffeeSizeSegmentedControl.selectedSegmentIndex)
        self.addOrderViewModel.selectedSize=selectedSize
        self.addOrderViewModel.selectedType=self.addOrderViewModel.types[selectedTypeIndexPath!.row]
        
        WebService().load(resource: Order.create(addOrderViewModel: self.addOrderViewModel)) { result in
            switch result
            {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addOrderViewControllerDidSaveOrder(order: order, viewController: self)
                    }
                }
            case .failure(let error):
                    print(error)
            }
        }
    }
    
}
