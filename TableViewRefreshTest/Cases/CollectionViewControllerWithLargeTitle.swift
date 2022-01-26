//
//  CollectionViewControllerWithLargeTitle.swift
//  TableViewRefreshTest
//
//  Created by Junhyeong Hong on 2022/01/24.
//

import UIKit

class CollectionViewControllerWithLargeTitle: UICollectionViewController {

    let manualRefreshingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .black
        btn.setTitle("Programatic Refresh", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var data = ["1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5","1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "TableViewController with LargeTitle"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        let control = UIRefreshControl()
        collectionView.refreshControl = control

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
        collectionView.refreshControl?.beginRefreshing()
        
        print("[programatic refreshing started] isRefreshing = \(collectionView.refreshControl!.isRefreshing)")
        
        // how to know total navigation bar height including large title and normal navigation bar height by safeAreaInsets.top?
        // if the large title is currently visible, then the safeAreaInsets.top reflects the large title height properly
        // but when it is scrolled down so that the title is collapsed, then safeAreaInsets.top only include normal navigation bar height
        // then we cannot use "setContentOffset(CGPoint(x: 0, y: -tableView.safeAreaInsets.top - refreshControl.frame.height))" to cover all cases.
        // this scrollRectToVisible function without animation does some magic here.
        // unfortunately, it seems not working with animation
        collectionView.scrollRectToVisible(CGRect(x: 0, y: -1, width: 1, height: 1), animated: false)
        
        // you can try this instead of scrollRectToVisible for comparison
        // work correctly only when the scroll is already at the top
//        collectionView.setContentOffset(CGPoint(x: 0, y: -collectionView.safeAreaInsets.top - collectionView.refreshControl!.frame.height), animated: true)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // endRefreshing sets refreshControl's isRefreshing to false
            // at the same time it hides the currently visible refreshControl
            self.collectionView.refreshControl?.endRefreshing()
            print("[programatic refreshing ended] isRefreshing = \(self.collectionView.refreshControl!.isRefreshing)")
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("[manual pull-down refreshing started] isRefreshing = \(collectionView.refreshControl!.isRefreshing)")
       // Code to refresh table view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.collectionView.refreshControl?.endRefreshing()
            print("[manual pull-down refreshing ended] isRefreshing = \(self.collectionView.refreshControl!.isRefreshing)")
        }
    }
}

extension CollectionViewControllerWithLargeTitle {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.label.text = data[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

