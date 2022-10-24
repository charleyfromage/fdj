import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        /// The following should be handled in some routing layer (like a coordinator pattern for instance) with some factories. For simplicity sake, I'm just going to use it in a straight forward manner.
        var navigationController: UINavigationController?

        ///  Network
        let apiClient = APIClientImpl()

        let getLeaguesService = GetLeaguesServiceImpl(apiClient: apiClient)
        let getTeamsService = GetTeamsServiceImpl(apiClient: apiClient)
        let getTeamDetailsService = GetTeamDetailsServiceImpl(apiClient: apiClient)

        /// Teams list view
        let teamsListStoryboard = UIStoryboard(name: "TeamsListView", bundle: nil)
        guard var teamsListViewController = teamsListStoryboard.instantiateViewController(withIdentifier: "TeamsListViewController") as? TeamsListView
        else { return }

        var teamsListViewModel: TeamsListViewModel = TeamsListViewModelImpl(leaguesService: getLeaguesService, teamsService: getTeamsService)

        TeamsListViewAssembler.assemble(&teamsListViewController, &teamsListViewModel)

        navigationController = UINavigationController(rootViewController: teamsListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        teamsListViewModel.teamSelected = { [weak navigationController] team in
            guard let teamName = team.name
            else { return } // Should be displaying some kind of error alert view

            /// Team details view
            let teamDetailsStoryboard = UIStoryboard(name: "TeamDetailsView", bundle: nil)
            guard var teamDetailsViewController = teamDetailsStoryboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsView
            else { return }

            var teamDetailsViewModel: TeamDetailsViewModel = TeamDetailsViewModelImpl(teamName: teamName, teamService: getTeamDetailsService)

            TeamDetailsViewAssembler.assemble(&teamDetailsViewController, &teamDetailsViewModel)

            navigationController?.pushViewController(teamDetailsViewController, animated: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
