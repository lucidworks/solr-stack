#!/usr/bin/env python
from resource_management import *

config = Script.get_config()

stack_piddir = "/var/run/solr"
stack_pidfile = format("{stack_piddir}/solr.pid")
