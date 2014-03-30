# Sieve filter for mailing lists; automatically identify
# e-mails from a mailing list and store it in ml.<name>

require ["fileinto", "envelope", "imap4flags", "regex", "variables"];

if exists "list-id" {
	setflag "\\Seen";
	if header :regex "list-id" "<([a-zA-Z0-9-]+)[.@]" {
		set :lower "listname" "${1}";
		fileinto :create "ml.${listname}";
	} elsif header :regex "list-id" "^\\s*<?([a-zA-Z0-9]+)[.@]" {
		set :lower "listname" "${1}";
		fileinto :create "ml.${listname}";
	} else {
		fileinto :create "ml.unknown";
	}
	stop;
} elsif exists "x-list-id" {
	setflag "\\Seen";
	if header :regex "x-list-id" "<[a-zA-Z0-9-]+)\\\\." {
		set :lower "listname" "${1}";
		fileinto :create "ml.${listname}";
	} else {
		fileinto :create "ml.unknown";
	}
	stop;
} elsif exists "mailing-list" {
	if header :regex "mailing-list" "([a-zA-Z0-9-]+)@" {
		set :lower "listname" "${1}";
		fileinto :create "ml.${listname}";
	} else {
		fileinto :create "ml.unknown";
	}
	stop;
} elsif exists "x-mailing-list" {
	if header :regex "x-mailing-list" "^\\s*([a-zA-Z0-9-]+)@?" {
		set :lower "listname" "${1}";
		fileinto "ml.${listname}";
	} else {
		fileinto "ml.unknown";
	}
	stop;
} 
