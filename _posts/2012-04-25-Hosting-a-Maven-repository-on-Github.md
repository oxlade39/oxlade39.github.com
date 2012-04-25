---
layout: post
title: Hosting a Maven repository on Github
---
### Host your own
There seem to be a few options open to you if you want to share your maven/ivy managed dependency. I'd quite like the simplicity of having my own repository. Since most of my development is done on [github](github.com) I'd like to host my maven repository there.

### Hosting on github pages
Github allows you to host static websites on it's servers. [Github pages](http://pages.github.com/).

Since a maven repository is really just a formalised directory structure, you can check this into github.

- Set up your [Github pages](http://pages.github.com/), you can do this as a branch (`gh-pages`) of an existing repository or as your main github user page (`username.github.com`). Clone this repository locally. I cloned to `~/proj/project-name-gh-pages`.
- Create a subdirectory `maven` to separate the repository from the rest of your site.
- Use your favourite build tool to `deploy` to `~/proj/project-name-gh-pages/maven`

Now you'll have a perfectly valid maven repository at ~/proj/project-name-gh-pages/maven. If you were to check this in and push to github, those files would be available on github. Unfortunately this won't work with maven yet...

### Creating your indices
At this point I should credit [mpeltonen](https://github.com/mpeltonen) and his [sbt-idea](https://github.com/mpeltonen/sbt-idea) SBT plugin. I knew he'd deployed this to his own repository on github so I looked at his code to find out how...

I got to the point above and then realised [Mikko](https://github.com/mpeltonen) was using a [script](https://github.com/mpeltonen/mpeltonen.github.com/blob/master/GenerateIndeces.scala) to recurse his repository directories and generate an `index.html` for each directory.

So that's the trick, you need an `index.html` in each directory, listing the files and subdirectories in that directory. I guess github isn't set up to list those by default.

### Doing it yourself
You could use [Mikko's script](https://github.com/mpeltonen/mpeltonen.github.com/blob/master/GenerateIndeces.scala). I was writing an SBT plugin so I thought I might as well write the behaviour into my [plugin](https://github.com/oxlade39/ostrich-dist-plugin), so it could deploy itself

So I added it to my [SBT plugin](https://github.com/oxlade39/ostrich-dist-plugin/blob/master/src/main/scala/org/doxla/sbt/ostrich/dist/GithubPagesMavenPublish.scala), allowing me to deploy my maven artefacts to a local directory and then create the `index.html` files in each directory. You can also reuse this, like so:

`build.sbt`
{% highlight scala %}
seq(githubPagesMavenPublishSettings: _*)

githubPagesCheckoutDir := Path.userHome / "proj" / "project-name-gh-pages" / "maven"

publishMavenStyle := true
{% endhighlight %}
with the following in your `project/plugins.sbt`:
{% highlight scala %}
resolvers += "oxlade39 github ostrich" at "http://oxlade39.github.com/ostrich-dist-plugin/maven/"

addSbtPlugin("org.doxla" % "ostrich-dist" % "0.3")
{% endhighlight %}

Once you've added the above to your build, running an `sbt publish` will publish your project artefacts to `~/proj/project-name-gh-pages/maven` with an `index.html` in each directory. You can now commit and push to github:
{% highlight bash %}
cd ~/proj/project-name-gh-pages/maven
git co -m "publishing latest version of project-name"
git push origin gh-pages
{% endhighlight %}
At this point your maven repository will be live.