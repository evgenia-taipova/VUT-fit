"""
WSGI config for iissii project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.1/howto/deployment/wsgi/
"""

import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'iissii.settings')

application = get_wsgi_application()


# for host
# """
# WSGI config for iissii project.

# It exposes the WSGI callable as a module-level variable named ``application``.

# For more information on this file, see
# https://docs.djangoproject.com/en/4.1/howto/deployment/wsgi/
# """

# import os
# import sys

# from django.core.wsgi import get_wsgi_application

# path = '/home/xkoval21/IIS/src'

# if path not in sys.path:
#     sys.path.append(path)

# os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'iissii.settings')


# application = get_wsgi_application()
