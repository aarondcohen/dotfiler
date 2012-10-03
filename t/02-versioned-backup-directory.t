use Test::More tests => 5;

use strict;
use warnings;

use Dotfiler;
use File::Temp ();


my $backup_dir = File::Temp->newdir; #('backup-XXXXX', UNLINK => 0, CLEANUP => 0);
my $dotfiler;
my $last_version;

$dotfiler = Dotfiler->new(backup_directory => ''.$backup_dir);

is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 0, 'Backup directory is empty before versioning';
$last_version = $dotfiler->versioned_backup_directory;
is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 1, 'Version is created in backup directory';
is $dotfiler->versioned_backup_directory, $last_version, 'Version is set permamently for the lifetime of the dotfiler';

$dotfiler = Dotfiler->new(backup_directory => ''.$backup_dir);
$dotfiler->versioned_backup_directory;
is scalar $dotfiler->_list_directory($dotfiler->backup_directory), 2, 'New version is created in backup directory for new dotfiler';
cmp_ok $dotfiler->versioned_backup_directory, 'gt', $last_version, 'New version is lexicographically after previous version';
