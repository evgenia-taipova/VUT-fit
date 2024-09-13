from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from base.models import *
from .forms import *
from django.contrib.auth.forms import UserCreationForm
import random


def home(request): 
    """Function for loading the home page."""
    players = Player.objects.all()
    teams = Team.objects.all()
    tournaments = Tournament.objects.all()
   
    tournament_count = 0
    for tournament in tournaments:
        if tournament.tournament_approved == True:
            tournament_count = 1
            break

    return render(request, 'base/home.html', {'players': players, 'teams': teams, 'tournaments': tournaments, 'tournament_count': tournament_count})


def loginPage(request): 
    """Function for user authorization."""

    if request.method == 'POST': 
        
        username = request.POST.get('username') # save username
        password = request.POST.get('password') # save password

        try: 
            user = authenticate(request, username=username, password=password) # check if user exists
            login(request, user) # authorize the user
            return redirect('home')

        except: # if user doesn't exist or password is wrong 
            messages.error(request, 'Username OR password doesn\'t exist')

    return render(request, 'base/login_register.html' , {'page' : 'login'}) # load the page with login form


def registerPage(request):
    """Function for user registration."""

    form = UserCreationForm() # form for registration

    if request.method == 'POST':
        
        form = UserCreationForm(request.POST) # get data from the form

        if form.is_valid(): 

            user = form.save(commit=False) # get user data

            user.username = user.username.lower() # save username in lowercase
            Player.objects.create(login = user) # create player with the same login

            user.save() # save user
            login(request, user) # authorize the user

            return redirect('home')

    return render(request, 'base/login_register.html', {'form' : form})


def logoutUser(request):
    """Function for user logout."""

    logout(request) # logout the user

    return redirect('home') 


def userProfile(request, login): 
    """Function for loading the user profile page."""

    player = Player.objects.get(login = login) # get player by login

    if player.birthday: 
        
        age = Player.calculate_age(player.birthday) 

        return render(request, 'base/user.html', {'player': player, 'age': age}) # load the page with user profile and calculated age
    else:
        return render(request, 'base/user.html', {'player': player}) # 

    
def editProfile(request, edit_login): 
    """Function for loading edit profile page."""

    instance=Player.objects.get(login = edit_login) # get player by login
    form = UserEditForm(instance=instance) # form for editing user profile

    if 'edit' in request.POST: # if edit button is pressed
        form = UserEditForm(request.POST, instance=instance) 
        
        if form.is_valid():
            user = form.save() 
            Userforlogin = User.objects.get(username = edit_login)

            # get data from the form
            login = form.cleaned_data.get('login')
            name = form.cleaned_data.get('name')
            surname = form.cleaned_data.get('surname')
            birthday = form.cleaned_data.get('birthday')
            email = form.cleaned_data.get('email')
            height = form.cleaned_data.get('height')
            weight = form.cleaned_data.get('weight')
            studies_year = form.cleaned_data.get('studies_year')
            
            Player.edit_player(user, login, name, surname, birthday, email, height, weight, studies_year) # edit player profile
            
            # if login is changed
            if(login): 
                Userforlogin.username = login # change login
                Userforlogin.save() 
                
                player = Player.objects.get(login = login) # user to be displayed on the page after editing

            user.save()

            return userProfile(request, player)
    return render(request, 'base/edit_profile.html', {'form': form, 'player': edit_login})


def teamPage(request, team_name):
    """Function for loading the team page."""
    team = Team.get_team_by_name(team_name) # get team by name
    team_members = team.team_members.all() # get all team members
    return render(request, 'base/team.html', {'team': team, 'team_members': team_members}) 


