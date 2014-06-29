## require 'props'

require 'logutils'


# our own code

require 'ojogo/version' # let it always go first


module Ojogo

  def self.banner
    "ojogo/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

end # module Ojogo



puts Ojogo.banner # say hello
