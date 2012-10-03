use Test::More tests => 9;

use strict;
use warnings;

use Dotfiler;
use File::Temp ();
use FindBin ();

sub cat_to_file {
	my ($file, $value) = @_;
	open(my $out, '>>', $file) || die "Failed to open test file [$file] - $!";
	print $out $value;
	close $out;
}

my $dotfiler;
my $backup_dir = File::Temp->newdir; #('backup-XXXXX', UNLINK => 0, CLEANUP => 0);
my $install_dir = File::Temp->newdir; #('install-XXXXX', UNLINK => 0, CLEANUP => 0);
my $source_dir = "$FindBin::Bin/source/";

$dotfiler = Dotfiler->new(backup_directory => ''.$backup_dir, install_directory => ''.$install_dir);

ok ! $dotfiler->_list_directory($dotfiler->install_directory), 'Install directory starts empty';
ok ! $dotfiler->_list_directory($dotfiler->backup_directory), 'Backup directory starts empty';

ok $dotfiler->install($source_dir), 'installation from source succeeds';

ok $dotfiler->backup($source_dir), 'backup from source succeeds';
is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 0, 'Backup of a matching installation creates no backup';

$dotfiler = Dotfiler->new(backup_directory => ''.$backup_dir, install_directory => ''.$install_dir);
cat_to_file($dotfiler->install_directory . "test.txt", "\nsome more stuff\n");
$dotfiler->backup($source_dir);
is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 1, 'Backup of a differing installation creates a backup';

$dotfiler = Dotfiler->new(backup_directory => ''.$backup_dir, install_directory => ''.$install_dir);
cat_to_file($dotfiler->install_directory . "test.txt", "\nand some more stuff\n");
$dotfiler->backup($source_dir);
is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 2, 'Installation differing from most recent backup creates a backup';

$dotfiler = Dotfiler->new(backup_directory => ''.$backup_dir, install_directory => ''.$install_dir);
ok $dotfiler->install($dotfiler->backup_directory . ($dotfiler->_list_directory($dotfiler->backup_directory))[0]), 'Installation from backup succeeds';
$dotfiler->backup($source_dir);
is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 3, 'Installation from an old backup forces a new backup';





