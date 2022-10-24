final class TeamsListViewAssembler {
    static func assemble(_ view: inout TeamsListView, _ viewModel: inout TeamsListViewModel) {
        /// View outputs
        view.didLoad = viewModel.load

        view.didBeginSearching = { [weak viewModel] in viewModel?.updateState(state: .searching([])) }
        view.searchTextDidChange = viewModel.updateSearchText
        view.didEndSearching = { [weak viewModel] in viewModel?.updateState(state: .searchResults([])) }

        view.tableViewRowSelected = viewModel.updateSelectedLeague

        view.collectionViewItemSelected = viewModel.selectTeam

        /// ViewModel outputs
        viewModel.stateDidChange = { [weak view] state in
            switch state {
                case .loading:
                    view?.showActivityIndicator(shouldShow: true)
                    view?.endEditingSearch()
                    view?.showTableView(shouldShow: false)
                    view?.showCollectionView(shouldShow: false)

                case .searching(let items):
                    view?.showActivityIndicator(shouldShow: false)

                    view?.showTableView(shouldShow: true)
                    view?.updateTableViewItems(items: items)

                    view?.showCollectionView(shouldShow: false)

                case .searchResults(let items):
                    view?.showActivityIndicator(shouldShow: false)
                    view?.endEditingSearch()
                    view?.showTableView(shouldShow: false)

                    view?.showCollectionView(shouldShow: true)
                    view?.updateCollectionViewItems(items: items)
            }
        }
    }
}
