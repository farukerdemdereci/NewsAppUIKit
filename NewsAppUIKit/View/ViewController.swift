//
//  ViewController.swift
//  NewsAppUIKit
//
//  Created by Faruk Dereci on 12.12.2025.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel = NewsListViewModel(
        service: NewsAPIService(apiKey: "YOUR_API_KEY_HERE")
    )

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseID)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController Loaded ")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupTableView()
        loadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        Task {
            print("LoadNews başladı")
            await viewModel.loadNews()
            print("LoadNews bitti, article count:", viewModel.articles.count)
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.articles[indexPath.row]
        cell.configure(title: article.title, subtitle: article.description, imageURL: article.urlToImage)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

}
