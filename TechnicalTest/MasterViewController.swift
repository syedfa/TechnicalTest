//
//  MasterViewController.swift
//  TechnicalTest
//
//  Created by Fayyazuddin Syed on 2016-11-07.
//  Copyright © 2016 Fayyazuddin Syed. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        NetworkService.getFeed { (photos: [Photo]?, error: Error?) in
            if let photos = photos {
                DispatchQueue.main.async {
                    self.photos = photos
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow, let navc = segue.destination as? UINavigationController, let vc = navc.topViewController as? DetailViewController {
                vc.photo = photos[indexPath.row]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = photos[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }
}

