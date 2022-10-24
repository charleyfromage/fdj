import Foundation

typealias TeamsListViewModel = TeamsListViewModelInputs & TeamsListViewModelOutputs

protocol TeamsListViewModelInputs: ViewModelInputs {
    func updateState(state: TeamsListViewState)
    func updateSearchText(searchText: String?)
    func updateSelectedLeague(row: Int)
    func selectTeam(index: Int)
}

protocol TeamsListViewModelOutputs: ViewModelOutputs {
    var stateDidChange: ((TeamsListViewState) -> Void)? { get set }
    var teamSelected: ((Team) -> Void)? { get set }
}

enum TeamsListViewState {
    case loading
    case searching([String?])
    case searchResults([URL?])
}

final class TeamsListViewModelImpl: TeamsListViewModel {
    private var leaguesService: GetLeaguesService
    private var teamsService: GetTeamsService

    // MARK: View model
    /// State
    private var state: TeamsListViewState = .loading {
        didSet {
            stateDidChange?(state)
        }
    }

    /// Autocompletion
    private var leagues: [League] = [] {
        didSet {
            state = .searchResults([])
        }
    }
    private var searchText: String? {
        didSet {
            autoCompletionLeagues = leagues.filter { $0.name?.contains(searchText ?? "") ?? false }
        }
    }
    private var autoCompletionLeagues: [League] = [] {
        didSet {
            state = .searching(autoCompletionLeagues.map { $0.name })
        }
    }
    private var selectedLeague: League? {
        didSet {
            updateTeams()
        }
    }

    /// Teams
    private var teams: [Team] = [] {
        didSet {
            state = .searchResults(teams.map { $0.badgeImageURL })
        }
    }

    // MARK: Outputs
    var stateDidChange: ((TeamsListViewState) -> Void)?
    var teamSelected: ((Team) -> Void)?

    init(leaguesService: GetLeaguesService, teamsService: GetTeamsService) {
        self.leaguesService = leaguesService
        self.teamsService = teamsService
    }

    // MARK: Inputs
    func load() {
        leaguesService.getLeagues { [weak self] leagues in
            self?.leagues = leagues.filter { $0.name != nil }
        }
    }

    func updateState(state: TeamsListViewState) {
        self.state =  state
    }

    func updateSearchText(searchText: String?) {
        self.searchText = searchText
    }

    func updateSelectedLeague(row: Int) {
        selectedLeague = autoCompletionLeagues[row]
    }

    func selectTeam(index: Int) {
        teamSelected?(teams[index])
    }

    // MARK: Private methods
    private func updateTeams() {
        guard let selectedLeagueName = selectedLeague?.name else { return }

        state = .loading

        teamsService.getTeams(for: selectedLeagueName) { [weak self] teams in
            self?.teams = teams.filter { $0.badgeImageURL != nil }
        }
    }
}
