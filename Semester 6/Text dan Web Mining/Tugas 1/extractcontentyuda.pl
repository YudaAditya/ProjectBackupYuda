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

# Modified by Yuda Aditya 2019

use strict;
use warnings;
use HTML::ExtractContent;
use Cwd 'abs_path';
use File::Basename;

$| = 1;
my $count=1;
print "Loading...\n";

# get file
my $dirname = $ARGV[0] or die "Masukkan Folder sumber...";
my $PATHCLEAN = $ARGV[1] or die "Masukkan folder Hasil....";

my $ls = `ls $dirname`;
my @files = split(/\n/,$ls);

foreach my $file (@files){
  print "\nProcessing file-$count\n";
  my $fileout = basename($file).'.bersih.dat';
  print "fileout: [$fileout]\n";
  
  $fileout = "$PATHCLEAN/$fileout";
  print "$fileout\n";

  # open file
  open OUT, "> $fileout" or die "Cannot Open File!!!";

  # object
  my $extractor = HTML::ExtractContent->new;
  my $html = `cat $dirname/$file`;

  #$html = lc($html);  # don't make it lowercase

  $html =~ s/\^M//g;

  # get TITLE
  if( $html =~ /<title.*?>(.*?)<\/title>/){
    my $title = $1;
    $title = clean_str($title);
    print "<title>$title</title>\t$fileout\n";
    print OUT "<title>$title</title>\n";
  }

  # get link
  if( $html =~ /<meta property="og:url" content=(.*?)>/){ # untuk mengambil link yang disimpan pada meta prop
   my $linknya = $1;
    print OUT "<link>$linknya</link>\n";
  }

  # get BODY (Content)
  $extractor->extract($html);
  my $content = $extractor->as_text;
  $content = clean_str($content);
  $content = bagi_content($content);
  #print OUT "<content>$content</content>\n";
  
}

sub clean_str {
  my $str = shift;
  $str =~ s/>//g;
  $str =~ s/&.*?;//g;
  #$str =~ s/[\:\]\|\[\?\!\@\#\$\%\*\&\,\/\\\(\)\;"]+//g;
  $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
  $str =~ s/-/ /g;
  $str =~ s/\n+/ /g;
  $str =~ s/\s+/ /g;
  $str =~ s/^\s+//g;
  $str =~ s/\s+$//g;
  $str =~ s/^$//g;
  return $str;
}
# untuk membagi content
sub bagi_content {
  my $kal = shift;
  my @sref = split m/(?<=[.!?])\s+/m, $kal; #membagi berdasarkan tanda baca dalam []
  my $countKalimat= scalar(@sref);
  my $atribut = sprintf("%.f",$countKalimat/3);
  my $i=0;
  my $atas=0;
  my @kalimat;

  foreach my $sentence (@sref){
     @kalimat[$i]=$sentence;
     $i++;
  }
    print "$i";

  print OUT "\n<content>";

  print OUT "\n<atas>";
  while($atas<$atribut){
      print OUT "\n$kalimat[$atas]";
      $atas++;
  }
  print OUT "\n</atas>";

  print OUT "\n\n<tengah>";
  my $tengah=$atas;
  while($tengah<$atribut*2){
      print OUT "\n$kalimat[$tengah]";
      $tengah++;
  }
  print OUT "\n</tengah>";

  print OUT "\n\n<bawah>";
  my $bawah=$tengah;
  while($bawah<$countKalimat){
      print OUT "\n$kalimat[$bawah]";
      $bawah++;
  }
  print OUT "\n</bawah>";

  print OUT "\n</content>";
  close OUT;
  $count++;
  
}
print "\nTotal file yang telah di bersihkan : ".($count-1)." files\n";
