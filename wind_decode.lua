--[[
   lua script to downloads recent wind json from noaa (not yet),
   import and decode it and write to csv, to be analysed by octave script wind_thread.m.
   moritz siegel @ 210623
]]--

json = require "json"
spline = require "spline"

-- test
a = json.encode({ 1, 2, 3, { x = 10 } })
b = json.decode('[1,2,3,{"x":10}]')
c = b[4]
d = c.x

--wj = io.open( "test.json" )
--wj = io.open( "test.txt" )
-- open file & read & decode
wj = io.open( "wind.json" )
wjr = wj:read( "*all" )
wj:close()
w = json.decode( wjr )

-- extract number of points u,v
nn = w[1].header.numberPoints
nx = w[1].header.nx
ny = w[1].header.ny

-- extract momentum vectors u,v
u = w[1].data
v = w[2].data

-- open outfile
local charS,charE = ", ","\n"
wo = io.open( "wind.csv", "w" )

c = 0
us = {}
vs = {}
for y = 1,ny do
   us[y] = {}
   vs[y] = {}
   for x = 1,nx do
      c = c+1
      us[y][x] = u[c]
      vs[y][x] = v[c]
      wo:write(
         tostring( x )..charS..
         tostring( y )..charS..
         tostring( u[c] )..charS..
         tostring( v[c] )..charE
      )
   end
end

-- -- open outfile
-- wt = io.open( "trace.dat", "w" )

-- --local tables,lookup = { tbl },{ [tbl] = 1 }
-- --table.insert( tables, u )
-- --lookup[u] = #tables
-- ntrace = 100
-- ltrace = 10
-- local charS,charE = "\t","\n"
-- for cn = 1,ntrace do
--    local x = math.random(1,nx)
--    local y = math.random(1,ny)
--    --print( x, y, us[x][y], vs[x][y] )
--    for ct = 2,ltrace do
--       xt = x + us[x][y]
--       yt = y + vs[x][y]
--       if ( xt < 1. or xt > nx or yt < 1. or yt > ny or ( xt == x and yt == y ) ) then
--          break
--       end
--       x = math.floor( xt )
--       y = math.floor( yt )
--       wt:write(
--          tostring( x )..charS..
--          tostring( y )..charE
--       )
--    end
--    wt:write( charE..charE )
-- end
