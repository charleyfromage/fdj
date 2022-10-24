typealias TeamDetailsViewModel = TeamDetailsViewModelInputs & TeamDetailsViewModelOutputs

protocol TeamDetailsViewModelInputs: ViewModelInputs {}

protocol TeamDetailsViewModelOutputs: ViewModelOutputs {
    var stateDidChange: ((TeamDetailsViewState) -> Void)? { get set }
}

enum TeamDetailsViewState {
    case empty
    case loading
    case loaded(Team)
}

final class TeamDetailsViewModelImpl: TeamDetailsViewModel {
    private var teamName: String
    private var teamService: GetTeamDetailsService

    // MARK: View model
    /// State
    private var state: TeamDetailsViewState = .empty {
        didSet {
            stateDidChange?(state)
        }
    }

    /// Team
    private var team: Team? {
        didSet {
            if let team = team {
                state = .loaded(team)
            } else {
                state = .empty
            }
        }
    }

    // MARK: Outputs
    var stateDidChange: ((TeamDetailsViewState) -> Void)?

    init(teamName: String, teamService: GetTeamDetailsService) {
        self.teamName = teamName
        self.teamService = teamService
    }

    // MARK: Inputs
    func load() {
        state = .loading

        teamService.getTeam(for: teamName) { [weak self] team in
            self?.team = team
        }
    }
}
