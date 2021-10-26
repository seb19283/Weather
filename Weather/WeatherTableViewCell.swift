//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Sebastian Connelly on 10/26/21.
//

import UIKit

// Basic TableViewCell class to display necessary information
class WeatherTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(iconImageView)
        
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.addSubview(dayLabel)
        dayLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.addSubview(weatherLabel)
        weatherLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 16).isActive = true
        weatherLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8).isActive = true
        weatherLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        weatherLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
