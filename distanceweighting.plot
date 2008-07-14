set tics out
#set xtics ("G (M-A-G-Y-S)" 0, "G* (M-G*-S*)" 1)
#set ytics 0,1
set noxzeroaxis
set noyzeroaxis
set format y "%.1f"
set xlabel "distance"
set ylabel "vote"
#set label "1.0" at 2.0,0.2
#set label "2.0" at 0.93,0.2
#set label "4.0" at 0.18,0.2
set term postscript eps 22
set output "distanceweight-ided.eps"
plot [0:3][0:1.7] 1/x title "ID", exp(-x) title "ED a=1,b=1", exp(-2.*x) title "ED a=2,b=1", exp(-1.*(x**2.)) title "ED a=1,b=2"
