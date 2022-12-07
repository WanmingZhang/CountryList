//
//  ViewController.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import UIKit

class CountryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel: CountryListViewModel
    let reuseCellId = "CountryCell"
    
    required init?(coder: NSCoder) {
        let apiManager = CountryService()
        let viewModel = CountryListViewModel.init(apiManager)
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        setupBinder()
        callToViewModelToUpdateUI()
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func callToViewModelToUpdateUI() {
        viewModel.getCountryList()
    }
    
    // binding of view and view model
    func setupBinder() {
        viewModel.countries.bind { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.countries.value.count > 0 else {
            return 0
        }
        return viewModel.countries.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let countryCell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath) as? CountryCell else {
            return cell
        }
        guard viewModel.countries.value.count > 0 else {
            return cell
        }
        let country = viewModel.countries.value[indexPath.row]
        countryCell.update(with: country)
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
