
module SportDb
class Parser

###
## note - Linter for now nested inside Parser - keep? why? why not?
class Linter

def self.debug=(value) @@debug = value; end
def self.debug?()      @@debug ||= false; end  ## note: default is FALSE
def debug?()  self.class.debug?; end



attr_reader :errors

def initialize
  @errors = []
  @parser = Parser.new   ## use own parser instance (not shared) - why? why not?
end


def errors?() @errors.size > 0; end


#########
## parse - false (default) - tokenize (only)
##       - true            - tokenize & parse
def read( path, parse: true )
  ## note: every (new) read call - resets errors list to empty
  @errors = []

  @tree = []

  outline = QuickMatchOutline.read( path )

  outline.each_para do |lines|

     if parse
       ## flatten lines (array of strings) into all-in-one string
       txt  = lines.reduce( String.new ) do |mem, line|
                                            mem << line
                                            mem << "\n"
                                            mem
                                        end
    
       if debug?
         puts "lines:"
         pp txt   
       end
 
       ## todo/fix -  add/track parse errors!!!!!!
       ##   pass along debug flag to parser (& tokenizer)?
       parser = RaccMatchParser.new( txt )   ## use own parser instance (not shared) - why? why not?
       tree = parser.parse

       if debug?
         puts "parse tree:"
         pp tree  
       end

       @tree += tree   ## add nodes

     else   ## process for tokenize only
       lines.each_with_index do |line,i|

        if debug?
         puts
         puts "line >#{line}<"
        end

        t, error_messages  =  @parser.tokenize_with_errors( line )
                            
         if error_messages.size > 0
            ## add to "global" error list
            ##   make a triplet tuple (file / msg / line text)
            error_messages.each do |msg|
                @errors << [ path,
                             msg,
                             line
                           ]
            end
         end

         pp t   if debug?
       end  # each line
      end   # parse? (or tokenize?) 
   end  # each para (node)

   ## note - only returns pare tree for now; no tokens (on parse=false)
   @tree   ## return parse tree 
end  # method read
end  # class Linter


end   # class Parser
end   # module SportDb
