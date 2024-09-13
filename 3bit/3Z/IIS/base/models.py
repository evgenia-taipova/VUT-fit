import datetime
from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractUser


class Player(models.Model):
    login = models.CharField(max_length=30)
    name = models.CharField(max_length=20, null=True, blank=True)
    surname = models.CharField(max_length=20, null=True, blank=True)
    birthday = models.DateField(auto_now=False, null=True, blank=True)
    email = models.CharField(max_length=50, null=True, blank=True)
    height = models.CharField(max_length=3, null=True, blank=True)
    weight = models.CharField(max_length=3, null=True, blank=True)
    studies_year = models.CharField(max_length=1, null=True, blank=True)
    tournament_approved_list = models.ManyToManyField('Tournament', related_name='tournament_approved_list_players', blank=True)
    wins = models.IntegerField(default=0)
    losses = models.IntegerField(default=0)
    role = models.CharField(max_length=1, choices=(('a', 'administrator'), ('r', 'registered')), blank=False, default='r')

    def edit_player(user, login, name, surname, birthday, email, height, weight, studies_year):
        
        player = Player.objects.filter(login = user)

        if(login):
            player.update(login = login)

        if(name):
            player.update(name = name)
            
        if(surname):
            player.update(surname = surname)

        if(birthday):
            player.update(birthday = birthday)
        
        if(email):
            player.update(email = email)
        
        if(height):
            player.update(height = height)
        
        if(weight):
            player.update(weight = weight)
        
        if(studies_year):
            player.update(studies_year = studies_year)

    def get_player_by_request(request):
        return Player.objects.get(login = request.user.username)

    def get_teams_of_player(request):
        return Player.get_player_by_request(request).team_members.all()

    def calculate_age(birthday):
        today = datetime.date.today()
        return today.year - birthday.year - ((today.month, today.day) < (birthday.month, birthday.day))

    def number_of_matches(self):
        return self.wins + self.losses

    def winrate(self):
        if self.number_of_matches() == 0:
            return 0
        
        winrate = self.wins / self.number_of_matches() * 100
        winrate = round(winrate, 0)
        return int(winrate)

    def __str__(self) -> str:
        return self.login

   
class Team(models.Model):
    team_name = models.CharField(max_length=50, unique=True)
    team_captain = models.ForeignKey(Player, on_delete=models.CASCADE, null=True, related_name="team_captains")
    team_members = models.ManyToManyField(Player, blank=True, related_name="team_members")
    logo_image = models.ImageField(null=True, blank=True, upload_to="images/")
    tournament_approved_list = models.ManyToManyField('Tournament', related_name='tournament_approved_list_teams', blank=True)
    wins = models.IntegerField(default=0)
    losses = models.IntegerField(default=0)

    def get_team_by_name(team_name):
        return Team.objects.get(team_name = team_name) 

    def number_of_matches(self):
        return self.wins + self.losses

    def __str__(self) -> str:
        return self.team_name
    
    
class Tournament(models.Model):
    id_tournament = models.AutoField(primary_key=True)
    tournament_name = models.CharField(max_length=100)
    tournament_date_registration = models.DateField(auto_now=False, null=True, blank=True)
    tournament_date_start = models.DateField(auto_now=False, null=True, blank=True)
    tournament_date_end = models.DateField(auto_now=False, null=True, blank=True)
    tournament_description = models.TextField(max_length=1000, null=True, blank=True, verbose_name="Description") 
    tournament_prize = models.CharField(max_length=100, null=True, blank=True, verbose_name="Reward")
    tournament_winner_team = models.ForeignKey(Team, on_delete=models.CASCADE, related_name="tournament_winners_teams", null=True, blank=True)
    tournament_winner_player = models.ForeignKey(Player, on_delete=models.CASCADE, related_name="tournament_winners_players", null=True, blank=True)
    tournament_creator = models.ForeignKey(Player, on_delete=models.CASCADE, null=True, related_name="tournament_creators")
    tournament_players = models.ManyToManyField(Player, blank=True, related_name="players_of_tournament")
    tournament_teams = models.ManyToManyField(Team, blank=True, related_name="teams_of_tournament")
    tournament_type = models.CharField(max_length=7, choices=[('teams', 'Teams'), ('players', 'Players')])
    tournament_number_of_teams = models.IntegerField(null=True, blank=True, verbose_name="Number of teams (2,4,8,16)*:")
    tournament_number_of_players_in_team = models.IntegerField(null=True, blank=True, verbose_name="Number of players in one team*:")
    tournament_number_of_players = models.IntegerField(null=True, blank=True, verbose_name="Number of players (2,4,8,16)*:")
    tournament_approved = models.BooleanField(default=False)
    tournament_status = models.CharField(max_length=12, choices=[('registration', 'Registration'), ('not_schedule', 'Not_schedule'), 
        ('scheduled', 'Scheduled'), ('active','Active'),('finished', 'Finished')], default='registration')
    
    def validate_date(registartion, start, end):
        error1 = "Registration end date cannot be earlier than today\'s date"
        error2 = "Registration end date cannot be later than the start date"
        error3 = "The start date of the tournament cannot be later than the end date of the tournament"
        if registartion < datetime.date.today():
            return False, error1
        elif registartion > start:
            return False, error2
        elif start > end:
            return False, error3
        else:
            return True, None

    def __str__(self) -> str:
        return self.tournament_name


class Match(models.Model):
    id_match = models.AutoField(primary_key=True)
    tournament = models.ForeignKey(Tournament, on_delete=models.CASCADE, null=True, related_name="matches_of_tournament", blank=True)
    ordinal_number = models.IntegerField(null=True, blank=True)
    team_first = models.ForeignKey(Team, on_delete=models.CASCADE, null=True, related_name="team1", blank=True)
    team_second = models.ForeignKey(Team, on_delete=models.CASCADE, null=True, related_name="team2", blank=True)
    player_first = models.ForeignKey(Player, on_delete=models.CASCADE, null=True, related_name="player1", blank=True)
    player_second = models.ForeignKey(Player, on_delete=models.CASCADE, null=True, related_name="player2", blank=True)
    match_date = models.DateField(auto_now=False, null=True, blank=True)
    match_time = models.TimeField(auto_now=False, null=True, blank=True)
    score_first = models.IntegerField(null=True, blank=True)
    score_second = models.IntegerField(null=True, blank=True)
    winner_team = models.ForeignKey(Team, on_delete=models.CASCADE, null=True, related_name="winner_team", blank=True)
    winner_player = models.ForeignKey(Player, on_delete=models.CASCADE, null=True, related_name="winner_player", blank=True)
    loser_team = models.ForeignKey(Team, on_delete=models.CASCADE, null=True, related_name="loser_team", blank=True)
    loser_player = models.ForeignKey(Player, on_delete=models.CASCADE, null=True, related_name="loser_player", blank=True)
    status = models.CharField(max_length=8, choices=[('pending', 'Pending'), ('finished', 'Finished')], blank=True)

    def __str__(self) -> str:
        return str(self.id_match)
