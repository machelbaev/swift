//
//  TripViewController.swift
//  TripCard
//
//  Created by Mikhail on 20.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit
import Parse

class TripViewController: UIViewController {
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "tour_img-1096032-146")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let header: UILabel = {
        let label = UILabel()
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let text = NSMutableAttributedString(string: "Most Popular\n")
        text.append(NSAttributedString(string: "Destination"))
        text.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .semibold)], range: .init(location: 0, length: text.length))
        label.attributedText = text
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    lazy var reloadButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var trips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupCollectionView()

        loadTripsFromParse()
        
    }
    
    private func setupElements() {
        view = backgroundImage
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(header)
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        view.addSubview(collectionView)
        collectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: UIScreen.main.bounds.height / 1.8))
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TripCell.self, forCellWithReuseIdentifier: TripCell.id)
        
        // Setup swipe gesture
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.delegate = self
        collectionView.addGestureRecognizer(swipeUpRecognizer)
    }
    
    private func loadTripsFromParse() {
        // Clear up the array
        trips.removeAll()
        collectionView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Trip")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) in

            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }

            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    // Convert PFObject into Trip object
                    let trip = Trip(pfObject: object)
                    self.trips.append(trip)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                }
            }
        }

    }

}

extension TripViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripCell.id, for: indexPath) as! TripCell
        cell.trip = trips[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width / 3 * 2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension TripViewController: UIGestureRecognizerDelegate {
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: self.collectionView)
        if (gesture.state == .ended) {
            if let indexPath = collectionView.indexPathForItem(at: point) { // Remove trip from Parse, array and collection view
                trips[indexPath.row].toPFObject().deleteInBackground(block: { (success, error) in
                    if (success) {
                        print("Successfully removed the trip")
                    } else if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }

                    self.trips.remove(at: indexPath.row)
                    self.collectionView.deleteItems(at: [indexPath])

                })

            }
        }
    }
    
}

extension TripViewController: TripCellDelegate {
    
    func handleLikeButton(for cell: TripCell) {
        cell.trip?.toPFObject().saveInBackground(block: { (success, error) in
            if (success) {
                print("Successfully updated the trip")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
}


