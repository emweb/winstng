# Configuration arguments for vcbuild.
use strict;
use warnings;

our $config = {
	asserts => 0,    # --enable-cassert
	ldap      => 0,        # --with-ldap
	openssl   => '@WINST_PREFIX@',    # --with-openssl=<path>
};

1;
