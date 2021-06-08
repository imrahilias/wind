reset
unset key
set term png
set output "wind.png"
plot 'wind.dat' using 1:2:3:4 with vectors head filled