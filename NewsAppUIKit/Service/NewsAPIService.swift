//
//  NewsAPIService.swift
//  NewsAppUIKit
//
//  Created by Faruk Dereci on 12.12.2025.
//

import Foundation

final class NewsAPIService {
    private let apiKey: String

    init(apiKey: String) { //Bu sınıfı başka yerde çağırırken apiKey isteyecek biz de kendi apiKeyimizi gireceğiz.
        self.apiKey = apiKey
    }

    func fetchTopHeadlines() async throws -> [Article] { //Başarılı olursa Article listesini döndürür.
        var comps = URLComponents(string: "https://newsapi.org/v2/top-headlines") //Query kısmını elimizle girmiyoruz.
        comps?.queryItems = [
            .init(name: "country", value: "us"),
            .init(name: "pageSize", value: "20"),
            .init(name: "page", value: "1")
        ]

        guard let url = comps?.url else { throw URLError(.badURL) } //Queryler ile birlikte yazılan url. Eğer düzgün oluşturulmamışsa burda bitir demek.

        var request = URLRequest(url: url) //İsteği hazırlıyor. Header düzenleme vb. Olmasa da olur ama böyle daha iyi.
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key") //Buraya kendi keyimi ekliyorum. Keyim hala geçerli mi vb. bunu kontrol ediyor.

        let (data, response) = try await URLSession.shared.data(for: request) //Data sunucunun bize döndürdüğü ham veri. JSON metni gönderiyor. Ama metin olarak değil byte olarak gönderiyor önce. biz onu altta model'a çeviricez. Response ise 404 gibi HTTP status codelar.
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(NewsResponse.self, from: data) //NewsResponse yapısına uyuyor mu? uyuyorsa NewsResponse objesi üret.
        return decoded.articles
    }
}