def tournamentPage(request, id_tournament):
    """Function for loading the tournament page."""
    tournament = Tournament.objects.get(id_tournament = id_tournament) # get tournament by id
    players = tournament.tournament_players.all() # get all players in the tournament
    teams = tournament.tournament_teams.all() # get all teams in the tournament

    participants_count = len(players) + len(teams) # count of participants (players or teams)

    # Admin part
    if 'decline' in request.POST: # if admin declines the tournament
        tournament.delete()
        return redirect('tournaments_approval')
    elif 'approve' in request.POST: # if admin approves the tournament
        tournament.tournament_approved = True
        tournament.save()
        return redirect('tournaments_approval')
    
    # Player part
    is_player = False 
    is_captain = False
    is_captain_team = False
    is_waiting = False
    teams_capitan = []
    if request.user.is_superuser is False: # if user is not admin
        # if the user is a participant in the tournament or is under consideration
        if request.user.is_authenticated:
            if Player.get_player_by_request(request).tournament_approved_list.filter(id_tournament = id_tournament).exists():
                is_waiting = True
                        
        if players.filter(login = request.user.username).exists(): 
            is_player = True
        
        for team in Team.objects.all():
            if team.team_captain.login == request.user.username: # if the user is a captain of the team
                is_captain = True
                teams_capitan.append(team)
            
                if teams.filter(team_name = team.team_name).exists(): # if the team participates in the tournament
                    is_captain_team = True

                # if the team has applied for participation in the tournament
                if team.tournament_approved_list.filter(id_tournament = id_tournament).exists():
                    is_waiting = True
    
    
    if 'leave_player' in request.POST: 
        # if the player leaves the tournament 
        if is_player:
            tournament.tournament_players.remove(Player.get_player_by_request(request)) # remove player from the tournament
            return redirect('tournament', id_tournament = id_tournament)

    elif 'join_player' in request.POST:
        # if the player joins the tournament
        if is_player is False:
            Player.get_player_by_request(request).tournament_approved_list.add(tournament) # add player to the tournament for consideration
            return redirect('tournament', id_tournament = id_tournament)

    elif 'leave_team' in request.POST:
        # if the team leaves the tournament
        if is_captain:
            team_in_tournament = tournament.tournament_teams.get(team_captain = Player.get_player_by_request(request)) # get the team that is in the tournament and the captain of which is the user
            tournament.tournament_teams.remove(Team.get_team_by_name(team_in_tournament)) # remove team from the tournament
            return redirect('tournament', id_tournament = id_tournament)

    elif 'join_team' in request.POST:
        # if the team joins the tournament
        if is_captain:
            selected_team = request.POST.get('select_team') # get the name of the selected team
            Team.get_team_by_name(selected_team).tournament_approved_list.add(tournament) # add team to the tournament for consideration
            return redirect('tournament', id_tournament = id_tournament)
    
    # if the tournament is in the registration phase 
    if tournament.tournament_status == 'registration': 
        if tournament.tournament_date_registration <= datetime.date.today(): # if the registration period has expired
            tournament.tournament_status = 'not_schedule'

    # if the tournament is in the not_schedule phase
    if tournament.tournament_status == 'not_schedule':
        if 'run' in request.POST: # if the tournament is started
            tournament.tournament_status = 'scheduled'
            return redirect('run_tournament', id_tournament = tournament.id_tournament)


    return render(request, 'base/tournament.html', {'tournament': tournament, 'players': players,'teams': teams, 'is_player': is_player, 
        'is_captain': is_captain, 'is_captain_team': is_captain_team, 'is_waiting': is_waiting, 'teams_capitan': teams_capitan, 'participants_count': participants_count})


def createTeam(request):
    """Function for creating a team."""
    form = TeamForm()

    form.fields['team_members'].queryset = Player.objects.exclude(login = request.user.username) # removes the captain from the list of team players
    
    if request.method == 'POST':
        form = TeamForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            team = Team.objects.get(team_name = form.cleaned_data.get('team_name')) # get team by name
            team.team_captain = Player.get_player_by_request(request) # set captain
            team.team_members.add(team.team_captain) # add captain to the team
            team.save()

            return teamPage(request, form.cleaned_data.get('team_name'))
    
    return render(request, 'base/create_team.html' , {'form' : form})


def myTeams(request):
    """Function for loading the page with the user's teams."""

    teams = Player.get_teams_of_player(request) # get all teams of the user
    
    return render(request, 'base/my_teams.html', {'teams': teams}) # возвращаем страницу со всеми командами игрока


def deletePlayer(request, login):
    """Function for deleting a player."""
    
    player = Player.objects.get(login=login) # get player by login
    user = User.objects.get(username=login) # get user by login

    if 'delete_confirm' in request.POST: 
        player.delete() 
        user.delete() 
        if not request.user.is_superuser:
            logoutUser(request) # if the user is not an admin, then log out
        
        return redirect('home')

    return render(request, 'base/delete_player.html', {'player': player})


def editTeam(request, team_name):
    """Function for editing a team."""

    team = Team.get_team_by_name(team_name) # get team by name
    form = TeamForm(instance=team) # get form with data from the team
    
    form.fields['team_members'].queryset = Player.objects.exclude(login=team.team_captain.login) # removes the captain from the list of team players
    
    if 'edit' in request.POST: # if the team is edited
        form = TeamForm(request.POST, request.FILES ,instance=team) # get form with data from the team
        
        # saves the team and opens the team page
        if form.is_valid():
            edit_team = form.save() 
            edit_team.team_members.add(edit_team.team_captain) # добавляем капитана в команду

            return teamPage(request, edit_team.team_name)
        
    return render(request, 'base/edit_team.html', {'form': form, 'team': team})


