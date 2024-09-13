from django.contrib import admin

# Register your models here.
from base.models import *

admin.site.register(Player)
admin.site.register(Team)
admin.site.register(Tournament)
admin.site.register(Match)
