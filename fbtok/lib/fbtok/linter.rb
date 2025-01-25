
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
end


def errors?() @errors.size > 0; end



#########
## parse - false (default) - tokenize (only)
##       - true            - tokenize & parse
def read( path, parse: true )
  ## note: every (new) read call - resets errors list to empty
  @errors = []
  @tree   = []

  outline = QuickMatchOutline.read( path )

  outline.each_para do |lines|
  
       ## flatten lines (array of strings) into all-in-one string
       txt  = lines.reduce( String.new ) do |mem, line|
         mem << line
         mem << "\n"
         mem
       end

     if parse
       if debug?
         puts "lines:"
         pp txt   
       end
 
       ##   pass along debug flag to parser (& tokenizer)?
       parser = RaccMatchParser.new( txt )   ## use own parser instance (not shared) - why? why not?
       tree, errors = parser.parse_with_errors

         if errors.size > 0
            ## add to "global" error list
            ##   make a triplet tuple (file / msg / line text)
            errors.each do |msg|
                @errors << [path, msg]
            end
         end

       if debug?
         puts "parse tree:"
         pp tree  
       end

       @tree += tree   ## add nodes

     else   ## process for tokenize only

        if debug?
          puts "lines:"
          pp txt   
        end

##
##   add (bakc) a line-by-line tracing (debug) option - why? why not?
##      now debug output is by section (not line-by-line)

        lexer = Lexer.new( txt )
        t, errors  =  lexer.tokenize_with_errors
                            
         if errors.size > 0
            ## add to "global" error list
            ##   make a triplet tuple (file / msg / line text)
            errors.each do |msg|
                @errors << [path, msg]
            end
         end

         if debug?
           puts "tokens:"
           pp t   
         end

         @tree += t   ## add tokens to "tree"
      end   # parse? (or tokenize?) 
   end  # each para (node)


   ##
   ## auto-add error if no tokens/tree nodes
   if @tree.empty?   ## @tree.size == 0
      @errors << [path, "empty; no #{parse ? 'parse tree nodes' : 'tokens'}"]
   end

   @tree   ## return parse tree 
end  # method read
end  # class Linter


end   # class Parser
end   # module SportDb