def deleteTeam(request, team_name):
    """Function for deleting a team."""

    team = Team.get_team_by_name(team_name) 

    if 'delete_confirm' in request.POST: 
        team.delete() 
        return redirect('my_teams')

    return render(request, 'base/delete_team.html', {'team': team})


def createTournament(request):
    """Function for creating a tournament."""

    form = TournamentForm()

    if request.method == 'POST':
        form = TournamentForm(request.POST)
        if form.is_valid():
            
            # go to the page for the team tournament
            if form.cleaned_data.get('tournament_type') == "teams": 
                return redirect('teams/')
            else: 
                return redirect('players/')

    return render(request, 'base/create_tournament.html', {'form' : form})


def createTeamsTournament(request):
    """Function for creating a team tournament."""

    form = TournamentTeamsForm()

    if request.method == 'POST':
        form = TournamentTeamsForm(request.POST)
        if form.is_valid():

            # check the dates
            validate_date = Tournament.validate_date(   form.cleaned_data.get('tournament_date_registration'),
                                                        form.cleaned_data.get('tournament_date_start'), 
                                                        form.cleaned_data.get('tournament_date_end')) 
            # if the dates are not valid 
            if validate_date[0] is False: 
                return render(request, 'base/create_tournament.html', {'form': form, 'error': validate_date[1]})

            number_of_teams = form.cleaned_data.get('tournament_number_of_teams')

            if not (number_of_teams == 2 or number_of_teams == 4 or number_of_teams == 8 or number_of_teams == 16):
                return render(request, 'base/create_tournament.html', {'form': form, 'error': "Enter a valid value for the number of teams"})
           
            form.save()

            tournament = Tournament.objects.last() # get the last tournament
            tournament.tournament_creator = Player.get_player_by_request(request) # set the creator
            tournament.tournament_type = "teams" # set the type of tournament
            tournament.save()
            return tournamentPage(request, tournament.id_tournament)

    return render(request, 'base/create_tournament_teams.html', {'form' : form})


def createPlayersTournament(request):
    """Function for creating a player tournament."""

    form = TournamentPlayersForm()

    if request.method == 'POST':
        form = TournamentPlayersForm(request.POST)
        if form.is_valid():

            # check the dates
            validate_date = Tournament.validate_date(   form.cleaned_data.get('tournament_date_registration'),
                                                        form.cleaned_data.get('tournament_date_start'), 
                                                        form.cleaned_data.get('tournament_date_end')) 
            # if the dates are not valid
            if validate_date[0] is False:
                return render(request, 'base/create_tournament.html', {'form': form, 'error': validate_date[1]})
            
            number_of_players = form.cleaned_data.get('tournament_number_of_players')

            if not (number_of_players == 2 or number_of_players == 4 or number_of_players == 8 or number_of_players == 16):
                return render(request, 'base/create_tournament.html', {'form': form, 'error': "Enter a valid value for the number of players"})

            form.save()

            tournament = Tournament.objects.last() # get the last tournament
            tournament.tournament_creator = Player.get_player_by_request(request) # set the creator
            tournament.tournament_type = "players" # set the type of tournament
            tournament.save()
            return tournamentPage(request, tournament.id_tournament)

    return render(request, 'base/create_tournament_players.html', {'form' : form})


def tournamentsApproval(request):
    """Function for approving tournaments."""

    tournaments = Tournament.objects.all() # get all tournaments and after sort them by approval
    return render(request, 'base/tournaments_approval.html', {'tournaments': tournaments})


def myTournaments(request):
    """Function for displaying tournaments in which the user participates."""

    tournaments_players = Player.get_player_by_request(request).players_of_tournament.all() # get all tournaments in which the player participates
    teams = Player.get_teams_of_player(request) 
    
    tournaments_teams = [] 
    for team in teams: # get all tournaments in which the team participates
        print(team.teams_of_tournament.all())
        for tournament in team.teams_of_tournament.all():
            tournaments_teams.append(tournament)

    print(tournaments_teams)
    return render(request, 'base/my_tournaments.html', {'tournaments_teams': tournaments_teams, 'tournaments_players': tournaments_players})


