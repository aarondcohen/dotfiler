use Test::More tests => 12;

use strict;
use warnings;

use Dotfiler;

my ($dotfiler, $value);

$dotfiler = Dotfiler->new;

lives_ok { $dotfiler->backup_directory } "Attribute backup_directory is defined";
lives_ok { $dotfiler->dot_symbol } "Attribute dot_symbol is defined";
lives_ok { $dotfiler->is_debug } "Attribute is_debug is defined";
lives_ok { $dotfiler->install_directory } "Attribute install_directory is defined";

is $dotfiler->from_dot('/some/.directory/.hidden/foo.txt'), '/some/.directory/.hidden/foo.txt', 'from_dot is the identity function without a dot_symnbol';
is $dotfiler->to_dot('/some/.directory/.hidden/foo.txt'), '/some/.directory/.hidden/foo.txt', 'to_dot is the identity function without a dot_symnbol';

$dotfiler->dot_symbol('<DOT>');

is $dotfiler->to_dot('/some/<DOT>directory/<DOT>hidden/foo<DOT>bar.txt'), '/some/.directory/foo<DOT>.txt', 'to_dot converts all starting symbols to .';
is $dotfiler->from_dot('/some/.directory/.hidden/foo.bar.txt'), '/some/<DOT>directory/<DOT>hidden/foo.bar.txt', 'from_dot converts all starting . to symbols';

is $dotfiler->to_dot($dotfiler->from_dot('/some/.directory/foo.txt')), '/some/.directory/foo.txt', '';
is $dotfiler->from_dot($dotfiler->to_dot('/some/<DOT>directory/foo.txt')), '/some/<DOT>directory/foo.txt', '';

=head



is $dotfiler->backup_directory(undef), undef, "";
is $dotfiler->backup_directory(''), '/', "";
is $dotfiler->backup_directory('/some/directry'), './', "";

$value = "";
lives_ok { $dotfiler->backup_directory($value) } "";
is $dotfiler->backup_directory, $value, "";

$value = "";
lives_ok { $dotfiler->dot_symbol($value) } "";
is $dotfiler->dot_symbol, $value, "";

$value = "";
lives_ok { $dotfiler->install_directory($value) } "";
is $dotfiler->install_directory, $value, "";

$dotfiler = Dotfiler->new(
	backup_directory => "",
	dot_symbol => "",
	install_directory => "",
	source_directory => "",
);

is $dotfiler->backup_directory, $value, "";
is $dotfiler->dot_symbol, $value, "";
is $dotfiler->install_directory, $value, "";
