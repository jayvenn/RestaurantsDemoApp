//
//  RestaurantListingViewController.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 3/28/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import SnapKit

// MARK: RestaurantListingViewController
class RestaurantListingViewController: UIViewController {
    
    // MARK: RestaurantListingViewController - Properties
    private let data: [String : [[String: String]]] = [
        "restaurants": [
            [
                "imageurl": "http://maxpixel.freegreatpicture.com/static/photo/640/Glass-Restaurant-Glasses-Drink-11937.jpg",
                "name": "The Aqua Front",
                "address": "1 Kaki Bukit View #05-11 Techview, 415941, Singapore",
                "openinghours": "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Table-Table-Setting-Dining-Room-Window-Restaurant-1 03464.jpg",
                "name" :   "The Cocoa Tulip",
                "address" :   "19, Jln Kilang Barat #02-01, AceTech Centre Singapore 159361, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Restaurant-Bern-Catering-Service-Bern-179046.jpg",
                "name" :   "The Honey Barbecue",
                "address" :   "25 Mandai Estate #07-10 Innovation Place - Tower 1, 729930, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Coffee-Cream-Restaurant-Coffee-Cafe-206142.jpg",
                "name" :   "The Summer Pipe",
                "address" :   "1 Hougang Street 91 #01-41 HOUGANG FESTIVAL MARKET, 538692, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Coffee-The-Brew-Coffee-Beans-The-Drink-Caffeine-399 466.jpg",
                "name" :   "The Lunar Wok",
                "address" :   "1 Hougang Street 91 #01-41 HOUGANG FESTIVAL MARKET, 538692, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Cafe-Coffee-Coffee-Maker-Restaurant-424758.jpg",
                "name" :   "The Nomad",
                "address" :   "17 Mandai Estate #02-01 HWA YEW INDUSTRIAL BUILDING, 729934, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Table-Cafe-Menu-Restaurant-Asia-Dinner-Deli-Food-10 50813.jpg",
                "name" :   "The Cave",
                "address" :   "1 Jalan Remaja #04-07 Hillview House, 668662, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Coffee-Maker-Restaurant-Coffee-Cafe-424763.jpg",
                "name" :   "Nightowl",
                "address" :   "35 Selegie Road #10-26, 188307 Central, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Dining-Dinner-Table-Place-Setting-Restaurant-444434 .jpg",
                "name" :   "The Lighthouse",
                "address" :   "1 Scotts Road #16-12 SHAW CENTRE, 228208, Singapore",  "openinghours" :   "10AM to 10PM"
            ], [
                "imageurl" : "http://maxpixel.freegreatpicture.com/static/photo/640/Sugar-Cup-Spoon-Sugar-Lumps-Teacup-Glass-Cup-Tee-61 7422.jpg",
                "name" :   "The Hummingbird",
                "address" :   "Westwood Ave 648355, Singapore",  "openinghours" :   "10AM to 10PM"
            ]
            
        ]
    ]
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.alpha = 0
        return tableView
    }()
    
    fileprivate var restaurants = [Restaurant]() {
        didSet {
            DispatchQueue.main.async {
                if self.tableView.alpha.isZero {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                        self.tableView.alpha = 1
                    })
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: RestaurantListingViewController - Life cycles
extension RestaurantListingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpUI()
        registerTableViewCells()
        parseRestaurantListingData()
    }
    
}

// MARK: RestaurantListingViewController - UI, Layout, Overhead
extension RestaurantListingViewController {
    
    fileprivate func setUpLayout() {
        view.addSubviews(views: [
            tableView
            ])
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    fileprivate func setUpUI() {
        title = "Restaurants"
    }
    
    fileprivate func registerTableViewCells() {
        tableView.register(RestaurantTableViewCell.self,
                           forCellReuseIdentifier: TableViewCellReuseIdentifier.RestaurantTableViewCell.rawValue)
    }
    
}

// MARK: RestaurantListingViewController - UITableViewDelegate
extension RestaurantListingViewController: UITableViewDelegate {
    
}

// MARK: RestaurantListingViewController - UITableViewDataSource
extension RestaurantListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellReuseIdentifier.RestaurantTableViewCell.rawValue, for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        cell.configureCell(restaurant: restaurants[indexPath.row])
        return cell
    }
        
}

// MARK: RestaurantListingViewController - Networking
extension RestaurantListingViewController {
    
    fileprivate func parseRestaurantListingData() {
        guard let dictionaries = data["restaurants"] else { return }
        restaurants = dictionaries.map { (dictionary) -> Restaurant in
            return Restaurant(dictionary: dictionary)
        }
    }
    
}
