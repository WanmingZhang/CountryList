//
//  CountryCell.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // update UI with data
    func update(with country: Country) {
        let name = country.name
        let region = country.region
        let nameText = "\(name), \(region)"
        self.name.text = nameText
        self.capital.text = country.capital
        self.code.text = country.code
    }
    
    

}
