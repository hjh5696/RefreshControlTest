//
//  TableViewWithLargeTitle.swift
//  TableViewRefreshTest
//
//  Created by Junhyeong Hong on 2021/08/09.
//

import UIKit

final class TableViewWithLargeTitle: UIViewController {
    
    var tableView: UITableView = {
        let view = UITableView()
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    let manualRefreshingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .black
        btn.setTitle("Programatic Refresh", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var data = ["1", "2", "3", "4", "5", "1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "UITableView with LargeTitle"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        let control = UIRefreshControl()
        tableView.refreshControl = control

        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        view.addSubview(tableView)
        view.addSubview(manualRefreshingButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        manualRefreshingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            manualRefreshingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32),
            manualRefreshingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            manualRefreshingButton.widthAnchor.constraint(equalToConstant: 180),
            manualRefreshingButton.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        manualRefreshingButton.addTarget(self, action: #selector(self.manualRefresh(_:)), for: .touchUpInside)
    }
    
    @objc func manualRefresh(_ sender: AnyObject) {
        // Set refreshControl's status to "refreshing"
        // Without this line, below codes are not working properly. We need to let the tableView know that "it's refreshing now" first before doing any layout work
        tableView.refreshControl?.beginRefreshing()
        print("[programatic refreshing started] isRefreshing = \(tableView.refreshControl!.isRefreshing)")
        
        // how to know total navigation bar height including large title and normal navigation bar height by safeAreaInsets.top?
        // if the large title is currently visible, then the safeAreaInsets.top reflects the large title height properly
        // but when it is scrolled down so that the title is collapsed, then safeAreaInsets.top only include normal navigation bar height
        // then we cannot use "setContentOffset(CGPoint(x: 0, y: -tableView.safeAreaInsets.top - refreshControl.frame.height))" to cover all cases.
        // this scrollRectToVisible function without animation does some magic here.
        // unfortunately, it seems not working with animation
        tableView.scrollRectToVisible(CGRect(x: 0, y: -1, width: 1, height: 1), animated: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // endRefreshing sets refreshControl's isRefreshing to false
            // at the same time it hides the currently visible refreshControl
            self.tableView.refreshControl?.endRefreshing()
            print("[programatic refreshing ended] isRefreshing = \(self.tableView.refreshControl!.isRefreshing)")
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("[manual pull-down refreshing started] isRefreshing = \(tableView.refreshControl!.isRefreshing)")
       // Code to refresh table view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.refreshControl?.endRefreshing()
            print("[manual pull-down refreshing ended] isRefreshing = \(self.tableView.refreshControl!.isRefreshing)")
        }
    }
}

extension TableViewWithLargeTitle: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ViewCell")
        
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
}
