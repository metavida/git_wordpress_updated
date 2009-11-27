git_wordpress_updated
=====

git_wordpress_updated is a set of bash scripts intended to make it as easy as possible to get your [WordPress](http://wordpress.org) installation updated using [Git](http://git-scm.com/). These scripts are intended to make maintaining WordPress as un-technical as possible. When a new version of WordPress is released simply download it, run one script, visit one URL, then carry on with your day.

A word of warning. The WordPress installation updated by this script should *never* be pointed at directly by Apache. Instead, use this script to maintain your WordPress staging environment. Make whatever tweaks you need in this copy of WordPress and then copy the WordPress installation over your existing, live WordPress installation. There's always a chance that there will be a conflict during the upgrade process. If there is a conflict and you're using this installation as your live blog, your blog could become unusable and you could experience data corruption.

Installation
=====

* git clone git://github.com/metavida/git_wordpress_updated.git
* cd git_wordpress_updated
* chmod u+x run.sh
* chmod u+x lib/*
* run.sh

You'll end up with the latest version of WordPress in the git_wordpress_updated/wordpress_my_install directory.

Tweaking your blog
=====

Tweak the code in the wordpress_my_install directory to your heart's content (updating the config file, installing plugins and themes, tweaking other code as you see fit). As you make changes it would do you good to run the `git commit -a` command now and then.

Upgrading WordPress
=====

When a new version of WordPress is released the power of Git really shines.

* Download the latest tar.gz from [WordPress](http://wordpress.org/download/) and place it in the git_wordpress_updated/wordpress_tars directory.
* run.sh

That's it. Assuming there were no conflicts, the code in the git_wordpress_updated/wordpress_my_install directory is now running the latest code from WordPress, including your modifications.

Resources & Useful links
=====

* [The article ](http://www.matusiak.eu/numerodix/blog/index.php/2008/09/21/git-by-example-keeping-wordpress-up-to-date/) that inspired me to write these scripts.
* [A backup script](http://www.guyrutenberg.com/2008/05/07/wordpress-backup-script/) that I modified.

License
=====

Copyright (c) 2009 Marcos Wright-Kuhns

This code is free to use under the terms of the MIT license.