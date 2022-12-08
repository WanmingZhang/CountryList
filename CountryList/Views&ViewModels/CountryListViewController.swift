//
//  ViewController.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import UIKit

/**
 * a searchable list of countries
 */

class CountryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel: CountryListViewModel
    let reuseCellId = "CountryCell"
    
    // search controller
    let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
        let isSearchBarEmpty = searchController.searchBar.text?.isEmpty ?? true
        return searchController.isActive && !isSearchBarEmpty
    }
    var filteredCountries: [Country] = []
    
    required init?(coder: NSCoder) {
        let apiManager = CountryService()
        let viewModel = CountryListViewModel.init(apiManager)
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupBinder()
        callToViewModelToUpdateUI()
        configureNavAndSearchBar()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        searchController.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling.toggle()
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
    
    func configureNavAndSearchBar() {
        navigationItem.title = "Countries"
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search countries"
        navigationItem.searchController = searchController
    }
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountries.count
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
        if isFiltering {
            let country = filteredCountries[indexPath.row]
            countryCell.update(with: country)
            return countryCell
        }
        let country = viewModel.countries.value[indexPath.row]
        countryCell.update(with: country)
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CountryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        // added .lowercased() to make searches case independent
        filteredCountries = viewModel.countries.value.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.capital.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
