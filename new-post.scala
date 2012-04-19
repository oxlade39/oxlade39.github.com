#!/usr/bin/env scala
!#

JekyllBlogPost.createFile

object JekyllBlogPost {
	import java.io.File
	import java.io.FileWriter
	import java.util.Date


	val fileTemplate =  """---
layout: post
title: %s
---"""

	lazy val postDir = new File("_posts")
	lazy val todaysDate = new Date()
	lazy val blogDateFormat: String = new java.text.SimpleDateFormat("yyyy-MM-dd").format(todaysDate)

	def createFile() {
		val actualBlogPostFile = new File(postDir, blogDateFormat + "-" + postName.replaceAll(" ", "-") + ".md")
		
		write(actualBlogPostFile, fileTemplate.format(postTitle))
	}

	lazy val postName: String = {
		Console.println("enter blog post name:")
		Console.readLine()
	}
	
	lazy val postTitle: String = {
		Console.println("is the title the same? (y/n)")
		Console.readLine() match {
			case "Y" => postName
			case "y" => postName
			case _ => {
				Console.println("enter blog title:")
				Console.readLine()
			}
		}
	}
	
	def write(file: File, text : String) : Unit = {
		val fw = new FileWriter(file)
		try{ fw.write(text) }
		finally{ fw.close }
	}
}