import datetime
from django import forms
from django.forms import ModelForm
from .models import Tournament, Team, Player, Match

class TournamentForm(ModelForm):
    
    tournament_type = forms.ChoiceField(required=True,widget=forms.RadioSelect, 
         choices=[('teams', 'Teams'), ('players', 'Players')], label="Choose who can participate in the tournament*", initial='teams')

    class Meta:
        model = Tournament
        fields = ['tournament_type']

class TournamentTeamsForm(ModelForm):

    tournament_name = forms.CharField(max_length=100, required=True, label='Name of the tournament*')
    tournament_date_registration = forms.DateField(required=True, label='Registration is open until*', 
        widget=forms.SelectDateWidget(years=range(datetime.datetime.now().year, datetime.datetime.now().year + 3)))
    tournament_date_start = forms.DateField(required=True, label='Starts on*', 
        widget=forms.SelectDateWidget(years=range(datetime.datetime.now().year, datetime.datetime.now().year + 3)))
    tournament_date_end = forms.DateField(required=True, label='Ends on*', 
        widget=forms.SelectDateWidget(years=range(datetime.datetime.now().year, datetime.datetime.now().year + 3)))

    class Meta:
        model = Tournament
        fields = ['tournament_name',
                  'tournament_date_registration',
                  'tournament_date_start',
                  'tournament_date_end',
                  'tournament_description',
                  'tournament_prize',
                  'tournament_number_of_teams',
                   'tournament_number_of_players_in_team'
                  ]


class TournamentPlayersForm(ModelForm):

    tournament_name = forms.CharField(max_length=100, required=True, label='Name of the tournament*')
    tournament_date_registration = forms.DateField(required=True, label='Registration is open until*', 
        widget=forms.SelectDateWidget(years=range(datetime.datetime.now().year, datetime.datetime.now().year + 3)))
    tournament_date_start = forms.DateField(required=True, label='Starts on*', 
        widget=forms.SelectDateWidget(years=range(datetime.datetime.now().year, datetime.datetime.now().year + 3)))
    tournament_date_end = forms.DateField(required=True, label='Ends on*', 
        widget=forms.SelectDateWidget(years=range(datetime.datetime.now().year, datetime.datetime.now().year + 3)))    

    class Meta:
        model = Tournament
        fields = ['tournament_name',
                  'tournament_date_registration',
                  'tournament_date_start',
                  'tournament_date_end',
                  'tournament_description',
                  'tournament_prize',
                  'tournament_number_of_players'
                  ]

        
class TeamForm(ModelForm):
    class Meta:
        model = Team
        fields = ["team_name", "team_members", "logo_image"]
        

class UserEditForm(ModelForm):
    login = forms.CharField(max_length=30, required=False)
    name = forms.CharField(max_length=20, required=False)
    surname = forms.CharField(max_length=20, required=False)
    birthday = forms.DateField (required=False, label='Date of birth', 
    widget=forms.SelectDateWidget(years=[x for x in range(datetime.datetime.now().year, 1900-1, -1)], 
        attrs={'class':'form-control', 'type':'date'}))
    height = forms.IntegerField(required=False, label='Height (cm)', widget=forms.NumberInput)
    weight = forms.IntegerField(required=False, label='Weight (kg)', widget=forms.NumberInput)
    studies_year = forms.IntegerField(required=False)
    email = forms.EmailField(required=False) 

    class Meta:
        model = Player
        fields = '__all__'
        exclude = ['role', 'tournament_approved_list', 'wins', 'losses']


class MatchForm(ModelForm):

    match_date = forms.DateField(required=False, widget=forms.SelectDateWidget())
    match_time = forms.TimeField(required=False, widget=forms.TimeInput())

    class Meta:
        model = Match
        fields = '__all__'
    