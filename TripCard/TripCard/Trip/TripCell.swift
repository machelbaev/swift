//
//  TripCell.swift
//  TripCard
//
//  Created by Mikhail on 21.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

protocol TripCellDelegate {
    func handleLikeButton(for cell: TripCell)
}

class TripCell: UICollectionViewCell {
    
    class var id: String {
        return String(describing: self)
    }
    
    var delegate: TripCellDelegate?
    
    var trip: Trip? {
        didSet {
            guard let trip = trip else { return }
            trip.featuredImage?.getDataInBackground(block: { (data, _) in
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imageData)
                    }
                }
            })
            days.text = "\(trip.totalDays) days"
            country.text = trip.country
            city.text = trip.city
            price.text = "$\(trip.price)"
            setButtonImage()
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return iv
    }()
    
    let city: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    let country: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let days: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 5
        sutupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func sutupElements() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 50, right: 0))
        
        imageView.addSubview(days)
        days.translatesAutoresizingMaskIntoConstraints = false
        days.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        days.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        imageView.addSubview(country)
        country.anchor(top: nil, leading: nil, bottom: days.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        country.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        imageView.addSubview(city)
        city.anchor(top: nil, leading: nil, bottom: country.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        city.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        imageView.addSubview(price)
        price.anchor(top: days.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        price.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        addSubview(likeButton)
        likeButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 5, right: 0), size: .init(width: 40, height: 40))
        likeButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
    }
    
    @objc private func handleLikeButton() {
        guard let trip = trip else { return }
        self.trip?.isLiked = !trip.isLiked
        setButtonImage()
        delegate?.handleLikeButton(for: self)
    }
    
    private func setButtonImage() {
        guard let trip = trip else { return }
        let image = trip.isLiked ? #imageLiteral(resourceName: "icons8-heart-48") : #imageLiteral(resourceName: "icons8-heart-64-2")
        likeButton.setImage(image, for: .normal)
    }
    
}
