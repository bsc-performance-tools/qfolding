X_LIMIT=43.35 # Do not touch this
FACTOR=1 # Do not touch this

set datafile separator ";";

# set term postscript eps solid color;
# set term pdfcairo solid color lw 2;
# set term png size 800,600;
# set term wxt size 800,600;

set multiplot title "Appl * Task * Thread * - Group_0 - Cluster_6"

##############################
## Routines part 
##############################

samplecls(ret,r,g,t) = (r eq 'Cluster_6' && g == 0  && t eq 'cl') ? ret : NaN;

set size 1,0.20;
set origin 0,0.75;

set bmargin 0; set lmargin 14; set rmargin 17;

set xlabel "ghost" tc rgbcolor "white";
set ylabel "ghost" tc rgbcolor "white";
#set y2label "Code line";
set label 'Code line' at screen 0.975, screen 0.8+(0.175/2) rotate by -90 center;
set label "bottom" at second 1.005, first 0;
set label "top"    at second 1.005, first 1;
set xrange [0:X_LIMIT*1./FACTOR];
set x2range [0:1];
set yrange [0:1];
set y2range [0:*] reverse;
set ytics tc rgbcolor "white" (0.001) format "%0.2f";
set y2tics 100 tc rgbcolor "white" format "0000";
unset xtics;
unset x2tics;

set obj rect from graph 0.001*FACTOR, graph 0 to graph 0.243*FACTOR, graph 1 fs transparent solid 0.50 noborder fc rgbcolor '#696A01' behind # Routine: zdf_tke 24.168%
set obj rect from graph 0.249*FACTOR, graph 0 to graph 0.415*FACTOR, graph 1 fs transparent solid 0.50 noborder fc rgbcolor '#B8E901' behind # Routine: zdf_evd 16.601%
set obj rect from graph 0.416*FACTOR, graph 0 to graph 0.561*FACTOR, graph 1 fs transparent solid 0.50 noborder fc rgbcolor '#FFAC63' behind # Routine: iom__write_field3d 14.577%
set obj rect from graph 0.577*FACTOR, graph 0 to graph 1.000*FACTOR, graph 1 fs transparent solid 0.50 noborder fc rgbcolor '#006E71' behind # Routine: zdf_tmx 42.322%

# Summary for routine event__write_field3d 0.009%
# Summary for routine iom__write_field3d 14.577%
# Summary for routine iom_p3d 0.033%
# Summary for routine nemo 0.022%
# Summary for routine nemo_gcm 0.074%
# Summary for routine stp 2.195%
# Summary for routine zdf_evd 16.601%
# Summary for routine zdf_tke 24.168%
# Summary for routine zdf_tmx 42.322%

set label center "nemo_gcm >\nstp >\nzdf_tke\n[213]" at second 0.122*FACTOR, graph 0.5 rotate by 90 tc rgbcolor 'black' front
set label center "nemo_gcm >\nstp >\nzdf_evd\n[139]" at second 0.332*FACTOR, graph 0.5 rotate by 90 tc rgbcolor 'black' front
set label center "iom_p3d >\nevent__write_field3d >\niom__write_field3d\n[374]" at second 0.489*FACTOR, graph 0.5 rotate by 90 tc rgbcolor 'black' front
set label center "nemo_gcm >\nstp >\nzdf_tmx\n[169]" at second 0.788*FACTOR, graph 0.5 rotate by 90 tc rgbcolor 'black' front

plot "nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.dump.csv" u ($4*FACTOR):(samplecls($5,strcol(2),$3,strcol(1))) with points axes x2y2 ti '' lc rgbcolor '#ff2090' pt 7 ps 0.5;

unset label; unset xlabel; unset x2label; unset ylabel; unset y2label;
unset xtics; unset x2tics; unset ytics; unset y2tics; set y2tics autofreq;
unset xrange; unset x2range; unset yrange; unset y2range;
unset tmargin; unset bmargin; unset lmargin; unset rmargin
unset label;
unset arrow;
unset obj;

set size 1,0.73;
set origin 0,0;
set tmargin 0; set lmargin 14; set rmargin 17;

set key bottom outside center horizontal samplen 1;
set x2range [0:1];
set yrange [0:*];
set y2range [0:*];
#set x2tics nomirror format "%.02f";
set xlabel 'Time (ms)';
set xtics nomirror format "%.02f";
set xtics ( 0.0 , 1./5.*X_LIMIT, 2./5.*X_LIMIT, 3./5.*X_LIMIT, 4./5.*X_LIMIT, 5./5.*X_LIMIT, X_LIMIT/FACTOR);
set xrange [0:X_LIMIT*1./FACTOR];
set ylabel 'Counter ratio per instruction';
set y2label 'MIPS';
set ytics nomirror format "%g";
set y2tics nomirror format "%g";

# Breakpoints
# Unneeded phases separators, nb. breakpoints = 2

