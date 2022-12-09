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
    @IBOutlet weak var flagImage: UIImageView!
    let imageLoader = ImageLoader()
    var onReuse: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        self.flagImage.image = nil
        onReuse()
    }
    
    // update UI with data
    func update(with country: Country) {
        let name = country.name
        let region = country.region
        let code = country.code
        let nameText = "\(name), \(region), \(code)"
        self.name.text = nameText
        self.capital.text = country.capital
        self.loadFlagImage(country)
    }
    
    func loadFlagImage(_ country: Country) {
        guard let url = URL(string: country.flagUrl) else {
            return
        }
        
        let token = imageLoader.loadImageFromUrl(url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.flagImage.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        if let token = token {
            onReuse = { [weak self] in
                guard let self = self else { return }
                self.imageLoader.cancelLoad(token)
            }
        }
    }
    
    

}
