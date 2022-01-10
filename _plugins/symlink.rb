Jekyll::Hooks.register :site, :post_write do |page|
  puts 'mkdir -p _site && cd _site && ln -s . blog'
  system('mkdir -p _site && cd _site && ln -s . blog')
end
