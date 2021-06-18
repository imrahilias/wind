require 'cairo'

-- set max number of streamlines.
threads = 5000

scale = 1920/360
x0 = 0
y0 = math.floor( ( 1080 - 181*scale )/2 )

wo = io.popen( "cat ~/wind/streamlines_10k.dat" ) -- 10k eats up half of one core!
w = wo:read( "*all" )
wo:close()

bunch = {}
line = { x = {}, y = {} }
local pat = "(%S+)%s+(%S+)"
for xt, yt in string.gmatch( w, pat ) do
   if ( xt == "0" and yt == "0" ) then --indicating new streamline block.
      table.insert( bunch, line ) -- save whole streamline.
      line = { x = {}, y = {} }
   else
      table.insert( line.x, xt ) -- save x y coordinates.
      table.insert( line.y, yt )
   end
end

heads = {}
for s = 1, #bunch do
   table.insert( heads, math.floor( math.random( 60 ) ) )
end


function weave( thread, head, lwd, red, green, blue, alpha )
   
   cairo_set_line_width(cr, lwd)
   cairo_set_source_rgba (cr, red, green, blue, alpha);

   head = math.floor( #thread.x * math.fmod( head + cursec, 60 )/60 )
   
   for s = 1,head do

      local xs = math.floor( x0 + thread.x[s] * scale )
      local ys = math.floor( y0 + thread.y[s] * scale )

      if ( s == 1 ) then
         cairo_move_to( cr, xs, ys )
      else
         cairo_line_to( cr, xs, ys )
      end
      
   end
   
   cairo_stroke_preserve( cr )
   cairo_stroke( cr )
   
end


function conky_wind()
   
   if conky_window == nil then return end
   
   local cs = cairo_xlib_surface_create(conky_window.display,
                                        conky_window.drawable,
                                        conky_window.visual,
                                        conky_window.width,
                                        conky_window.height)
   cr = cairo_create( cs )

   cursec = tonumber( os.date("%S") ) --cursec = updates % slots.
   quiver = math.min( #bunch, threads )
   
   for b = 1,quiver do
      --          val,    start, lwd, red, green, blue, alpha 
      weave( bunch[b], heads[b],   1, 255,   255,  255,  0.2 )
   end

   cairo_destroy( cr )
   cairo_surface_destroy( cs )
   
end
