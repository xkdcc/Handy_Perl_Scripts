#!/bin/perl

use strict;
use warnings;

while ( 1 ) {
  if( -e "/log/bc_debug" ) {
    print("BC_DEBUG: Continue debug mode...\n");
  }
  else {
    print("BC_DEBUG: exit debug mode...\n");
    last;
  }
}