def runTournament(request, id_tournament):
    """Function for running a tournament."""

    tournament = Tournament.objects.get(id_tournament=id_tournament) # get the tournament

    if 'automatically' in request.POST:

        # checks teams for the correct number of participants
        if tournament.tournament_type == 'teams':  
                number_of_players_in_team = tournament.tournament_number_of_players_in_team 
                
                for team in tournament.tournament_teams.all():
                    if team.team_members.all().count() != number_of_players_in_team: 
                        return render(request, 'base/run_tournament.html', {'tournament': tournament, 'error': "The number of players in the team is incorrect"})

        tournament.tournament_status = 'scheduled'
        tournament.save()
 
        return redirect ('schedule', id_tournament)

    return render(request, 'base/run_tournament.html', {'tournament': tournament})


def createdTournaments(request):
    """Function for displaying tournaments created by the user."""

    tournaments = Tournament.objects.filter(tournament_creator=Player.objects.get(login = request.user.username)) # get all tournaments created by the user

    return render(request, 'base/created_tournaments.html', {'tournaments': tournaments})


def scheduleTournament(request, id_tournament):
    """Function for scheduling a tournament."""

    tournament = Tournament.objects.get(id_tournament=id_tournament) # get the tournament

    teams_count = 0 # number of teams in the tournament
    matches = [] # list of matches
    tournament_type = tournament.tournament_type 

    # if there are no matches, then create them
    if Match.objects.filter(tournament=tournament).count() == 0:

        if tournament.tournament_type == 'teams':
            
            teams_count = tournament.tournament_number_of_teams # get the number of teams in the tournament
            teams_random = random.sample(list(tournament.tournament_teams.all()), teams_count) # get a list of teams in the tournament in random order
            number_of_matches = teams_count - 1 # number of matches to be played
            
            # creates matches
            match = 0
            while match < number_of_matches:

                # take teams from the list of participating teams, assign them to teams and remove them from the list
                if(len(teams_random) > 0): #
                    team1 = teams_random[0]
                    teams_random.pop(0)
                    team2 = teams_random[0]
                    teams_random.pop(0)
                else:
                    team1 = None
                    team2 = None

                # create a match
                data = { 
                    'tournament': tournament,
                    'ordinal_number': match+1,
                    'team_first': team1,
                    'team_second': team2,
                    'score_first': 0,
                    'score_second': 0,
                    'status': 'pending'
                }

                form = MatchForm(data)
                if form.is_valid():
                    form.save()

                match += 1 # increment the number of matches
                matches.append(Match.objects.last()) # add the match to the list of matches

        elif tournament.tournament_type == 'players':
            teams_count = tournament.tournament_number_of_players # get the number of players in the tournament
            teams_random = random.sample(list(tournament.tournament_players.all()), teams_count) # get a list of teams (from players) in the tournament in random order
            number_of_matches = teams_count - 1 # number of matches to be played
            
            # creates matches
            match = 0
            while match < number_of_matches:

                # take players from the list of participating players, assign them to teams and remove them from the list
                if(len(teams_random) > 0):
                    team1 = teams_random[0]
                    teams_random.pop(0)
                    team2 = teams_random[0]
                    teams_random.pop(0)
                else:
                    team1 = None
                    team2 = None

                # create a match
                data = {
                    'tournament': tournament,
                    'ordinal_number': match+1,
                    'player_first': team1,
                    'player_second': team2,
                    'score_first': 0,
                    'score_second': 0,
                    'status': 'pending'
                }
                form = MatchForm(data)
                if form.is_valid():
                    form.save()
                
                match += 1 # increment the number of matches
                matches.append(Match.objects.last()) # add the match to the list of matches

    else: # if there are matches, then get them
        if tournament.tournament_type == 'teams': 
            teams_count = tournament.tournament_number_of_teams # get the number of teams in the tournament
        
        elif tournament.tournament_type == 'players':
            teams_count = tournament.tournament_number_of_players # get the number of players in the tournament
        
        matches = Match.objects.filter(tournament=tournament) # get all matches of the tournament
    
    return render(request, 'base/schedule_tournament.html', {'tournament': tournament,  'teams_count': teams_count, 'matches': matches, 'tournament_type': tournament_type})


def matchPage(request, id_match):
    """Function for displaying a match."""

    match = Match.objects.get(id_match = id_match) # get the match

    return render(request, 'base/match.html', {'match': match})


