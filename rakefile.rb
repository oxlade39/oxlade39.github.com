  desc 'Delete generated _site files'
  task :clean do
    system "rm -fR _site2"
    system "git submodule update"
    system "cd _site && git checkout . && git clean -d -f"
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
  
  desc 'commit and push to github'
  task :deploy, [:commit_message] => :generate do
    if args.commit_message
      puts "Committing and pushing with commit message: #{args.commit_message}"
      system "cd _site && git add . && git commit -m \"#{args.commit_message}\" && git push"
    else
      puts "Missing commit_message"
    end
  end