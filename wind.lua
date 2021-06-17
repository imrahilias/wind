-- import data
wo = io.open("streamlines.dat", "r")
w = wo:read( "*all" )
wo:close()

-- split data blob into tables
bunch = {}
line = { x = {}, y = {} }
local pat = "(%S+)%s+(%S+)"
for xt, yt in string.gmatch( w, pat ) do
   if ( xt == "0" and yt == "0" ) then --indicating new streamline block
      table.insert( bunch, line ) -- save whole stream
      line = { x = {}, y = {} }
   else
      table.insert( line.x, xt ) -- save x y coordinate
      table.insert( line.y, yt )
   end
end

-- test
for cb = 1,#bunch do
   for cs = 1,#bunch[cb].x do
      print( bunch[cb].x[cs], bunch[cb].y[cs] )
   end
   print( "new" )
end
