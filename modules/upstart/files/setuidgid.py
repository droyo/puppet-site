#!/usr/bin/python

import sys
import os
import pwd
import grp
import optparse

usage = "Usage: %prog [opt] user prog ..."
parser = optparse.OptionParser(usage=usage)
parser.add_option("-g", "--primary-group", dest="group")
parser.add_option("-G", "--secondary-groups", dest="groups")
parser.disable_interspersed_args()

(opt, args) = parser.parse_args()

if len(args) < 2:
  parser.print_usage()
  parser.print_help()
  sys.exit(2)

user = pwd.getpwnam(args[0])
group = user.pw_gid
prog = args[1:]

if opt.group:
  group = grp.getgrnam(opt.group).gr_gid

if opt.groups:
  os.setgroups(grp.getgrnam(name).gr_gid for name in opt.groups.split(','))

os.setgid(group)

os.setuid(user.pw_uid)
os.execvp(prog[0], prog)
