module Jekyll
  
  class AnalyticsTag < Liquid::Tag
      def initialize(tag_name, url, tokens)
        super        
      end

      def render(context)
        
        site = context.registers[:site]
        dev_mode = site.config['dev_mode']
        
        if dev_mode == "0"
          html
        end
      end
      
      def html
        <<-eos
        <script type="text/javascript">

      	  var _gaq = _gaq || [];
      	  _gaq.push(['_setAccount', 'UA-30906812-1']);
      	  _gaq.push(['_trackPageview']);

      	  (function() {
      	    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      	    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      	    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      	  })();

      	</script>
        eos
      end      
  end
end

Liquid::Template.register_tag('analytics', Jekyll::AnalyticsTag)