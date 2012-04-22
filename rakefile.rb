  require 'erb'
  
  desc 'Delete generated _site files'
  task :clean do
    system "if _config.yml then rm _config.yml"
    system "rm -fR _site2"
    system "git submodule update"
    system "cd _site && git checkout master . && git clean -d -f"
  end
  
  desc 'Create the _config.yml file from the erb template'
  task :create_conf, [:mode] => :clean do |t, args|
    args.with_defaults(:mode => "1")
    
    output_file='_config.yml'
    input_file='_config.yml.erb'
    
    template = ERB.new(File.read(input_file))
    
    File.open(output_file, "w+") do |f|
      f.write(template.result(binding))
    end
  end
  
  desc 'Run the jekyll dev server'
  task :server => :create_conf do
    system "jekyll --server"
  end
  
  desc 'Clean temporary files and run the server'
  task :compile do
    task(:create_conf).invoke("0")
    system "jekyll"
  end

  desc 'generate the jekyll site and then copy to staging area'
  task :generate => :compile do
    system "cp -R _site2/* _site/"
    system "rm -R _site2"
  end
  
  desc 'commit and push to github'
  task :deploy, [:commit_message] => :generate do |t, args|
    if args.commit_message
      puts "Committing and pushing with commit message: #{args.commit_message}"
      system "cd _site && git add . && git commit -m \"#{args.commit_message}\" && git push"
      system "git add _site"
      system "git co -m \"updating submodule reference to master\""
    else
      puts "Missing commit_message"
    end
  end