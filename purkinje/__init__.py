# -*- coding: utf-8 -*-
"""
    purkinje
    ==================

    A training planner, journal and tracker for coaches and athletes.

    :copyright: (C) 2017 by Christian Place Pedersen
    :license:   MIT, see LICENSE for more details.
"""

from flask import Flask
from purkinje.config import configure_app

app = Flask(__name__)
configure_app(app)

from purkinje import models

__version__ = '0.01-dev'