slope_PAPI_BR_CN(ret,c,r,g) = (c eq 'PAPI_BR_CN' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_BR_CN(ret,c,r,g) = (c eq 'PAPI_BR_CN_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_BR_MSP(ret,c,r,g) = (c eq 'PAPI_BR_MSP' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_BR_MSP(ret,c,r,g) = (c eq 'PAPI_BR_MSP_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_BR_UCN(ret,c,r,g) = (c eq 'PAPI_BR_UCN' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_BR_UCN(ret,c,r,g) = (c eq 'PAPI_BR_UCN_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_FP_INS(ret,c,r,g) = (c eq 'PAPI_FP_INS' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_FP_INS(ret,c,r,g) = (c eq 'PAPI_FP_INS_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_L1_DCM(ret,c,r,g) = (c eq 'PAPI_L1_DCM' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_L1_DCM(ret,c,r,g) = (c eq 'PAPI_L1_DCM_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_L2_DCM(ret,c,r,g) = (c eq 'PAPI_L2_DCM' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_L2_DCM(ret,c,r,g) = (c eq 'PAPI_L2_DCM_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_L3_TCM(ret,c,r,g) = (c eq 'PAPI_L3_TCM' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_L3_TCM(ret,c,r,g) = (c eq 'PAPI_L3_TCM_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_LD_INS(ret,c,r,g) = (c eq 'PAPI_LD_INS' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_LD_INS(ret,c,r,g) = (c eq 'PAPI_LD_INS_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_SR_INS(ret,c,r,g) = (c eq 'PAPI_SR_INS' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_SR_INS(ret,c,r,g) = (c eq 'PAPI_SR_INS_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_TOT_CYC(ret,c,r,g) = (c eq 'PAPI_TOT_CYC' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_TOT_CYC(ret,c,r,g) = (c eq 'PAPI_TOT_CYC_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_TOT_INS(ret,c,r,g) = (c eq 'PAPI_TOT_INS' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_VEC_DP(ret,c,r,g) = (c eq 'PAPI_VEC_DP' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_VEC_DP(ret,c,r,g) = (c eq 'PAPI_VEC_DP_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_PAPI_VEC_SP(ret,c,r,g) = (c eq 'PAPI_VEC_SP' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_PAPI_VEC_SP(ret,c,r,g) = (c eq 'PAPI_VEC_SP_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_RESOURCE_STALLS(ret,c,r,g) = (c eq 'RESOURCE_STALLS' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_RESOURCE_STALLS(ret,c,r,g) = (c eq 'RESOURCE_STALLS_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_RESOURCE_STALLS_LB(ret,c,r,g) = (c eq 'RESOURCE_STALLS:LB' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_RESOURCE_STALLS_LB(ret,c,r,g) = (c eq 'RESOURCE_STALLS:LB_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_RESOURCE_STALLS_ROB(ret,c,r,g) = (c eq 'RESOURCE_STALLS:ROB' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_RESOURCE_STALLS_ROB(ret,c,r,g) = (c eq 'RESOURCE_STALLS:ROB_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_RESOURCE_STALLS_RS(ret,c,r,g) = (c eq 'RESOURCE_STALLS:RS' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_RESOURCE_STALLS_RS(ret,c,r,g) = (c eq 'RESOURCE_STALLS:RS_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
slope_RESOURCE_STALLS_SB(ret,c,r,g) = (c eq 'RESOURCE_STALLS:SB' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;
ratio_RESOURCE_STALLS_SB(ret,c,r,g) = (c eq 'RESOURCE_STALLS:SB_per_ins' && r eq 'Cluster_6' && g == 0 ) ? ret : NaN;

plot \
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_BR_CN($5, strcol(3), strcol(1), $2)) ti 'BR_CN/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_BR_MSP($5, strcol(3), strcol(1), $2)) ti 'BR_MSP/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_BR_UCN($5, strcol(3), strcol(1), $2)) ti 'BR_UCN/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_FP_INS($5, strcol(3), strcol(1), $2)) ti 'FP_INS/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_L1_DCM($5, strcol(3), strcol(1), $2)) ti 'L1_DCM/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_L2_DCM($5, strcol(3), strcol(1), $2)) ti 'L2_DCM/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_L3_TCM($5, strcol(3), strcol(1), $2)) ti 'L3_TCM/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_LD_INS($5, strcol(3), strcol(1), $2)) ti 'LD_INS/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_SR_INS($5, strcol(3), strcol(1), $2)) ti 'SR_INS/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_TOT_CYC($5, strcol(3), strcol(1), $2)) ti 'TOT_CYC/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(slope_PAPI_TOT_INS($5, strcol(3), strcol(1), $2)) ti 'MIPS' axes x2y2 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_VEC_DP($5, strcol(3), strcol(1), $2)) ti 'VEC_DP/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_PAPI_VEC_SP($5, strcol(3), strcol(1), $2)) ti 'VEC_SP/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_RESOURCE_STALLS($5, strcol(3), strcol(1), $2)) ti 'STALLS/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_RESOURCE_STALLS_LB($5, strcol(3), strcol(1), $2)) ti 'STALLS:LB/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_RESOURCE_STALLS_ROB($5, strcol(3), strcol(1), $2)) ti 'STALLS:ROB/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_RESOURCE_STALLS_RS($5, strcol(3), strcol(1), $2)) ti 'STALLS:RS/ins' axes x2y1 w lines lw 3,\
'nemo.exe.128tasks.chop1.clustered.codeblocks.fused.any.any.any.slope.csv' u ($4*FACTOR):(ratio_RESOURCE_STALLS_SB($5, strcol(3), strcol(1), $2)) ti 'STALLS:SB/ins' axes x2y1 w lines lw 3;

unset label;
unset arrow;

unset multiplot;
