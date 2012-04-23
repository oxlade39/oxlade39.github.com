---
layout: post
title: Writing an sbt 0.11.x plugin
---

### SBT
[SBT](https://github.com/harrah/xsbt/wiki) is a build tool for Scala and Java, think maven and ivy without all that nasty XML and plenty of Scala goodness.

### Plugins
Like Maven, SBT can be customised by adding [plugins](https://github.com/harrah/xsbt/wiki/Plugins). I'd highly recommend reading the documentation [here](https://github.com/harrah/xsbt/wiki/Plugins) before continuing on.

Plugins are written in Scala and take exactly the same form as any other SBT project. The only real difference in your project build file is the line `sbtPlugin := true` which tells SBT that this will be a plugin.

### Key components...
...Pun intended.
They are `SettingKey`, `TaskKey` and `InputKey`. I haven't used `InputKey` so I won't be talking about there here. 

A `SettingKey` is really just a placeholder for a named configuration parameter for your plugin. It looks like this:
{% highlight scala %}	
	val githubPagesCheckoutDir: SettingKey[File] = SettingKey[File]("gh-pages-dir",
	    "The location of checkout out gh-pages to use for deploying to")
{% endhighlight %}
As you can see it takes a type parameter, has a name and (optional) description. This just defines the placeholder and allows it to be overridden by clients of your plugin. It should be given a value and referenced later in your plugin. Usually by a `TaskKey`.

`TaskKey` is a placeholder for a build task, it also has a name and an optional description:

	val createOstrichDist: TaskKey[File] = TaskKey[File]("create-ostrich-dist",
    	"Create an Ostrich compatable distribution zip")

This is where your plugin will do the meat of it's work. For example, my plugin as defined above; creates a zip file in a specific layout that allows me to bootstrap a typical [Ostrich](https://github.com/twitter/ostrich) configuration application.

### You plugin definition
Plugin definitions are built with the rest of your project code, they live in the same place; usually `src/main/scala/` and are `object`s that extend `sbt.Plugin`. Any `TaskKey`s or `SettingKey`s you place in this object will be available to users of your plugin.

### My struggles

### Using your plugin to build your plugin

### Key take homes