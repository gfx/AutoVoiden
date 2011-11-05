package main;
use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;
use Amon2::Lite;

# put your configuration here
sub config {
    +{
    }
}
sub InHankakuKatakana { "FF65\tFF9F" }

sub transform {
    my($s) = @_;
    $s =~ s/\p{InHankakuKatakana}/〓/g;
    return $s;
}

get '/' => sub {
    my $c = shift;
    my $body = $c->request->param('body');
    my %param = (
        body        => $body,
        transformed => transform($body),
    );

    return $c->render('index.tt', \%param);
};

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;
        $res->header( 'X-Content-Type-Options' => 'nosniff' );
        $res->header( 'X-Frame-Options' => 'DENY' );
    },
);

# load plugins
#__PACKAGE__->load_plugins(
#    'Web::CSRFDefender',
#);

builder {
    enable 'Plack::Middleware::Static',
        path => qr{^(?:/static/|/robot\.txt$|/favicon\.ico$)},
        root => File::Spec->catdir(dirname(__FILE__));
    enable 'Plack::Middleware::ReverseProxy';
    #enable 'Plack::Middleware::Session';

    __PACKAGE__->to_app();
};

__DATA__

@@ index.tt
<!doctype html>
<html>
<head>
    <met charst="utf-8">
    <title>AutoVoiden</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h1>半角カナを〓に置き換えるよ</h1>
    <form action="" method="GET">
    <textarea name="body">[% $body // '' %]</textarea>
    <input type="submit" />
    <hr />
    <p>[% $transformed // '(text)' %]</p>
    </form>
</body>
</html>
