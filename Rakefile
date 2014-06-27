task :default => :server

desc 'Clean up generated site'
task :clean do
  cleanup
end

desc 'Build site with Jekyll'
task :build => :clean do
  compass
  jekyll('build')
  make_symlink
end

desc 'Start server'
task :server do
  compass
  jekyll('serve')
  # run "rake symlink" in another thread
end

task :symlink do
  make_symlink
end

desc 'Build and deploy'
task :deploy => :build do
  sh 'rm -rf _site/blog'
  sh 'rm -rf _site/build'
  sh './_deploy.sh'
end

desc 'Check links for site already running on localhost:4000'
task :check_links do
  begin
    require 'anemone'
    root = 'http://localhost:4000/'
    Anemone.crawl(root, :discard_page_bodies => true) do |anemone|
      anemone.after_crawl do |pagestore|
        broken_links = Hash.new { |h, k| h[k] = [] }
        pagestore.each_value do |page|
          if page.code != 200
            referrers = pagestore.pages_linking_to(page.url)
            referrers.each do |referrer|
              broken_links[referrer] << page
            end
          end
        end
        broken_links.each do |referrer, pages|
          puts "#{referrer.url} contains the following broken links:"
          pages.each do |page|
            puts "  HTTP #{page.code} #{page.url}"
          end
        end
      end
    end

  rescue LoadError
    abort 'Install anemone gem: gem install anemone'
  end
end

def cleanup
  sh 'rm -rf _site'
end

def jekyll(opts = '')
  sh 'jekyll ' + opts
end

def compass(opts = '')
  sh 'compass compile -c config.rb --force ' + opts
end

@dir = 'blog'
def make_symlink
  sh 'mkdir -p _site && cd _site && sudo ln -s . ' + @dir
end
