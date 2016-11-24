{
  package Math::RPN::Class;

  use strict;
  use warnings;
  use utf8;
  use Data::Dumper;

  my @SIGNS = qw(+ - * / % ++ --);

  sub new {
    my ($class, %args) = @_;
    my $self = {
      stack       => [],
      accumulator => undef,
      delimiter   => ' ',
      %args,
    };
    bless $self, $class;
  }

  sub eval {
    my ($self, @expression) = @_;
    my $signs = do {
      if (@expression == 1) {
        [split /$self->{delimiter}/, $expression[0]];
      } else {
        \@expression;
      }
    };
    $self->push_stack($_) for @$signs;
    $self->result;
  }

  sub result {
    my ($self) = @_;
    my $result = $self->{accumulator};
    $self->{accumulator} = undef;
    $self->{stack} = [];
    $result;
  }

  sub push_stack {
    my ($self, $sign) = @_;
    my @is_sign = grep { $sign eq $_ } @SIGNS;
    if (@is_sign) {
      $self->calc($sign);
    } else {
      push @{ $self->{stack} }, $sign;
    }
  }

  {
    my %switch_calc = (
      '+' => sub {
        my ($self) = @_;
        $self->{accumulator} = pop(@{ $self->{stack} }) + $self->{accumulator};
      },
      '-' => sub {
        my ($self) = @_;
        $self->{accumulator} = pop(@{ $self->{stack} }) - $self->{accumulator};
      },
      '*' => sub {
        my ($self) = @_;
        $self->{accumulator} = pop(@{ $self->{stack} }) * $self->{accumulator};
      },
      '/' => sub {
        my ($self) = @_;
        $self->{accumulator} = pop(@{ $self->{stack} }) / $self->{accumulator};
      },
      '%' => sub {
        my ($self) = @_;
        $self->{accumulator} = pop(@{ $self->{stack} }) % $self->{accumulator};
      },
      '++' => sub {
        my ($self) = @_;
        $self->{accumulator}++;
      },
      '--' => sub {
        my ($self) = @_;
        $self->{accumulator}--;
      },
    );
  
    sub calc {
      my ($self, $sign) = @_;
      $self->{accumulator} = pop @{ $self->{stack} };
      my $sub = $switch_calc{$sign};
      $self->$sub;
      push @{ $self->{stack} }, $self->{accumulator};
    }
  }

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Math::RPN::Class - Perl extension for Reverse Polish Math Expression Evaluation by OO system.

=head1 method

=cut
