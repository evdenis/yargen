#!/usr/bin/env perl

use warnings;
use strict;

use Mojo::UserAgent;
use Data::Printer;
use File::Slurp qw/write_file/;
use Storable qw/store retrieve/;

my $module = 'File::Serialize';
my $dump = $module . '.dump';
my @modules;

if (-f $dump) {
   @modules = @{retrieve($dump)};
}

unless (@modules) {
   my $ua = Mojo::UserAgent->new();
   my $r = $ua->get('https://metacpan.org/pod/' . $module);
   if ($r->success && $r->res->code() == 200) {
      my $cl = $r->res->dom
                      ->find('div.release.status-latest.maturity-released select option')
                      ->map(attr => 'value')
                      ->compact()
                      ->map(sub{s!^/module!https://api.metacpan.org/source!r})
                      ->sort()
                      ->uniq();
      @modules = $cl->map(sub {
            my $r = $ua->get($_);
            if ($r->success && $r->res->code() == 200) {
               $r->res->body
            } else {
               undef
            }
         }
      )->each();
      store \@modules, $dump;
   }
}

foreach(@modules) {
   if (/^.*?v(?:e(?:r(?:s(?:i(?:o(?:n)?)?)?)?)?)?\h*=\h*(?:['"])([^'"]++)(?:['"])\h*;.*$/pim) {
      print "${^MATCH}\n";
   } else {
      die "FAIL"
   }
}

