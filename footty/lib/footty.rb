require 'sportdb/quick'   ## note - pulls in cocos et al
require 'webget'          ## add webcache support




# our own code
require_relative 'footty/version' # let version always go first

require_relative 'footty/dataset/dataset'
require_relative 'footty/dataset/openfootball'

require_relative 'footty/pp_matches'
require_relative 'footty/pp_week'

require_relative 'footty/main'





## set cache to local .cache dir for now - why? why not?
Webcache.root = './cache'

#  pp Webcache.root
Webget.config.sleep = 1  ## set delay in secs (to 1 sec - default is/maybe 3)






Footty.main   if __FILE__ == $0
