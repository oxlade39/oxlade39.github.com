---
layout: post
title: Jekyll, Github, Plugins and automated deployment
categories: blogging
tags: jekyll blog blogging ruby code rake github
---
[Jekyll](https://github.com/mojombo/jekyll) provides extension points via [plugins](https://github.com/mojombo/jekyll/wiki/Plugins). Allowing you to create custom content and enrich the document generation model. 

Unfortunately if you're deploying your site to [Github pages](http://pages.github.com/) these plugins aren't supported. Specifically, Github generates your site using the `--safe` Jekyll [configuration](https://github.com/mojombo/jekyll/wiki/Configuration) flag.

I found a couple of posts on how other people get around this; [this](http://ilkka.github.com/blog/2010/11/20/hosting-a-jekyll-blog-with-extensions-on-github/) one being the most helpful. However I couldn't get any of them to work.

The standard approach appears to be to create a branch (say `source`) and then add a [git submodule](http://book.git-scm.com/5_submodules.html) which references your remote master, making Jekyll generate your site to the submodule directory.

Jekyll, when generating your site, clobbers the `_site/.git` directory each time it generates the content. This means your git submodule is destroyed and seems to render the whole process void.

After a bit longer scouring the web I decided I'd just script up a process that would work for me based on the above submodule.

I was pretty fed up of being sidetracked at this point so I took the pragmatic approach and hacked together a [rakefile](http://rake.rubyforge.org/files/doc/rakefile_rdoc.html) to script my process. The full deploy to github phase goes as follows:
1. Clean all previously generated content \(`rm -rf ./_site2/`\)
2. Reset the git submodule \(`./_site2`\) to a clean state
3. Run Jekyll to generate the site, but configured to generate content to `./_site2/`
4. Copy all generated content to the submodule \(`./_site`\)
5. Commit and push the submodule to github, publishing your generated site
6. Commit from the root of your project in your current branch \(not `master`\). This just ensures your submodule continues to point to the remote `master`

And here is the rakefile.

<script src="https://gist.github.com/2431288.js"> </script>