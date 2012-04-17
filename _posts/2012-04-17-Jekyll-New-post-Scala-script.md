---
layout: post
title: Jekyll New post Scala script
---
[Jekyll](https://github.com/mojombo/jekyll) requires that you create blog posting in a specific format:
`_posts/yyyy-MM-dd-post-name`, where the date is the creation date of the post. This is actually quite a nice convention as the metadata can be used in your site generation to do things like group posts my year and month.

However, it's a little cumbersome to have to manually create the file each time. A quick google shows up plenty of alternatives but here's a quick Scala script that I use:

<script src="https://gist.github.com/2404158.js?file=new-post.scala"></script>