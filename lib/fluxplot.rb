require 'rexml/document'

class Fluxplot
  def initialize(width, height,maxx, maxy)
    @doc = REXML::Document.new
    @root = @doc.add_element("svg:svg", {
      "width" => width,
      "height" => height,
      "viewBox" => "-10 -10 #{maxx+10} #{maxy+10}",
    })
    # @graph = @root.add_element("svg:g",{
    #       "transform" => "translate(0 #{maxy}) "  # scale(1,-1)
    # })
    @graph = @root

    @maxy = maxy
    @maxx = maxx
    @dot_size = ((maxy)*0.05)
    @dot_size = 2 if @dot_size < 2
    
    @graph.add_element("svg:line", {
        "x1" => 0,
        "y1" => -maxy,
        "x2" => -10,
        "y2" => -maxy 
    })
#    @graph.add_element("path", {
#      "d" => "M 0 0 v#maxy"
#    })
    self.add_line(0,0,maxx,0)
    self.add_line(0,0,0,maxy)
    #self.add_text(-10,maxy, maxy)
  end
  
  def add_line(x1,y1,x2,y2)
    @graph.add_element("svg:line", {
       "x1" => x1,
       "y1" => @maxy-y1,
       "x2" => x2,
       "y2" => @maxy-y2,
       'class' => 'line',
       "style" => "stroke :black; stroke-width :#{@dot_size/2}"
     })
  end
  
  def add_point(x, y, id, excluded)
    if excluded
      tag = "excluded" 
      stroke = "grey"
      fill = "grey"
    else
      tag = "included"
      stroke = "black"
      fill = "red"
    end
    @graph.add_element("svg:circle", {
      "cx" => x,
      "cy" => @maxy-y,
      "r" => @dot_size,
      "class" => tag,
      "stroke" => stroke,
      "fill" => fill,
      "onclick" => "new Ajax.Updater('flux_#{id}','/runs/#{id}/toggle_point?seconds=#{x}', {asynchronous:true, evalScripts:true, parameters: 'product[name]=chair&authenticity_token=' + window._token}); return false;"
    })    
  end
  
  def add_text(x,y,text)
    @graph.add_element("svg:text", {
      "x" => x,
      "y" => y,
    }).text = text
  end
  
  def to_s
    @doc.to_s
  end
      
end