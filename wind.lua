json = require "json"

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
wj = io.open( "wind.dat", "w" )

c = 0
--local tables,lookup = { tbl },{ [tbl] = 1 }
--table.insert( tables, u )
--lookup[u] = #tables
local charS,charE = "\t","\n"
for x = 1,nx do
   for y = 1,ny do
      c = c+1
      if c < 500 then
         wj:write(
            tostring( x )..charS..
            tostring( y )..charS..
            tostring( x + u[c] )..charS..
            tostring( y + v[c] )..charE
         )
      end
      --wj:write( x, y, u[c], v[c] )
   end
end
