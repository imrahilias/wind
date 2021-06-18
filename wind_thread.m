close all
clear all
clc

wind = csvread( "wind.dat" );

nx = 360
ny = 181

clear u v
c = 0
for cx = 1:ny
    for cy = 1:nx
        c = c+1;
        u( cx, cy ) = wind( c, 3 );
        v( cx, cy ) = wind( c, 4 );
    endfor
endfor
#imagesc( u )

[x y] = meshgrid( 1:nx, 1:ny );
[sx sy] = meshgrid( 1:10:nx, 1:10:ny );

##fh = figure
##earth = imread( "earth.png" );
##imagesc( earth );
##hold on
##[x y] = meshgrid( 1:nx, 1:ny );
##[sx sy] = meshgrid( 1:10:nx, 1:10:ny );
##sh = streamline( x, y, u, v, sx, sy );
##set( sh, "color", "w");
##quiver (x, y, u, v);
##set(gca,"position",[0 0 1 1],"units","normalized")
##print( fh, "wind.png", "-S3600,1810" );

sn = 10000
sx = floor( nx * rand( sn, 1 ) ) + 1;
sy = floor( ny * rand( sn, 1 ) ) + 1;
stepsize = 1
max_vertices = 100
for cs = 1:sn
    xy = stream2( x, y, u, v, sx(cs), sy(cs), [stepsize, max_vertices] );
    #dlmwrite( "streamlines.dat", uint16(xy{1}), " ", "-append" )
    dlmwrite( "streamlines_10k.dat", xy{1}, " ", "-append" )
    dlmwrite( "streamlines_10k.dat", [0 0], " ", "-append" )
endfor
