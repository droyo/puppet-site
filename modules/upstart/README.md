Module upstart manages Upstart services.

# Usage

node mynode {
  include upstart
  
  upstart::service {'sleep':
    command => 'sleep +inf',
    user => 'nobody',
    group => 'nobody',
    directory => '/opt',
  }
}

# Parameters:

	ensure:        running, stopped(required)

The following parameters can be used to generate a service file.

	desc:             service description
	user:             user to run service as
	group:            primary group to run service as
	command:          command to run
	respawn:          restart service if it crashes
	directory:        working directory of service
	secondary_groups: secondary groups of service user

Alternatively, the service file can be given verbatim, with the `content`
or `source` parameters, analagous to the `file` resource.

A wrapper init.d script will be created as well, so that 
`service foo stop|start` works as expected.

This module also contains the utility script /usr/local/bin/setuidgid.py.
It is used for setting the user/group of a process before executing it.
Specifying any of the user, group, or secondary_group options will cause
it to be used in the generated service file. You should always run services
as a non-root user.
