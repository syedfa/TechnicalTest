//
//  DetailViewController.swift
//  TechnicalTest
//
//  Created by Fayyazuddin Syed on 2016-11-07.
//  Copyright © 2016 Fayyazuddin Syed. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var photo: Photo?

    func configureView() {
        // Update the user interface for the detail item.
        
        if let photo = photo {
            NetworkService.getPhotoImage(photo: photo, completion: { (image, error) in
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

