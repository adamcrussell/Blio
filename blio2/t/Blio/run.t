#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Test::Most;
use Test::File;

use lib qw(t);
use testlib;

use Path::Class;

my $blio = testlib::blio('site1');


$blio->run;

file_exists_ok( $blio->output_dir->file('blog.html') );
file_exists_ok( $blio->output_dir->file('movies.html') );
file_exists_ok( $blio->output_dir->file('books.html') );
file_exists_ok( $blio->output_dir->file('books/un_lun_dun.html') );
file_exists_ok( $blio->output_dir->file('books/artemis_fowl.html') );

done_testing();
