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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with country: Country) {
        self.name.text = country.name
        self.capital.text = country.capital
        self.code.text = country.code
    }

}
