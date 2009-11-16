require 'fluxplot'
module RunsHelper

  def approve_string(run)
    approve_string = 'approve'
    approve_string = 'un-approve' if run.approved
    return approve_string
  end
  
  def release_string(run)
    release_string = 'release'
    release_string = 'recall' if run.released
    return release_string
  end

  def plot(flux)
    return if flux.samples.empty?
      m = flux.m
      
      maxy = flux.maxy * m
      maxx = flux.maxx
      
      #maxy += (maxy * 0.2)
      #maxx += (maxx * 0.2)
      #maxy = 100 if maxy < 100
      #maxx = 0.5 if maxx < 0.5

      miny = flux.miny
      minx = flux.minx

      #miny -= (miny * 0.2)
      #minx -= (minx * 0.2)

      intercept, slope = flux.fit(m)
      y2 =intercept + maxx * slope

      dot_size = ((maxy)*0.05)
      dot_size = 2 if dot_size < 2

      output = Fluxplot.new(200,200,maxx, maxy)
      flux.samples.each do |sample|
        next if sample.ppm.nil?
        output.add_point(sample.seconds, sample.ppm*m, flux.id, sample.excluded)
      end
      output.add_line(0, intercept, maxx, y2)
      
      output.add_line(0,maxy,-10,maxy)
      output.to_s
  end

  def curve_plot(curve)
    return if curve.standards.empty?
      maxy = curve.maxy
      maxx = curve.maxx
  
      maxy += (maxy * 0.2)
      maxx += (maxx * 0.2)
      
      miny = curve.miny
      minx = curve.minx

      miny -= (miny * 0.2).to_i
      minx -= (minx * 0.2).to_i

      intercept, slope = curve.fit
      y2 =intercept + maxx * slope

      dot_size = ((maxy)*0.05).to_i
      dot_size = 2 if dot_size < 2
      output = %Q{<svg:svg  preserveAspectRatio="xMinYMin meet" 
                width="200px" height="100px" viewBox="0 0 1 1">
                <svg:g transform="translate(0,1) scale(1, -1)">
                <svg:line x1="0" y1="0" x2="1" y2="0" 
                style="stroke :black; stroke-width :#{dot_size/2}"/>
                <svg:line x1="0" y1="0" x2="0" y2="1"
                style="stroke :black; stroke-width :#{dot_size/2}"/>
      }

      curve.standards.each do | sample |
        output += %Q{
              <svg:circle cx="#{sample.ppm}" cy="#{(sample.response)}" 
              r="#{dot_size}" stroke="black" fill="red" onclick="alert('hi there')"/>
        }
     end
     output += %Q{
           <svg:line x1="0" y1="#{intercept}" x2="#{maxx}" y2="#{y2}"
           style="stroke :black; stroke-width :#{dot_size/2}" />
     }
      output += %Q{
                </svg:g>
                </svg:svg>}
      output
    end
end

