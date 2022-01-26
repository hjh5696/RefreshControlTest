//
//  TableViewControllerWithNormalTitle.swift
//  TableViewRefreshTest
//
//  Created by Junhyeong Hong on 2022/01/24.
//

import UIKit

class TableViewControllerWithNormalTitle: UITableViewController {

    let manualRefreshingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .black
        btn.setTitle("Programatic Refresh", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var data = ["1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "TableViewController with NormalTitle"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let control = UIRefreshControl()
        refreshControl = control

        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        view.addSubview(manualRefreshingButton)
        
        manualRefreshingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            manualRefreshingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32),
            manualRefreshingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            manualRefreshingButton.widthAnchor.constraint(equalToConstant: 180),
            manualRefreshingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        manualRefreshingButton.addTarget(self, action: #selector(self.manualRefresh(_:)), for: .touchUpInside)
    }
    
    @objc func manualRefresh(_ sender: AnyObject) {
        // Set refreshControl's status to "refreshing"
        // Without this line, below codes are not working properly. We need to let the tableView know that "it's refreshing now" first before doing any layout work
        refreshControl?.beginRefreshing()
        
        print("[programatic refreshing started] isRefreshing = \(refreshControl!.isRefreshing)")
        
        // here navigation bar height is fixed, so it's much easier than the large title case
        // 1. tableView.scrollRectToVisible(CGRect(x: 0, y: -1, width: 1, height: 1), animated: true)
        // 2. tableView.setContentOffset(CGPoint(x: 0, y: -tableView.safeAreaInsets.top - refreshControl!.frame.height), animated: true)
        // both works but only without RefreshControl title.
        
//        tableView.scrollRectToVisible(CGRect(x: 0, y: -1, width: 1, height: 1), animated: true)
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.safeAreaInsets.top - tableView.contentInset.top - refreshControl!.frame.height), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // endRefreshing sets refreshControl's isRefreshing to false
            // at the same time it hides the currently visible refreshControl
            self.refreshControl?.endRefreshing()
            print("[programatic refreshing ended] isRefreshing = \(self.refreshControl!.isRefreshing)")
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("[manual pull-down refreshing started] isRefreshing = \(refreshControl!.isRefreshing)")
       // Code to refresh table view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl?.endRefreshing()
            print("[manual pull-down refreshing ended] isRefreshing = \(self.refreshControl!.isRefreshing)")
        }
    }
}

extension TableViewControllerWithNormalTitle {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ViewCell")
        
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
}
