//
//  ViewModel.swift
//  NewsAppUIKit
//
//  Created by Faruk Dereci on 12.12.2025.
//

import Foundation

@MainActor //Bu class içindeki her şey main thread'de çalışsın. UI sadece main thread de güncellenir.
final class NewsListViewModel {

    private let service: NewsAPIService

    private(set) var articles: [Article] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    init(service: NewsAPIService) { //Bu ViewModel'ı oluşturmak isteyen kişi bana bir tane NewsAPIService getirmek zorunda.
        self.service = service
    }

    func loadNews() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedArticles = try await service.fetchTopHeadlines() //fetchTopHeadlines() = Article döndürüyor. fetchedArticles kalana erişmiyor sadece Article dönmesini bekliyor. Sonucu bekliyor.
            articles = fetchedArticles
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
