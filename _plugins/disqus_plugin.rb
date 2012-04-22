module Jekyll
  
  class DisqusTag < Liquid::Tag
      def initialize(tag_name, url, tokens)
        super        
      end

      def render(context)
        
        site = context.registers[:site]
        dev_mode = site.config['dev_mode']

        html(dev_mode, context['page.url'])
      end
      
      def html(dev_mode, url)
        <<-eos
        <div id="disqus_thread"></div>
        <script type="text/javascript">
            /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
          var disqus_developer = #{dev_mode}; // 1 = developer mode is on
          var disqus_identifier = '#{url}';
          var disqus_shortname = 'codingaddickt';
          (function() {
              var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
              dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
              (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
          })();
        </script>
        <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
        <a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>
        eos
      end      
  end
end

Liquid::Template.register_tag('disqus', Jekyll::DisqusTag)