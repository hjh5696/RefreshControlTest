//
//  BaseListViewController.swift
//  TableViewRefreshTest
//
//  Created by Junhyeong Hong on 2022/01/24.
//

import UIKit

final class BaseListViewController: UITableViewController {
    var data = [
        "UITableViewController + Large title",
        "UITableViewController + Normal title",
        "UITableView + Large title",
        "UITableView + Normal title",
        "UICollectionViewController + Large title",
        "UIScrollView + Large title"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Cases"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension BaseListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ViewCell")
        
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetVC: UIViewController
        switch indexPath.row {
        case 0:
            targetVC = TableViewControllerWithLargeTitle()
        case 1:
            targetVC = TableViewControllerWithNormalTitle()
        case 2:
            targetVC = TableViewWithLargeTitle()
        case 3:
            targetVC = TableViewWithNormalTitle()
        case 4:
            targetVC = CollectionViewControllerWithLargeTitle(collectionViewLayout: UICollectionViewFlowLayout())
        case 5:
            targetVC = ScrollViewWithLargeTitle()
        default:
            targetVC = TableViewWithNormalTitle()
        }
        
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}

