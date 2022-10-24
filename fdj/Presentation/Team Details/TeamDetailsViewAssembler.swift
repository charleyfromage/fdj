final class TeamDetailsViewAssembler {
    static func assemble(_ view: inout TeamDetailsView, _ viewModel: inout TeamDetailsViewModel) {
        /// View outputs
        view.didLoad = viewModel.load

        /// ViewModel outputs
        viewModel.stateDidChange = { [weak view] state in
            switch state {
                case .empty:
                    view?.showActivityIndicator(shouldShow: false)
                    view?.showStackView(shouldShow: false)

                case .loading:
                    view?.showActivityIndicator(shouldShow: true)
                    view?.showStackView(shouldShow: false)
                    
                case .loaded(let team):
                    view?.showActivityIndicator(shouldShow: false)
                    view?.showStackView(shouldShow: true)

                    view?.updateTitle(title: team.name)
                    view?.updateImage(url: team.bannerImageURL)
                    view?.updateCountryLabelText(text: team.country)
                    view?.updateLeagueLabelText(text: team.league)
                    view?.updateDescriptionLabelText(text: team.description)
            }
        }
    }
}
