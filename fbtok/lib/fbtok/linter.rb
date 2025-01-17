
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

  nodes = OutlineReader.read( path )

  ##  process nodes
  h1 = nil
  h2 = nil
  orphans = 0    ## track paragraphs's with no heading

 
  nodes.each do |node|
    type = node[0]

    if type == :h1
        h1 = node[1]  ## get heading text
        puts "  = Heading 1 >#{node[1]}<"
    elsif type == :h2
        if h1.nil?
          puts "!! WARN - no heading for subheading; skipping parse"
          next
        end
        h2 = node[1]  ## get heading text
        puts "  == Heading 2 >#{node[1]}<"
    elsif type == :p

       if h1.nil?
         orphans += 1    ## only warn once
         puts "!! WARN - no heading for #{orphans} text paragraph(s); skipping parse"
         next
       end

       lines = node[1]


       tree = []

     if parse
       ## flatten lines
       txt  = []
       lines.each_with_index do |line,i|
          txt << line
          txt << "\n"
       end
       txt = txt.join
    
       if debug?
         puts "lines:"
         pp txt   
       end
 
       ## todo/fix -  add/track parse errors!!!!!!
       parser = RaccMatchParser.new( txt )   ## use own parser instance (not shared) - why? why not?
       tree = parser.parse
       pp tree  

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

          ## post-process tokens
          ##  - check for round, group, etc.
          t = t.map do |tok|
            #############
            ## pass 1
            ##   replace all texts with keyword matches (e.g. group, round, leg, etc.)
                if tok[0] == :TEXT
                   text = tok[1]
                    if @parser.is_group?( text )
                           [:GROUP, text]
                    elsif @parser.is_round?( text ) || @parser.is_leg?( text )
                           [:ROUND, text]
                    else
                        tok  ## pass through as-is (1:1)
                    end
                else
                   tok
                end
          end
 
         pp t   if debug?

         tree << t
       end
      end
    else
        pp node
        raise ArgumentError, "unsupported (node) type >#{type}<"
    end
  end  # each node
end  # read
end  # class Linter


end   # class Parser
end   # module SportDb
