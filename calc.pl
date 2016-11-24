use v5.14;;
use warnings;
use utf8;
binmode STDOUT, ':utf8';
binmode STDIN, ':utf8';
use lib './lib';
use Math::RPN::Class;

say "後置記法の式を入力してください。";

my $calculator = Math::RPN::Class->new;
print "> ";
while (chomp(my $expression = <STDIN>)) {
  last if $expression eq 'exit';
  say $calculator->eval($expression);
  print "> ";
}
