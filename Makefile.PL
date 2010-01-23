# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name 'Niget-Web
all_from 'lib/Niget/Web.pm

requires $_
    for qw/
        autobox::String::Inflector
        parent
        DateTime
        Data::Page::Navigation
        DBIx::Class
        DBIx::Class::Schema::Loader
        Catalyst::Action::RenderView
        Catalyst::Engine::HTTP::Restarter
        Catalyst::Devel
        Catalyst::Plugin::ConfigLoader
        Catalyst::Plugin::FillInForm
        Catalyst::Plugin::Static::Simple
        Config::General
        Task::Catalyst
        Template
    /;

requires 'Catalyst::Runtime' => '5.7014';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
