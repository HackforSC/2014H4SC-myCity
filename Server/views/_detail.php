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
    </div><!-- end page-header -->

              <h3>Raised $<?= number_format($values['total_raised']) ?> of $<?= number_format($values['project']['goal_amount']) ?>.</h3>
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
      <div class="col-md-4">
        <ul class="list-unstyled post-meta">
          <li><strong><?= $values['backers'] ?></strong> backers</li>
          <li><span class="fa fa-list-ul"></span>Posted in: <a href="#none">Film</a>, <a href="#none">Social</a></li>
          <li><a href="#none" class="btn btn-default">Launch Project</a></li>
        </ul><!-- end post-meta -->
      </div><!-- end col -->
      <div class="col-md-8">
        <div class="post-content">
           <?= $values['project']['description'] ?>
        </div><!-- end col -->
      </div><!-- end row -->
    </div><!-- end post-content -->
  </article>

          </div><!-- end post -->