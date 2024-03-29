use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'AutoVoiden',
    AUTHOR        => 'Some Person <person@example.com>',
    VERSION_FROM  => 'app.psgi',
    PREREQ_PM     => {
        'Amon2'                           => '3.16',
        'Text::Xslate'                    => '1.4001',
        'Text::Xslate::Bridge::TT2Like'   => '0.00008',
        'Plack::Middleware::ReverseProxy' => '0.09',
        'Time::Piece'                     => '1.20',
        'HTML::FillInForm::Lite'          => '1.09',
        'Plack::Session'                  => '0.14',
        'Plack::Middleware::ReverseProxy' => '0.10',
        'JSON'                            => 2,
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
