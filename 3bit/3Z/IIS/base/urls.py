from django.urls import path
from . import views


urlpatterns = [
    path('', views.home, name="home"),
    path('login/', views.loginPage, name="login"),
    path('logout/', views.logoutUser, name="logout"),
    path('register/', views.registerPage, name="register"),
    path('user/<str:login>/', views.userProfile, name="user"),
    path('edit_profile/<str:edit_login>', views.editProfile, name="edit_profile"),
    path('team/<str:team_name>/', views.teamPage, name="team"),
    path('tournament/<int:id_tournament>/', views.tournamentPage, name="tournament"),
    path('create_team/', views.createTeam, name="create_team"),
    path('my_teams/', views.myTeams, name="my_teams"),
    path('delete_player/<str:login>/', views.deletePlayer, name="delete_player"),
    path('edit_team/<str:team_name>/', views.editTeam, name="edit_team"),
    path('delete_team/<str:team_name>/', views.deleteTeam, name="delete_team"),
    path('create_tournament/', views.createTournament, name="create_tournament"),
    path('create_tournament/teams/', views.createTeamsTournament, name="create_tournament_teams"),
    path('create_tournament/players/', views.createPlayersTournament, name="create_tournament_players"),
    path('tournaments_approval/', views.tournamentsApproval, name="tournaments_approval"),
    path('my_tournaments/', views.myTournaments, name="my_tournaments"),
    path('tournament/<int:id_tournament>/run/', views.runTournament, name="run"),
    path('created_tournaments/', views.createdTournaments, name="created_tournaments"),
    path('schedule/<int:id_tournament>/', views.scheduleTournament, name="schedule"),
    path('participants_approval/<int:id_tournament>', views.participantsApproval, name="participants_approval"),
    path('match/<int:id_match>/', views.matchPage, name="match"),
    path('edit_match/<int:id_match>/', views.editMatch, name="edit_match"),
    path('my_matches/', views.myMatches, name="my_matches")
]

