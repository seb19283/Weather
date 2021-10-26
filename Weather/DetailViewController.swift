//
//  DetailViewController.swift
//  Weather
//
//  Created by Sebastian Connelly on 10/26/21.
//

import UIKit

// Basic view controller just to display weather detail data
class DetailViewController: UIViewController {

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        return textView
    }()
    
    var currentWeather: DailyWeather? {
        didSet {
            if let currentWeather = currentWeather {
                descriptionTextView.text = currentWeather.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }

}