def editMatch(request, id_match):
    """Function for editing a match."""

    match = Match.objects.get(id_match = id_match)
    ordinal_number = match.ordinal_number 
    tournament = match.tournament
    form = MatchForm(instance=match)
    if request.method == 'POST':
        form = MatchForm(request.POST, instance=match)
        if form.is_valid():
            match.ordinal_number = ordinal_number
            match.tournament = tournament

        
            # if the match is over, then check the winner and update the tournament table 
            if match.status == 'finished':
                if match.tournament.tournament_type == 'players':
                    if match.score_first == match.score_second:
                        return render(request, 'base/edit_match.html', {'match': match, 'form': form, 'error': "The match cannot be finished if there is no winner"})
                    elif match.score_first > match.score_second:
                        match.winner_player = match.player_first
                        match.winner_player.wins += 1
                        match.loser_player = match.player_second
                        match.loser_player.losses += 1
                    elif match.score_first < match.score_second:
                        match.winner_player = match.player_second
                        match.winner_player.wins += 1
                        match.loser_player = match.player_first
                        match.loser_player.losses += 1
                    match.winner_player.save()
                    match.loser_player.save()
                    number_of_matches = match.tournament.tournament_number_of_players - 1 # number of matches to be played
                elif match.tournament.tournament_type == 'teams':
                    if match.score_first == match.score_second:
                        return render(request, 'base/edit_match.html', {'match': match, 'form': form, 'error': "The match cannot be finished if there is no winner"})
                    elif match.score_first > match.score_second:
                        match.winner_team = match.team_first
                        match.winner_team.wins += 1
                        match.loser_team = match.team_second
                        match.loser_team.losses += 1
                    elif match.score_first < match.score_second:
                        match.winner_team = match.team_second
                        match.winner_team.wins += 1
                        match.loser_team = match.team_first
                        match.loser_team.losses += 1
                    match.winner_team.save()
                    match.loser_team.save()
                    number_of_matches = match.tournament.tournament_number_of_teams - 1 # number of matches to be played
            elif match.status == 'pending':
                if match.tournament.tournament_type == 'players':
                    number_of_matches = match.tournament.tournament_number_of_players 
                elif match.tournament.tournament_type == 'teams':
                    number_of_matches = match.tournament.tournament_number_of_teams 

            # if the match is the last one, then the tournament is over
            if match.ordinal_number == number_of_matches:
                match.tournament.tournament_status = 'finished'

                if match.tournament.tournament_type == 'players':
                    match.tournament.tournament_winner_player = match.winner_player
                elif match.tournament.tournament_type == 'teams':
                    match.tournament.tournament_winner_team = match.winner_team

                match.tournament.save()



            match.save()
            form.save()
            return redirect('match', id_match=match.id_match)

    return render(request, 'base/edit_match.html', {'match': match, 'form': form})


def participantsApproval(request, id_tournament):
    """Function for approving participants in the tournament."""

    tournament = Tournament.objects.get(id_tournament=id_tournament) # get the tournament
    
    teams = []
    players = []

    # get a list of players who want to participate in the tournament
    if tournament.tournament_type == 'players':
        players = tournament.tournament_approved_list_players.all()

        for player in players:
            if "approve " + player.login in request.POST:
                tournament.tournament_players.add(player)
                tournament.tournament_approved_list_players.remove(player)
                tournament.save()
                return redirect('participants_approval', id_tournament)
            elif "decline " + player.login in request.POST:
                tournament.tournament_approved_list_players.remove(player)
                tournament.save()
                return redirect('participants_approval', id_tournament)

    elif tournament.tournament_type == 'teams':
        teams = tournament.tournament_approved_list_teams.all()

        for team in teams:
            if "approve " + team.team_name in request.POST:
                
                tournament.tournament_teams.add(team) # add players to the tournament
                tournament.tournament_approved_list_teams.remove(team) # remove the team from the list of waiting for participation
                tournament.save()

                return redirect('participants_approval', id_tournament)

            elif "decline " + team.team_name in request.POST:

                tournament.tournament_approved_list_teams.remove(team) # remove the team from the list of waiting for participation
                tournament.save()

                return redirect('participants_approval', id_tournament)

    return render(request, 'base/participants_approval.html', {'tournament': tournament, 'players': players, 'teams': teams})


def myMatches(request):
    """Function for displaying matches of the current user."""

    matches = []
    player = Player.get_player_by_request(request) 


    # for tournaments between players
    tournaments_players = Tournament.objects.filter(tournament_players=player).all()
    # go through each tournament and each match in which the player participates and add to the list
    for tournament in tournaments_players:
        for match in tournament.matches_of_tournament.all():
            if match.player_first == player or match.player_second == player:
                matches.append(match)

    # for tournaments between teams
    teams = Player.get_teams_of_player(request)
    for team in teams:
        tournaments_teams = Tournament.objects.filter(tournament_teams=team).all()
        # go through each tournament and each match in which the player participates and add to the list
        for tournament in tournaments_teams:
            for match in tournament.matches_of_tournament.all():
                if match.team_first == team or match.team_second == team:
                    matches.append(match)

    return render(request, 'base/my_matches.html', {'matches': matches})

