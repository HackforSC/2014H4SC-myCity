<div class="portfolio-wrapper">

  <?php foreach($values['projects'] as $project) { ?>

  <div class="card film art">
    <a href="/w/project/<?= $project['id'] ?>" class="thumb">
      <img src="<?= $project['photo_url'] ?>" alt="" title="" />
      <span class="overlay"><span class="fa fa-search"></span></span>
    </a>
    <div class="card-body">
      <h2><a href="/w/project/<?= $project['id'] ?>"><?= $project['name'] ?></a></h2>
      <p><?= substr($project['description'], 0, 150) ?>...</p>
              <h5>Raised $<?= number_format($project['total_raised']) ?> of $<?= number_format($project['goal_amount']) ?>.</h5>
              <div class="progress-bar" role="progressbar" aria-valuenow="<?= 100 - $project['percent'] ?>" aria-valuemin="0" aria-valuemax="100" style="width: <?= 100 - $project['percent'] ?>%;">
                <span class="sr-only"><?= 100 - $project['percent'] ?>% Complete</span>
              </div><!-- end progress bar -->
              <div class="progress">
                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="<?= $project['percent'] ?>" aria-valuemin="0" aria-valuemax="100" style="width: <?= $project['percent'] ?>%">
                  <span class="sr-only"><?= $project['percent'] ?>% Complete (success)</span>
                </div><!-- end progress bar -->
              </div><!-- end progress -->
    </div><!-- end card-body -->
    <div class="card-footer">
      <ul class="list-inline filters">
        <li><a href="/w/project/<?= $project['id'] ?>">Learn More</a></li>
      </ul>
    </div><!-- end card-footer -->
  </div><!-- end card -->

  <?php } ?>

</div><!-- end portfolio-wrapper -->