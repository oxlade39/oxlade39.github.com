  desc 'Delete generated _site files'
  task :clean do
    system "rm -fR _site2"
    system "cd _site"
    system "git clean -d -f"
    system "cd .."
  end
  
  desc 'Run the jekyll dev server'
  task :server do
    system "jekyll --server --auto"
  end
  
  desc 'Clean temporary files and run the server'
  task :compile => :clean do
    system "jekyll"
  end

  desc 'generate the jekyll site and then copy to staging area'
  task :generate => :compile do
    system "cp -R _site2/* _site/"
    system "rm -R _site2"
  end