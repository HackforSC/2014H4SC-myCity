<div class="page">
  <article>
    <div class="page-header">
      <div id="portfolio-carousel" class="carousel slide" data-ride="carousel">
        <!-- Wrapper for slides -->
        <div class="carousel-inner">
          <div class="item active">
            <img src="<?= $values['project']['photo_url'] ?>" alt="" />
          </div><!-- end item -->
        </div>
      </div><!-- end carousel -->
      <h1><?= $values['project']['name'] ?></h1>
      <p class="lead"><span class="fa fa-map-marker"></span><?= $values['location']['name'] ?></p>
    </div><!-- end page-header -->

              <h3>Raised $<?= number_format($values['project_donations']) ?> of $<?= number_format($values['project']['goal_amount']) ?> from <?= $values['backers'] ?> backers.</h3>
              <div class="progress-bar" role="progressbar" aria-valuenow="<?= 100 - $values['percent'] ?>" aria-valuemin="0" aria-valuemax="100" style="width: <?= 100 - $values['percent'] ?>%;">
                <span class="sr-only"><?= 100 - $values['percent'] ?>% Complete</span>
              </div><!-- end progress bar -->
              <div class="progress">
                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="<?= $values['percent'] ?>" aria-valuemin="0" aria-valuemax="100" style="width: <?= $values['percent'] ?>%">
                  <span class="sr-only"><?= $values['percent'] ?>% Complete (success)</span>
                </div><!-- end progress bar -->
              </div><!-- end progress -->
              <div class="space-40"></div>
    <div class="row">
      <div class="col-md-12">
        <div class="post-content">
           <?= $values['project']['description'] ?>
        </div><!-- end col -->
      </div><!-- end row -->
    </div><!-- end post-content -->
  </article>

          </div><!-- end post -->