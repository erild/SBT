Metrical Information Analysis - Matlab Code
===========================================

Computes the metrical information analysis on a population of spike trains using the Victor-Purpura distance


Installation:
=============
Copy files in working directory or a directory included in matlab's path.
Compile the 'spkdl.c' file using the matlab command :

>> mex spkdl.c

Running Analysis:
=================
The analysis is launched using the 'MainAnalysisFunc' function in matlab.
for further information on this function and its parameters please use the included help :

>> help MainAnalysisFunc

Input File format:
==================
Each line of the file has this format:
stimulus	trial		time		neuron/afferent		(...) 

following columns are not taken into account

Test:
=====
The function can be tested using the 'ST_testing.dat' data included.
This file contains the response from 24 neurons to 26 different stimuli (2 trials per stimulus).
For example, this command will run the analysis using a 10 ms time increment, a VP cost of 0.05 ms^-1, an automatically detected Dcritic and will display the results:

>> MainAnalysisFunc('ST_testing.dat','out_testing',10,0.05,-2,0,1);
