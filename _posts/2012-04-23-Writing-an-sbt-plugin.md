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
They are: `SettingKey`, `TaskKey` and `InputKey`. I haven't used `InputKey` so I won't be talking about them here. 

A `SettingKey` is really just a placeholder for a named configuration parameter for your plugin. It looks like this:
{% highlight scala %}
val githubPagesCheckoutDir: SettingKey[File] = SettingKey[File]("gh-pages-dir",
		"The location of checkout out gh-pages to use for deploying to")
{% endhighlight %}
As you can see it takes a type parameter, has a name and (optional) description. This just defines the placeholder and allows it to be overridden by clients of your plugin. It should be given a value and referenced later in your plugin. Usually by a `TaskKey`.

`TaskKey` is a placeholder for a build task, it also has a name and an optional description:
{% highlight scala %}
val createOstrichDist: TaskKey[File] = TaskKey[File]("create-ostrich-dist",
   	"Create an Ostrich compatable distribution zip")
{% endhighlight %}
This is where your plugin will do the meat of it's work. For example, my plugin - as defined above - creates a zip file in a specific layout that allows me to bootstrap a typical [Ostrich](https://github.com/twitter/ostrich) configured application.

### Your plugin definition
Plugin definitions are built with the rest of your project code, they live in the same place; usually `src/main/scala/` and are `object`s that extend `sbt.Plugin`. Any `TaskKey`s or `SettingKey`s you place in this object will be available to users of your plugin.

### My struggles
I have to say, I found getting started with writing an SBT plugin to be extremely frustrating. Looking back I'm not entirely sure why. I think it was mainly because of a lack of documentation. 

It's easy enough to create a plugin task that prints 'Hello world' but to interact and manipulate the existing build lifecycle was hard.

Understanding the built-in `TaskKey`s and `SettingKey`s and where and how my plugin task should fit in was my main issue. I went through several frustrating hours looping through defining my plugin, firing up `./sbt` and running `inspect package` or `inspect my-task`. Running `inspect $taskname` from the SBT console prints out information on that task/setting, it's dependencies, dependents and more.

The key turning point for me was fully appreciating the following:
- Operations on `SettingKey`s and `TaskKey`s return definitions of the `Project.Setting[_]` or `Project.Setting[Task[_]]` respectively. See [here](https://github.com/harrah/xsbt/wiki/Getting-Started-More-About-Settings)
- `Project.Setting` values are [scoped](https://github.com/harrah/xsbt/wiki/Getting-Started-Scopes), to a project, configuration (`Compile`, `Test`, or `Runtime`) or to a task. This means `sources in Compile` is different to `sources in Test`
- And, related to above, a project's settings are defined by a `Seq` of these `Project.Setting[_]` or `Project.Setting[Task[_]]`s. For me, this point boils down to the fact that your plugin just needs to be a sequence of operations on `TaskKey`s or `SettingKey`s. For example:
{% highlight scala %}
val ostrichDistSettings = Seq(
    target in createOstrichDist ~= {value: File => value / "ostrich-dist"},

    sources in createOstrichDist <<= (baseDirectory in Compile) map {
      (bd: File) =>
        val configSrc = bd / "config"
        val webappSrc: Seq[File] = (bd / "src/main/webapp") match {
          case f: File if f.exists() => Seq(f)
          case _ => Seq[File]()
        }
        Seq[File](configSrc) ++ webappSrc
    }
)
{% endhighlight %}
This would define two project settings (one standard setting and one task) scoped to the new `createOrstrichDist` task. This just means you don't screw up settings in the standard build or other plugins. 

It helped me to think of my plugin in terms of a typical build cycle. What are it's inputs (`sources`), it's generated sources (`unmanagedResources`) and it's output (`artifact`).

### Using your plugin to build your plugin
If, like me, your head explodes on dealing with anything recursive then this is quite confusing but it is possible with SBT.

Say you're writing a plugin to automate document generation from your tests, you're probably going to want to generate documentation for the plugin itself. If you want to understand why this works you should read [this](https://github.com/harrah/xsbt/wiki/Getting-Started-Full-Def) otherwise just add this to `./project/plugins.sbt` __not__ `./build.sbt`:
{% highlight scala %}
unmanagedSourceDirectories in Compile <+= baseDirectory.apply(_ / ".." / "src" / "main" / "scala")
{% endhighlight %}
Then reference your plugin from your `build.sbt` like you would if you were depending on a plugin normally.

### Summary
Writing an SBT plugin isn't simple but have you ever tried to write a Maven plugin? and remember writing jelly script for Maven 1? If you work out the basics of [scoping](https://github.com/harrah/xsbt/wiki/Getting-Started-Scopes), [settings](https://github.com/harrah/xsbt/wiki/Getting-Started-More-About-Settings) and existing build settings you'll be fine.

I decided to write this post after writing [a plugin to create binary distributions](https://github.com/oxlade39/ostrich-dist-plugin) for another project I'm working on. Have a look through the [source](https://github.com/oxlade39/ostrich-dist-plugin)