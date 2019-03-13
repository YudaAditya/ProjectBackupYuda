use warnings;
use strict;
use WWW::Mechanize;


my $folder= $ARGV[0] or die "Harap masukan folder yang menjadi tempat menyimpan hasil Crawl !!!";
# my $folder = "/home/yuda/Downloads/TWM/Tugas 1/Samsung/hasil_kompas";

my $mech = WWW::Mechanize->new();
$mech->agent_alias('Windows Mozilla'); #user agent untuk tanda pengenal
my $tanggal = 8;
my $bulan = 3;
my $tahun = 2019;

my $detikReg = "/d-";

# my $keyword = "samsung";
# my $keyword2="galaxy";
my $keyword = "apple";
my $keyword2 = "iphone";
my $keyword3 = "macbook";
my $keyword4 = "watch";
my $keyword5 ="ipad";
my $keyword6 = "ios";
my $keyword7 ="macos";

my $pages = 1111; #batas page dari portal
my $count=1; #hitung page sampain limit

my $web ="https://www.detik.com/search/searchall?query=apple&siteid=5&sortby=time&page";
my $source = "detik";




#fungsi buat crawling
sub webCrawl{
  $mech->get($_[0]);
  my @links = $mech->links();
  my %urls; 

      foreach my $link (@links) {
        my $url = $link->url;
        if ($url=~ $detikReg) {#REGEX Diantara //
            if($url =~ $keyword || $keyword2 || $keyword3 || $keyword4 || $keyword5 || $keyword6 ||$keyword7){
            # if($url =~ $keyword || $keyword2 ){
              $urls{$url}=1; #untuk setiap value dari hash bernilai 1 dengan link sebagai id
            }
        }


      }
      my $i= $_[1]; 
      foreach my $url (keys %urls) {
          system "wget -O $folder/$source-$keyword-$i-$count.html $url";
          # system "wget -O $folder/$source-$keyword-$i.html $url";
        $i++;
      }
      return $i;
}

# perulangan pada tanggal bulan tahun
# my $total=0;
# while ($total<=2000) { #batas dari file yang ingin di crawl
#  $total = webCrawl("$web/$tahun/0$bulan/0$tanggal",$total);# parameter yang dikirim kedalam function
#  $tanggal--;
#  if ($tanggal==0) {
#    $bulan--;
#     if ($bulan==0) {
#       $bulan=12;
#       $tahun--;
#     }
#    $tanggal=27;
#  }

# }


my $total;
  for ($total=1 ; $total <=15000 ; $count++) {
    $total = webCrawl("$web=$count",$total);
    if ($count==$pages) {
      last;
    }
  }

