//
//  RestaurantTableViewCell.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 4/3/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class RestaurantTableViewCell: UITableViewCell {
    
    let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let rightArrowImageView: UIImageView = {
        let image = StyleKit.imageOfRightArrow()
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    var restaurant: Restaurant! {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        selectionStyle = .none
    }
    
    func configureCell(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    fileprivate func setUpLayout() {
        addSubviews(views: [restaurantImageView,
                            descriptionLabel,
                            rightArrowImageView])
        
        restaurantImageView.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.leading.equalTo(snp.leadingMargin)
            make.top.equalTo(snp.topMargin)
            make.bottom.lessThanOrEqualTo(snp.bottomMargin)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.topMargin)
            make.leading.equalTo(restaurantImageView.snp.trailing).offset(8)
            make.trailing.equalTo(rightArrowImageView.snp.leadingMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }
        
        rightArrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(snp.trailingMargin)
            make.centerY.equalTo(descriptionLabel.snp.centerY)
            make.width.equalTo(11)
            make.height.equalTo(20)
        }
    }
    
    fileprivate func updateUI() {
        setDescriptionLabelText()
        let url = URL(string: restaurant.imageurl)
        print("URL:", url)
        restaurantImageView.sd_setImage(with: url, completed: nil)
    }
    
    fileprivate func setDescriptionLabelText() {
        let nameTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                   NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .bold)]
        let nameAttributedText = NSMutableAttributedString(string: "\(restaurant.name)\n", attributes: nameTextAttributes)
        
        let addressTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        let addressAttributedText = NSMutableAttributedString(string: restaurant.addressCapitalized + "\n\n",
                                                               attributes: addressTextAttributes)
        nameAttributedText.append(addressAttributedText)
        
        let timeTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        let timeAttributedText = NSMutableAttributedString(string: "  " + restaurant.openinghours,
                                                              attributes: timeTextAttributes)
        
        let textAttachment = NSTextAttachment()
        let image = StyleKit.imageOfTime()
        textAttachment.image = image
        textAttachment.bounds = CGRect(x: 0, y: -2, width: image.size.width, height: image.size.height)
        let attachmentString = NSAttributedString(attachment: textAttachment)
        
        let openingHourAttributedText = NSMutableAttributedString()
        openingHourAttributedText.append(attachmentString)
        openingHourAttributedText.append(timeAttributedText)
        
        
        nameAttributedText.append(openingHourAttributedText)
        
        descriptionLabel.attributedText = nameAttributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
