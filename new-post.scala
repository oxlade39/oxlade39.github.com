#!/usr/bin/env scala
!#

import java.io.File
import java.io.FileWriter
import java.util.Date

val postDir = new File("_posts")
val todaysDate = new Date()

val blogDateFormat: String = new java.text.SimpleDateFormat("yyyy-MM-dd").format(todaysDate)

Console.println("enter blog post name:")
val postName = Console.readLine()

Console.println("is the title the same? (y/n)")
val postTitle = Console.readLine() match {
	case "Y" => postName
	case "y" => postName
	case _ => {
		Console.println("enter blog title:")
		Console.readLine()
	}
}

val actualBlogPostFile = new File(postDir, blogDateFormat + "-" + postName.replaceAll(" ", "-") + ".md")

val fileHeader = 
"""---
layout: post
title: %s
---
""".format(postTitle)

write(actualBlogPostFile, fileHeader)


def write(file: File, text : String) : Unit = {
   val fw = new FileWriter(file)
   try{ fw.write(text) }
   finally{ fw.close }
 }