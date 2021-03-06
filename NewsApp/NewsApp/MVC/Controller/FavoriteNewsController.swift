//
//  FavouriteNewsController.swift
//  NewsApp
//
//  Created by Zagorovsky, Artem on 9/15/20.
//  Copyright © 2020 Artem Zagorovski. All rights reserved.
//

import UIKit

final class FavoriteNewsController {
    private weak var view: NewsView?
    private var model: FavoriteNewsDataProvider
    private let coordinator: FavoriteNewsCoordinator
    
    init(model: FavoriteNewsDataProvider, view: NewsView, coordinator: FavoriteNewsCoordinator) {
        self.model = model
        self.view = view
        self.coordinator = coordinator
    }
}

extension FavoriteNewsController: NewsViewDelegate {
    func viewWasDeinited() {}
    
    func isPullToRefreshAvailable() -> Bool {
        return false
    }
    
    func isLoadMoreDataAvailable() -> Bool {
        return false
    }
    
    func viewWillAppear() {
        model.delegate = self
        model.loadFavoriteNews()
    }
    
    func viewDidScrollToEnd() {}
    
    func viewDidPullToRefresh() {}
    
    func viewDidChangeSearchTerm(_ term: String) {
        let filtredNews = model.news(onlyFavorite: true, filter: term)
        view?.updateView(filtredNews.map { NewsModel(news: $0) })
    }
    
    func viewDidTapFavoriteButton(for viewModel: NewsViewModel, currentFavoriteState: Bool, updateCell: (Actions) -> Void) {
        model.updateFavorites(with: News(viewModel: viewModel), currentFavoriteState: currentFavoriteState) {
            updateCell(.delete)
        }
    }
    
    func viewDidTapCell(for viewModel: NewsViewModel) {
        coordinator.showDetails(with: viewModel)
    }
}

extension FavoriteNewsController: NewsManagerDelegate {
    func modelDidLoadNews() {
        let news = model.news(onlyFavorite: true, filter: nil)
        view?.updateView(news.map { NewsModel(news: $0) })
    }
    
    func modelDidGetAnError(error: Error) {
        DispatchQueue.main.async {
            self.coordinator.showAnError(error: error)
        }
    }
}
