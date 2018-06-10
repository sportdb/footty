# encoding: utf-8


module Footty
   VERSION = '0.3.0'

   def self.banner
     "footty/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
   end

   def self.root
     "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
   end
end
