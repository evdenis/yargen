#!/usr/bin/env perl

my @rules = qw/
DBD::mysql CVE-2015-8949
File::Spec CVE-2015-8607
XML::LibXML CVE-2015-3451
XML::LibXML CVE-2015-3451
Email::Address CVE-2014-4720
Email::Address CVE-2014-0477
Data::Dumper CVE-2014-4330
Net::SNMP CVE-2014-2285
Capture::Tiny CVE-2014-1875
MARC::File::XML CVE-2014-1626
Proc::Daemon CVE-2013-7135
RPC::PlServer CVE-2013-7284
HTTP::Body CVE-2013-4407
Module::Signature CVE-2013-2145
HTML::EP CVE-2012-6142
App::Context CVE-2012-6141
Config::IniFiles CVE-2012-2451
YAML::LibYAML CVE-2012-1152
Proc::ProcessTable CVE-2011-4363
PAR::Packer CVE-2011-4114
Crypt::DSA CVE-2011-3599
Data::FormValidator CVE-2011-2201
FCGI CVE-2011-2766
Digest CVE-2011-3597
HTML::Template::Pro CVE-2011-4616
CGI CVE-2012-5526/;

my @include;
while (my ($m, $c) = splice(@rules, 0, 2)) {
   my $save = $c =~ tr/-/_/r;
   push @include, "include \"./my_yara_rules/$save.yar\"";
   $save = '../FP-community-rules/my_yara_rules/' . $save . ".yar";
   my $exec = "./yargen -m $m -c $c > $save";
   print $exec . "\n";
   `$exec`;
}

print join("\n", @include) . "\n";

##./yargen -m Locale::Maketext  CVE-2012-6329
##./yargen -m Spoon::Cookie  CVE-2012-6143
###./yargen -m Encode  CVE-2011-2939

