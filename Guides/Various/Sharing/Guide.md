Sharing Setup Guide
======================

### Notes:

>Sharing is used to share comments from your site with other sites, or to fetch comments from other sites.

### Guide:

>First, in a terminal, head to the update folder:
>>`cd /var/www/nZEDb/misc/update/`

>Run the sharing script, it will display nothing, but it will initiate your database with required information.
>>`php postprocess.php sharing true`

>On your website, head to the admin Sharing Settings page (http://IpAddressOfYourServer/admin/sharing.php)

>Click on `[Enable]` to the right of `Enabled:` so it displays `[Disable]`.

>Change the other settings based on your judgement.

>**If you are using tmux**, head to the tmux edit page (http://IpAddressOfYourServer/admin/tmux-edit.php), change `Comment Sharing` to `yes`.

>**If you are _not_ using tmux**, if you run the scripts manually, you can fetch new comments using postprocess.php sharing true, or update_releases.php 1 true, if you are running the screen scripts, if they are running postprocess or update_releases, they should be fetching comments.

### Conclusion:

>The first few runs of "sharing" might not fetch any comments, this is normal as the comments are posted on usenet, and other people are posting stuff (like applications/games/etc) in the same group, so we have to go through other people's messages before finding comments.

>If you have enabled backfill, it will take a long time to fetch all the comments (there are tens of thousands of comments).