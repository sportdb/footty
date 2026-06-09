module SportDb

##
#  PathspecReport (aka/formerly BatchReport)

class PathspecReport
  def initialize( specs, title: )
     @specs = specs
     @title = title
  end

  def build
     buf = String.new
     buf << "# #{@title} - #{@specs.size} dataset(s)\n\n"

     @specs.each_with_index do |rec,i|
       datafiles  = rec['datafiles']
       errors     = rec['errors']

       if errors.size > 0
         buf << "!! #{errors.size} ERROR(S)  "
       else
         buf << "   OK          "
       end
       buf << "%-20s" % rec['path']
       buf << " - #{datafiles.size} datafile(s)"
       buf << "\n"

       if errors.size > 0
         buf << errors.pretty_inspect
         buf << "\n"
       end
     end

     buf
  end   # method build
end  # class BatchReport

BatchReport = PathspecReport


end  # module Sportdb
