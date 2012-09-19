use Test::More tests => 1;

BEGIN {
	use_ok( 'Dotfiler' ) || print "Bail out!\n";
}

diag( "Testing Dotfiler $Dotfiler::VERSION, Perl $], $^X" );
