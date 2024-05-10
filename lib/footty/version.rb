
module Footty
   VERSION = '2024.5.10'

   def self.banner
     "footty/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] in (#{root})"
   end

   def self.root
     File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
   end
end


