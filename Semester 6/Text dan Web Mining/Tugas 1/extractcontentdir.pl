#!/usr/bin/perl
#
# Program ini digunakan untuk mengekstrak bagian konten dari sebuah file HTML
#
# Author: Taufik Fuadi Abidin
# Department of Informatics
# College of Science, Syiah Kuala Univ
#
# Date: Mei 2011
# http://www.informatika.unsyiah.ac.id/tfa
#
# Dependencies:
# INSTALASI HTML-EXTRACTCONTENT
# See http://www.cpan.org/
#
# 1. Download HTML-ExtractContent-0.10.tar.gz and install
# 2. Download Exporter-Lite-0.02.tar.gz and install
# 3. Download Class-Accessor-Lvalue-0.11.tar.gz and install
# 4. Download Class-Accessor-0.34.tar.gz and install
# 5. Download Want-0.18.tar.gz and install
#

use strict;
use warnings;
use Cwd 'abs_path';
use HTML::ExtractContent;
use File::Basename;

$| = 1;
my $count=1;

print "\n";
print "Loading...\n";
# get file
my $source = $ARGV[0] or die "Please input the source directory!!!";
my $dest = $ARGV[1] or die "Please input the destination directory!!!";

my $ls = `ls $source`;
my @files = split(/\n/,$ls);
foreach my $file (@files){
  print "\nMemproses file ke-$count\n";
  chomp $file;
  my $fileout = basename($file);
  # print "fileout: [$fileout]\n";

  # Directory where clean data are stored, its better to set this in config file

  $fileout = "$dest/$fileout";
  # print "$fileout\n";

  # open file
  open OUT, "> $fileout" or die "Cannot Open File!!!";

  # object
  my $extractor = HTML::ExtractContent->new;
  my $html = `cat $source/$file`;

  $html = lc($html);

  $html =~ s/\^M//g;

  # get TITLE
  if( $html =~ /<title.*?>(.*?)<\/title>/){
    my $title = $1;
    $title = clean_str($title);
    # print "<title>$title\t$fileout</title>\n";
    print OUT "<title>$title</title>\n";
  }

  # get BODY (Content)
  $extractor->extract($html);
  my $content = $extractor->as_text;
  $content = clean_str($content);
  print OUT "<content>$content</content>\n";

  close OUT;
  $count++;

}

sub clean_str {
  my $str = shift;
  $str =~ s/>//g;
  $str =~ s/&.*?;//g;
  #$str =~ s/[\:\]\|\[\?\!\@\#\$\%\*\&\,\/\\\(\)\;"]+//g;
  $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
  $str =~ s/-|_/ /g;
  $str =~ s/\n+//g;
  $str =~ s/\s+/ /g;
  $str =~ s/^\s+//g;
  $str =~ s/\s+$//g;
  $str =~ s/^$//g;
  return $str;
}
$count--;
print "\nSelesai membersihkan ".($count-1)." file dalam directori ".abs_path($source)." dan memasukkannya ke dalam directori \"".abs_path($dest)."\"\n";
