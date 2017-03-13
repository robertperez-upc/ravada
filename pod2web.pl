#!/usr/bin/perl


# Create html from pod file from lib
# Execute outside repo and copy manually all html file generated to gh-pages branch
# in navigating directory


use strict; use warnings;
use autodie;

use File::Spec::Functions qw( canonpath );
use File::Basename;
use HTML::Template;
use Pod::Find qw(pod_find simplify_name);
use Pod::Select;
use Pod::Html;
use Pod::Xhtml;

my $mod_top = canonpath 'ravada/lib/';
my $html_top = './';

my %pods = pod_find($mod_top);
my @pods;
my $parser = new Pod::Xhtml;

for my $pod ( sort keys %pods ) {
    (my $link = $pod) =~ s/^\Q$mod_top//;
    $link =~ s/\.\w+\z//;
    $link = basename($link);
    $link = "${html_top}${link}.html";

    $parser->parse_from_file( $pod, $link);

    my $name;
    {
        local *STDOUT;
        open STDOUT, '>', \$name;
        podselect({-sections => [ 'NAME' ] }, $pod);
    }
    $name = '' unless defined $name;
    $name =~ s/^=head1\s+NAME\s+//;
    $name =~ s/\s+\z//;

    push @pods, {
        POD => $pods{$pod},
        NAME => $name,
        LINK => $link,
    };
}

my $tmpl = HTML::Template->new(scalarref => \ <<EO_TMPL
<!DOCTYPE html>
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Ravada Navigation">
  <meta name="author" content="RVD Team">

  <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
  <link rel="canonical" href="index.html">

  <title>RAVADA VDI</title>

  <!-- Bootstrap Core CSS - Uses Bootswatch Flatly Theme: http://bootswatch.com/flatly/ -->
  <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom  -->
  <link href="../css/freelancer.min.css" rel="stylesheet">
  <link href="../css/rvd.css" rel="stylesheet">

  <!-- Custom Fonts -->
  <link href="../vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css">
  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
  <![endif]--> 
</head>

<body id="page-top" class="index" cz-shortcut-listen="true">

  <!-- Navigation -->
<nav id="mainNav" class="navbar navbar-default navbar-fixed-top navbar-custom">
<div class="container">
  <!-- Brand and toggle get grouped for better mobile display -->
  <div class="navbar-header page-scroll">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="../index.html"> <i class="fa fa-play-circle"></i>  <span class="light">Ravada</span> VDI</a>
  </div>

  <!-- Collect the nav links, forms, and other content for toggling -->
  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav navbar-right">
          <li class="hidden active">
              <a href="../index.html#page-top"></a>
          </li>
          <li class="page-scroll">
              <a href="../index.html#about">About</a>
          </li>
          <li class="page-scroll">
              <a href="../index.html#portfolio">Features</a>
          </li>
          <li class="page-scroll">
              <a href="../index.html#get-started">Get Started</a>
          </li>
          <li class="page-scroll">
              <a href="../index.html#devel-features">Developers</a>
          </li>
          <li class="page-scroll">
              <a href="../index.html#help">Help</a>
          </li>
          <li>
              <a href="https://twitter.com/ravada_vdi"><i class="fa fa-twitter"></i></a>
          </li>
      </ul>
  </div>
  <!-- /.navbar-collapse -->
</div>
<!-- /.container-fluid -->
</nav>

  <header class="breadcrumb-header">
      <div class="container">
        <ol class="breadcrumb">
          <li><a href="../index.html">Home</a></li>
          <li><a href="../index.html#get-started">Getting Started</a></li>
          <li class="active">Navigation the code</li>
        </ol>
        <div class="row">
            <div class="col-lg-12 text-center">
                <h1>Navigating Ravada</h1>
                <hr class="star-primary">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
<h1><TMPL_VAR CATEGORY></h1>
<dl>
<TMPL_LOOP PODS>
<dt><a href="<TMPL_VAR LINK>"><TMPL_VAR POD></a></dt>
<dd><TMPL_VAR NAME></dd>
</TMPL_LOOP>
</ul>
</div>
</div>
</div>
</header>
<!-- Footer -->
<footer class="text-center">
  <div class="footer-below">
    <div class="container">
      <div class="row">
        <div class="col-lg-4 col-lg-offset-2">

        </div>
        <div class="col-lg-6">
          <p class="footer-p">
            Copyright © RavadaVDI 2017
          </p>
          <p class="footer-p">
            <a href="https://github.com/frankiejol/ravada/releases"><img src="https://img.shields.io/badge/version-0.1.0--alpha-brightgreen.svg"></a>
            <a href="https://github.com/frankiejol/ravada/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-GPL%20v3-blue.svg"></a>
          </p>
          <p class="footer-p">
            Site theme is adapted from the <a href="http://startbootstrap.com/template-overviews/freelancer/">Freelancer</a> theme by <a href="http://startbootstrap.com/">Start Bootstrap</a>.
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- Scroll to Top Button (Only visible on small and extra-small screen sizes) -->
  <div class="scroll-top page-scroll visible-xs visible-sm">
    <a class="btn btn-primary" href="#page-top">
      <i class="fa fa-chevron-up"></i>
    </a>
  </div>

  <!-- Placed at the end of the document so the pages load faster -->
  <!-- jQuery -->
  <script src="../vendor/jquery/jquery.min.js"></script>

  <!-- Bootstrap Core JavaScript -->
  <script src="../vendor/bootstrap/js/bootstrap.min.js"></script>

  <!-- Plugin JavaScript -->
  <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>

  <!-- Custom Theme JavaScript -->
  <script src="../js/freelancer.js"></script>
</footer>
</body></html>
EO_TMPL
);

$tmpl->param(
    CATEGORY => 'LIBS',
    PODS => \@pods,
);
$tmpl->output(print_to => \*STDOUT);
