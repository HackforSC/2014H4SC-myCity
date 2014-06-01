<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>myCity</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Le styles -->
    <link href="/static/css/bootstrap.css" rel="stylesheet">
    <link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
    <!--[if IE 7]>
      <link rel="stylesheet" href="css/font-awesome-ie7.min.css">
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="/static/css/style.css" />
    
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
      <script src="js/respond.src.js"></script>
    <![endif]-->

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
    <script src="/static/js/bootstrap.js"></script>
    <script src="/static/js/rebound.js"></script>
    
  </head>

  <body>
  
    <div class="wrapper">
      <div class="row">
        <div class="col-md-3 sidebar">
          <div class="navbar" role="navigation">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#rebound-navbar-collapse"><span class="fa fa-bars"></span> Menu</button>
              <a href="/" class="navbar-brand"><img src="/static/img/mycity.png" alt="logo"></a>
            </div><!-- end navbar-header -->
            <div class="collapse navbar-collapse" id="rebound-navbar-collapse">
              <ul class="nav navbar-nav">
                <li class="title">Menu</li>
                <li><a href="/">Home</a></li>
                <li><a href="/w/request">Request Project</a></li>
                <li><a href="/w/about">About myCity</a></li>
                <li><a href="/w/contact">Contact Us</a></li>
              </ul>
              <ul class="nav navbar-nav">
                <li class="title">Total Projects</li>
                <li><span class="important-stuff"><?= $values['project_count'] ?></span></li>
              </ul>
              <ul class="nav navbar-nav">
                <li class="title">Total Raised</li>
                <li><span class="important-stuff">$<?= number_format($values['donations_total']) ?></span></li>
              </ul>
              <ul class="nav navbar-nav">
                <li class="title">Cities</li>
                <li><a href="/">Columbia, SC</a></li>
              </ul>
              <ul class="nav navbar-nav nav-social hidden-sm hidden-xs">
                <li class="title">Social</li>
                <li><a href="#">Twitter</a></li>
                <li><a href="#">Facebook</a></li>
              </ul>
              <ul class="nav navbar-nav nav-social hidden-sm hidden-xs">
                <li><img class="img img-responsive appstorelogo" src="/static/img/appstore.png" alt="Available on App Store."></li>
              </ul>
            </div><!-- end navbar-collapse -->
          </div><!-- end navbar -->
        </div><!-- end col -->
        <div class="col-md-9 content">

          <?php include($content_for_layout . '.php'); ?>

        </div><!-- end col -->
      </div><!-- end row -->
    </div><!-- end wrapper -->
    
    <footer class="hidden-xs">
      <p class="pull-left">Made in Columbia. In very little time.</p>
    </footer>
    
    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->

    <script src="/static/js/jquery.isotope.min.js"></script>
    <script type="text/javascript">
      
      $(document).ready(function() {
        
        $('.dropdown-toggle').dropdown();
        
        var $container = $('.portfolio-wrapper');
        
        $container.imagesLoaded( function(){
          $container.isotope({
            itemSelector : '.card',
            layoutMode : 'fitRows'
          });
        });
        
        // Needed functions
        var getColWidth = function() {
          var width,
          windowWidth = $(window).width();
          if( windowWidth <= 480 ) {
            width = Math.floor( $container.width() );
          } else if( windowWidth <= 768 ) {
            width = Math.floor( $container.width() );
          } else {
            width = Math.floor( 250 );
          }
          return width;
        }

        function setWidths() {
          var colWidth = getColWidth();
          $container.children().css({ width: colWidth });
        }

    
        $(window).smartresize(function() {
          setWidths();
          $container.isotope({
            masonry: {
              columnWidth: getColWidth()
            }
          });
        });
        
        $('.filter-portfolio li a').click(function(){
          $('.filter-portfolio li.active').removeClass('active');
          $(this).parent('li').addClass('active');
          var selector = $(this).attr('data-filter');
          $container.isotope({
            filter: selector,
            masonry: {  }
          });
          return false;
        });
        // update columnWidth on window resize
        $(window).smartresize(function(){
          $container.isotope({
            // update columnWidth to a percentage of container width
            masonry: {  }
          });
        });
        
      });
      
    </script>

  </body>
</html>
