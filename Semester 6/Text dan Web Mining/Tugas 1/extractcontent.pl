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
use HTML::ExtractContent;
use File::Basename;

# get file
my $file = $ARGV[0];
my $fileout = basename($file);
print "fileout: [$fileout]\n";

# Directory where clean data are stored, its better to set this in config file
# my $PATHCLEAN = "/home/tfa/Mydoc/Teaching/Semester-Genap-1819/Teks-Mining/clean";
my $PATHCLEAN = "/home/yuda/Downloads/test";

$fileout = "$PATHCLEAN/$fileout";
print "$fileout\n";

# open file
open OUT, "> $fileout" or die "Cannot Open File!!!";

# object
my $extractor = HTML::ExtractContent->new;
my $html = `cat $file`;

#$html = lc($html);  # don't make it lowercase

$html =~ s/\^M//g;

# get TITLE
if( $html =~ /<title.*?>(.*?)<\/title>/){
  my $title = $1;
  $title = clean_str($title);
  print "<title>$title\t$fileout</title>\n";
  print OUT "<title>$title</title>\n";
}


# get BODY (Content)
$extractor->extract($html);
my $content = $extractor->as_text;
$content = clean_str($content);
print OUT "<content>$content</content>\n";

close OUT;


sub clean_str {
  my $str = shift;
  $str =~ s/>//g;
  $str =~ s/&.*?;//g;
  #$str =~ s/[\:\]\|\[\?\!\@\#\$\%\*\&\,\/\\\(\)\;"]+//g;
  $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
  $str =~ s/-/ /g;
  $str =~ s/\n+//g;
  $str =~ s/\s+/ /g;
  $str =~ s/^\s+//g;
  $str =~ s/\s+$//g;
  $str =~ s/^$//g;
  return $str;
}
