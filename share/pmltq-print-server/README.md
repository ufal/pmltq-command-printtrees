# Print Server

Server for serving PML trees in SVG. This server is integral part of PML-TQ.

The whole server is written as a bTrEd script and requires working TrEd environment in order to work. All the extensions you would usually require to display a tree in a TrEd you will need here + a virtual X framebuffer (Xvfb).

# Parameters

- `--port` port to run on, defaults to **8070**
- `--host` what to bind to, defaults to **localhost**
- `--data-dir` directory with PML files **required**
- `--db-dsn` connection string, e.g. `dbi:Pg:dbname=pmltq_server;host=localhost;port=5432;`
- `--db-user` database user
- `--db-password` database password
- `--cache-dir` directory for cashed SVGs

If you don't want to pass database connection as parameters, you can use environment variables: `DB_DSN`, `DB_USER`, `DB_PASSWORD`. 

# Installation

1. Installing [TrEd](http://ufal.mff.cuni.cz/tred/) is tedious task in itself. The package is not maintained very well and there is no alternative. 
    
    - Download source code from SVN

            svn co https://svn.ms.mff.cuni.cz/svn/TrEd/trunk/tred_refactored

    - You will need development tools and several dev packages

        For Ubuntu/Debian users:

            sudo apt-get install libx11-dev libxft-dev libfontconfig1-dev libpng12-dev zlib1g-dev libxml2-dev

        For Fedora/Redhat users:

            sudo yum install perl-core wget gcc patch libX11-devel libXft-devel libpng-devel libxml2-devel zlib-devel perl-libwww-perl

    - Make bTrEd work

        Install following Perl packages using `cpan` or `cpanm`.

            cpanm -n Tk Archive::Zip File::HomeDir File::ShareDir Treex::PML PMLTQ XML::LibXML Graph Graph::ChuLiuEdmonds

    - Run bTrEd

        Unless this command works, print server won't work.
              
            ./btred --help


2. Install Xvfb (Virtual Framebuffer)

    For Ubuntu/Debian users:
      
        sudo apt-get install xvfb

    For Fedora/Red users:

        yum install xorg-x11-server-Xvfb

    After installing the `xvfb-run` script should be available.

3. You will need ideally need [PML-TQ Server](https://github.com/ufal/perl-pmltq-server), [PML-TQ Web](https://github.com/ufal/perl-pmltq-web) and PostgreSQL. But all it is required is PostgreSQL.

    For Ubuntu/Debian users:
      
        sudo apt-get install postgresql

    For Fedora/Red users:

        yum install postgresql

    We use [Ubic](https://metacpan.org/pod/Ubic) script to start/stop the print server. 

    ```.perl

    use Ubic::Service::SimpleDaemon;

    my $server_dir="/opt/print-server";
    my $data_dir="/opt/pmltq-data";
    my $tred_dir="/opt/tred_refactored";

    my $extensions="pdt20,pdt25,pdt30";

    my $resources = join ':', grep { -d $_ } glob("$data_dir/*/resources");
    $resources //= '-'; 

    my $db_dsn = 'dbi:Pg:dbname=pmltq_server;host=localhost;port=5432;';
    my $db_user = 'pmltq';
    my $db_password = '';

    my $service = Ubic::Service::SimpleDaemon->new(
      bin => "xvfb-run $tred_dir/btred --warn-only -c btred.rc -Z $resources -m print_srvr_simple.btred --enable-extensions $extensions -o --host '*' --cache-dir svg_cache --data-dir '$data_dir' --",
      env => {
        DB_DSN => $db_dsn,
        DB_USER => $db_user,
        DB_PASSWORD => $db_password,
      },
      stdout => '/home/pmltq/ubic/log/print.log',
      stderr => '/home/pmltq/ubic/log/print.err.log',
      ubic_log => '/home/pmltq/ubic/log/print.ubic.log',
      cwd => $server_dir
    );

    ```

    You are of course free to make your own script. Something like:

        export DB_DSN="dbi:Pg:dbname=pmltq_server;host=localhost;port=5432;"
        export DB_USER="pmltq"
        export DB_PASSWORD=""

        xvfb-run btred -m print_srvr_simple.btred -o --host '*' --cache-dir svg_cache --data-dir pmltq/data --

    Wrapping this with `nohup` you can easily run this forever.