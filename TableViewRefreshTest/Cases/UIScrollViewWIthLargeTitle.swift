//
//  UIScrollViewWIthLargeTitle.swift
//  TableViewRefreshTest
//
//  Created by Junhyeong Hong on 2022/01/24.
//

import UIKit

final class ScrollViewWithLargeTitle: UIViewController {
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .green
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let manualRefreshingButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .black
        btn.setTitle("Programatic Refresh", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "UIScrollView with LargeTitle"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        scrollView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        let control = UIRefreshControl()
        scrollView.refreshControl = control

        control.attributedTitle = NSAttributedString(string: "Pull to refresh")
        control.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        view.addSubview(scrollView)
        view.addSubview(manualRefreshingButton)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        manualRefreshingButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1800)
        
        NSLayoutConstraint.activate([
            manualRefreshingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32),
            manualRefreshingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            manualRefreshingButton.widthAnchor.constraint(equalToConstant: 180),
            manualRefreshingButton.heightAnchor.constraint(equalToConstant: 44),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        manualRefreshingButton.addTarget(self, action: #selector(self.manualRefresh(_:)), for: .touchUpInside)
        scrollView.contentSize = contentView.frame.size
    }
    
    @objc func manualRefresh(_ sender: AnyObject) {
        // Set refreshControl's status to "refreshing"
        // Without this line, below codes are not working properly. We need to let the tableView know that "it's refreshing now" first before doing any layout work
        scrollView.refreshControl?.beginRefreshing()
        print("[programatic refreshing started] isRefreshing = \(scrollView.refreshControl!.isRefreshing)")
        
        // how to know total navigation bar height including large title and normal navigation bar height by safeAreaInsets.top?
        // if the large title is currently visible, then the safeAreaInsets.top reflects the large title height properly
        // but when it is scrolled down so that the title is collapsed, then safeAreaInsets.top only include normal navigation bar height
        // then we cannot use "setContentOffset(CGPoint(x: 0, y: -scrollView.safeAreaInsets.top - refreshControl.frame.height))" to cover all cases.
        // this scrollRectToVisible function without animation does some magic
        // unfortunately, it seems not working with animation
        scrollView.scrollRectToVisible(CGRect(x: 0, y: -1, width: 1, height: 1), animated: false)
        
        // you can try this instead of scrollRectToVisible for comparison
        // work correctly only when the scroll is already at the top
//        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.safeAreaInsets.top - scrollView.refreshControl!.frame.height), animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // endRefreshing sets refreshControl's isRefreshing to false
            // at the same time it hides the currently visible refreshControl
            self.scrollView.refreshControl?.endRefreshing()
            print("[programatic refreshing ended] isRefreshing = \(self.scrollView.refreshControl!.isRefreshing)")
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("[manual pull-down refreshing started] isRefreshing = \(scrollView.refreshControl!.isRefreshing)")
       // Code to refresh table view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.scrollView.refreshControl?.endRefreshing()
            print("[manual pull-down refreshing ended] isRefreshing = \(self.scrollView.refreshControl!.isRefreshing)")
        }
    }
}
