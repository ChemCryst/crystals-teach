\set time slow
\rele print CROUTPUT:
\TITLE P6122 TEST DECK FROM LARSON  -  MUCH MODIFIED FOR CRYSTALS               
\SET MIRROR OFF
\LIST 1                                                                         
REAL 8.53    8.53    20.37         0.0 0.0 -0.5                                 
END                                                                             
\LIST 2                                                                         
CELL NSYM= 12, CENTRIC= NO                                                      
SYM X,Y,Z                                                                       
SYM -X    ,   -Y  ,Z+.5                                                         
SYM +Y, +X,1/3-Z                                                                
SYM -Y,-X,5/6-Z                                                                 
SYM -Y, X-Y, .333333333+Z                                                       
SYM Y, Y-X, Z+10/12                                                             
SYM -X, Y-X, 4/6-Z                                                              
SYM X, X-Y, 1/6-Z                                                               
SYM Y-X, -X, Z+4/6                                                              
SYM  X-Y, X, Z+1/6                                                              
SYM X-Y, -Y, -Z                                                                 
SYM Y-X, Y ,  -Z+.5                                                             
END                                                                             
\LIST 3                                                                         
READ 3                                                                          
SCATT C    0    0  1.93019  12.7188  1.87812  28.6498  1.57415  0.59645         
CONT               0.37108  65.0337  0.24637                                    
SCATT O    0    0  2.95648  13.8964  2.45240  5.91765  1.50510  0.34537         
CONT               0.78135  34.0811  0.30413                                    
SCATT S 0.35 0.86  7.18742  1.43280  5.88671  0.02865  5.15858  22.1101         
CONT               1.64403  55.4651 -3.87732                                    
END                                                                             
\LIST 13                                                                        
DIFF GEOM= EQUI                                                                 
END                                                                             
\LIST 29
END
\LIST 5
READ NATOM= 3, NLAYER=13                                                        
INDEX R=1                                                                       
ATOM TYPE= C 1 X= 0.488 0.096 0.038 0.0316628699 OCC= 1.0               
ATOM TYPE= S 1 X= 0.202 0.798 0.91667 OCC=  0.5                     
CONT U[11]= 0.02533 0.02533 0.02533 0.0 0.0 0.012665                            
ATOM TYPE= O 1 X= 0.498 0.498 0.66667 OCC= 0.5                      
CONT U[11]= 0.02533 0.02533 0.02533 0.0 0.0 0.012665                            
END                                                                             
\LIST 12                                                                        
FULL C(1,X,Y,Z,U[ISO]) S(1,U[33],U[12]) O(1,U[33],U[12])                        
CONT LAYER(1) LAYER(3) UNTIL LAYER(12)                                          
EQUIV S(1,X) S(1,Y)                                                             
EQUIV O(1,X) O(1,Y)                                                             
WEIGHT -1. S(1,Y)                                                               
EQUIV S(1,U[11],U[22])                                                          
EQUIV O(1,U[11],U[22])                                                          
EQUIV S(1,U[23],U[13])                                                          
EQUIV O(1,U[23],U[13])                                                          
WEIGHT -1. O(1,U[13])                                                           
END                                                                             
\LIST 23                                                                        
MODIFY ANOM= YES                                                                
END                                                                             
\SET MIRROR ON
\USE tdlist6.hkl
\SFLS                                                                           
CALC                                                                            
END                                                                             
\TITLE SLANT FOURIER TESTS IN P6122                                             
\SLANT                                                                          
MAP TYPE=FO-PATTERSON
MATRIX  0 0 1000
CONT 0 100 0                                                                    
CONT 10 0 0                                                                     
CENTROID 2000 100 0                                                             
\ NOTE BIZARE LIMITS = JUST TO TEST IT
\ WORKS OUTSIDE THE BASIC UNIT CELL
DOWN -40 6 40                                                                   
ACROSS -3 6 3                                                                   
\SLANT                                                                          
MAP TYPE= F-OBS, MIN-RHO= -10000
MATRIX 0 0 1                                                                    
CONT 0 1 0                                                                      
CONT 1 0 0                                                                      
CENTROID 0 0 0                                                                  
DOWN 0 16 0.02                                                                  
ACROSS 0 14 0.04                                                                
\SLANT                                                                          
MAP TYPE= F-CALC, MIN-RHO= -10000, SCALE= 44.613                                
MATRIX 0 0 1                                                                    
CONT 0 1 0                                                                      
CONT 1 0 0                                                                      
CENTROID 0 0 0                                                                  
DOWN 0 6 0.04                                                                   
ACROSS 0 6 0.04                                                                 
\TRIAL                                                                          
MAP /FO/-MIN= 45                                                                
DISPLACEMENT .1 -.2 .3                                                          
DOWN 13 0 .02 0                                                                 
ACROSS 26 .02 0 0                                                               
THROUGH 3 0 0 -.1                                                               
END
# DEMONSTRATE SLANT FOURIERS THROUGH ANISOTROPIC
# PLANAR GROUP, AND 'SPLITTING' OF ATOM
#DISK
EXTEND SIZ=0
END
#LIST 1
REAL 10 10 11
END
#SPACE
SYM P 4
END
#LIST 3
READ NSCATTER =            1
SCATT  C    0.017 0.009 2.31000 20.8439 1.02000 10.2075 1.58860
CONT 0.568700 0.865000 51.6512 0.215600
END
#
# Punched on 26-JAN93 at 11:35:34
#
#LIST      5                                                                    
READ NATOM =      7, NLAYER =    0, NELEMENT =    0, NBATCH =    0
OVERALL    1.000006  0.050000  0.050000  1.000000  0.000000         0.0000000
ATOM C       0.000000   1.000000   0.000000   0.000000   0.000000   0.001000
CONTINUE     0.020268   0.020268   0.010000   0.000000   0.000000   0.000000
ATOM C       1.000000   1.000000   0.000000   0.190520  -0.110000   0.000000
CONTINUE     0.037958   0.067687   0.020000   0.000000   0.000000   0.025748
ATOM C       2.000000   1.000000   0.000000   0.100000   0.173200   0.000000
CONTINUE     0.062037   0.032308   0.020000   0.000000   0.000000  -0.025748
ATOM C       3.000000   1.000000   0.000000  -0.190520   0.110000   0.000000
CONTINUE     0.037958   0.067687   0.020000   0.000000   0.000000   0.025748
ATOM C       4.000000   1.000000   0.000000  -0.100000  -0.173200   0.000000
CONTINUE     0.062037   0.032308   0.020000   0.000000   0.000000  -0.025748
ATOM C       5.000000   1.000000   0.000000   0.500000   0.000000   0.000000
CONTINUE     0.020000   0.270000   0.020000   0.000000   0.000000   0.000000
ATOM C      25.000000   1.000000   0.000000   0.433000  -0.250000   0.000000
CONTINUE     0.097498   0.212488   0.020000   0.000000   0.000000   0.099590
END                                                                             
#
# Punched on 26-JAN93 at 11:35:36
#
#LIST      6                                                                    
READ NCOEFFICIENT =     5, TYPE = COMPRESSED, UNIT = DATAFILE
INPUT  H  K  L  /FO/  RATIO
MULTIPLIERS  1.0  1.0  1.0        8.363332748      1.000000000
END                                                                             
0 0 2 37 0 3 356 0 4 105 0 5 16 0 512 1 0 1 190 0 2 200 0 3 437 0 4 321 0 512 2 
0 0 37 0 1 149 0 2 86 0 3 214 0 4 47 0 512 3 0 1 91 0 2 276 0 3 166 0 4 74 0 5 2
0 512 4 0 0 105 0 1 182 0 2 404 0 3 242 0 4 81 0 5 49 0 512 5 0 1 59 0 2 161 0 3
160 0 4 9 0 512 6 0 0 46 0 1 4 0 2 6 0 3 22 0 512 
1 1 -5 58 0 -4 178 0 -3 88 0 -2 144 0 -1 183 0 0 404 0 1 183 0 2 193 0 3 425 0 4
314 0 5 17 0 512 2 1 -5 158 0 -4 396 0 -3 269 0 -2 84 0 -1 193 0 0 36 0 1 144 0 
2 84 0 3 209 0 4 46 0 5 82 0 512 3 1 -5 158 0 -4 238 0 -3 162 0 -2 209 0 -1 425 
0 0 345 0 1 88 0 2 269 0 3 162 0 4 73 0 5 2 0 512 4 1 -5 9 0 -4 80 0 -3 73 0 -1 
314 0 0 102 0 1 178 0 2 396 0 3 238 0 4 80 0 5 48 0 512 5 1 -4 48 0 -3 2 0 -2 82
0 -1 17 0 0 16 0 1 58 0 2 158 0 3 158 0 4 9 0 5 153 0 512 6 1 -2 211 0 -1 185 0 
0 46 0 1 4 0 2 6 0 3 21 0 512 
0 2 -5 16 0 -4 96 0 -3 319 0 -2 32 0 -1 364 0 0 999 0 1 364 0 2 32 0 512 1 2 -5 
55 0 -4 168 0 -3 82 0 -2 132 0 -1 166 0 0 364 0 1 166 0 2 176 0 3 393 0 4 295 0 
512 2 2 -5 151 0 -4 374 0 -3 250 0 -2 77 0 -1 176 0 0 32 0 1 132 0 2 77 0 3 194 
0 4 43 0 5 78 0 512 3 2 -5 152 0 -4 226 0 -3 153 0 -2 194 0 -1 393 0 0 319 0 1 
82 0 2 250 0 3 153 0 4 69 0 5 2 0 512 4 2 -5 9 0 -4 77 0 -3 69 0 -2 43 0 -1 295 
0 0 96 0 1 168 0 2 374 0 3 226 0 4 77 0 5 47 0 512 5 2 -4 47 0 -3 2 0 -2 78 0 -1
16 0 0 16 0 1 55 0 2 151 0 3 152 0 4 9 0 512 6 2 -2 204 0 -1 178 0 0 44 0 1 4 0 
2 6 0 3 20 0 512 
1 3 -5 51 0 -4 152 0 -3 72 0 -2 115 0 -1 143 0 0 311 0 1 143 0 2 153 0 3 349 0 4
267 0 512 2 3 -5 141 0 -4 342 0 -3 225 0 -2 68 0 -1 153 0 0 28 0 1 115 0 2 68 0 
3 174 0 4 39 0 5 73 0 512 3 3 -5 142 0 -4 209 0 -3 139 0 -2 174 0 -1 349 0 0 282
0 1 72 0 2 225 0 3 139 0 4 64 0 5 2 0 512 4 3 -5 8 0 -4 72 0 -3 64 0 -2 39 0 -1 
267 0 0 87 0 1 152 0 2 342 0 3 209 0 4 72 0 5 44 0 512 5 3 -4 44 0 -3 2 0 -2 73 
0 -1 15 0 1 51 0 2 141 0 3 142 0 4 8 0 5 142 0 512 6 3 -2 193 0 -1 168 0 0 41 0 
1 4 0 2 6 0 3 19 0 512 
0 4 -5 13 0 -4 76 0 -3 243 0 -2 23 0 -1 259 0 0 701 0 1 259 0 2 23 0 3 243 0 4 
76 0 5 13 0 512 1 4 -5 47 0 -4 135 0 -3 62 0 -2 98 0 -1 120 0 0 259 0 1 120 0 2 
130 0 3 302 0 4 237 0 5 14 0 512 2 4 -5 129 0 -4 306 0 -2 58 0 -1 130 0 0 23 0 1
98 0 2 58 0 3 152 0 4 35 0 512 3 4 -5 131 0 -4 190 0 -2 152 0 -1 302 0 0 243 0 1
62 0 2 197 0 3 124 0 4 58 0 5 2 0 512 4 4 -5 8 0 -4 66 0 -3 58 0 -2 35 0 -1 237 
0 0 76 0 1 135 0 2 306 0 3 190 0 4 66 0 5 41 0 512 5 4 -3 2 0 -2 67 0 -1 14 0 0 
13 0 1 47 0 2 129 0 3 131 0 4 8 0 5 133 0 512 6 4 -1 156 0 0 38 0 1 4 0 2 5 0 
512 
1 5 -5 42 0 -4 119 0 -3 53 0 -2 82 0 -1 99 0 0 213 0 1 99 0 2 108 0 3 259 0 4 
208 0 512 2 5 -5 117 0 -4 271 0 -3 171 0 -2 49 0 -1 108 0 0 19 0 1 82 0 2 49 0 4
31 0 5 61 0 512 3 5 -5 120 0 -4 170 0 -3 109 0 -2 132 0 -1 259 0 0 207 0 1 53 0 
2 171 0 3 109 0 4 52 0 5 1 0 512 4 5 -4 60 0 -3 52 0 -2 31 0 -1 208 0 0 67 0 1 
119 0 2 271 0 3 170 0 4 60 0 5 37 0 512 5 5 -3 1 0 -2 61 0 -1 13 0 0 12 0 1 42 0
2 117 0 3 120 0 512 6 5 -1 143 0 0 35 0 1 4 0 512 
0 6 -5 11 0 -4 58 0 -3 176 0 -2 15 0 -1 176 0 0 470 0 1 176 0 2 15 0 3 176 0 4 
58 0 5 11 0 512 1 6 -5 38 0 -4 105 0 -3 45 0 -2 70 0 -1 82 0 0 176 0 1 82 0 2 91
0 3 221 0 4 182 0 5 12 0 512 2 6 -5 105 0 -4 240 0 -3 148 0 -2 41 0 -1 91 0 0 15
0 1 70 0 2 41 0 4 27 0 5 55 0 512 3 6 -5 109 0 -4 152 0 -3 96 0 -2 114 0 -1 221 
0 0 176 0 1 45 0 2 148 0 3 96 0 4 47 0 5 1 0 512 4 6 -4 55 0 -3 47 0 -2 27 0 -1 
182 0 0 58 0 1 105 0 2 240 0 3 152 0 4 55 0 5 34 0 512 5 6 -3 1 0 -2 55 0 -1 12 
0 0 11 0 1 38 0 2 105 0 3 109 0 4 6 0 512 6 6 0 33 0 1 4 0 512 
1 7 -5 34 0 -4 92 0 -3 39 0 -2 59 0 -1 69 0 0 147 0 1 69 0 2 77 0 3 190 0 4 159 
0 5 11 0 512 2 7 -5 95 0 -4 213 0 -3 130 0 -2 35 0 -1 77 0 0 13 0 1 59 0 2 35 0 
3 99 0 4 23 0 5 50 0 512 3 7 -4 136 0 -3 85 0 -2 99 0 -1 190 0 0 151 0 1 39 0 2 
130 0 3 85 0 4 42 0 5 1 0 512 4 7 -3 42 0 -2 23 0 0 50 0 1 92 0 2 213 0 3 136 0 
4 50 0 512 5 7 -2 50 0 -1 11 0 0 10 0 1 34 0 2 95 0 4 5 0 512 
0 8 -5 10 0 -4 44 0 -3 131 0 -2 11 0 -1 126 0 0 332 0 1 126 0 2 11 0 3 131 0 4 
44 0 5 10 0 512 1 8 -5 31 0 -4 82 0 -3 33 0 -2 52 0 -1 60 0 0 126 0 1 60 0 2 66 
0 3 166 0 4 141 0 5 10 0 512 2 8 -4 189 0 -3 114 0 -2 30 0 -1 66 0 0 11 0 1 52 0
2 30 0 3 86 0 4 20 0 5 45 0 512 3 8 -4 123 0 -3 76 0 -2 86 0 -1 166 0 0 131 0 1 
33 0 2 114 0 3 76 0 4 38 0 5 1 0 512 4 8 -3 38 0 -2 20 0 -1 141 0 0 44 0 1 82 0 
2 189 0 3 123 0 4 45 0 5 28 0 512 5 8 -1 10 0 1 31 0 2 86 0 512 
1 9 -4 73 0 -3 29 0 -2 45 0 -1 52 0 0 109 0 1 52 0 2 57 0 3 146 0 4 125 0 5 9 0 
512 2 9 -4 170 0 -3 101 0 -2 26 0 -1 57 0 0 9 0 1 45 0 2 26 0 3 76 0 4 18 0 5 41
0 512 3 9 -3 68 0 -2 76 0 -1 146 0 0 115 0 1 29 0 2 101 0 3 68 0 4 35 0 5 1 0 
512 4 9 -2 18 0 0 39 0 1 73 0 2 170 0 3 111 0 4 41 0 5 25 0 512 5 9 0 9 0 1 28 0
2 78 0 512 
0 10 -3 102 0 -2 7 0 -1 96 0 0 252 0 2 7 0 3 102 0 4 34 0 5 8 0 512 1 10 -3 25 0
-2 40 0 -1 46 0 0 96 0 1 46 0 2 50 0 3 129 0 4 111 0 5 9 0 512 2 10 -3 91 0 -2 
23 0 -1 50 0 0 7 0 1 40 0 2 23 0 3 67 0 4 16 0 5 37 0 512 3 10 -2 67 0 -1 129 0 
0 102 0 1 25 0 2 91 0 3 61 0 4 32 0 5 1 0 512 4 10 -1 111 0 0 34 0 1 66 0 2 152 
0 3 100 0 4 38 0 512 
1 11 -3 22 0 -2 36 0 -1 41 0 0 85 0 1 41 0 2 44 0 3 114 0 4 99 0 512 2 11 -2 20 
0 -1 44 0 0 6 0 1 36 0 2 20 0 4 14 0 512 3 11 -1 114 0 0 90 0 1 22 0 2 81 0 3 55
0 512 4 11 0 31 0 1 59 0 2 137 0 3 90 0 512 
0 12 -2 5 0 -1 76 0 0 198 0 1 76 0 2 5 0 3 80 0 4 27 0 512 1 12 -2 33 0 -1 37 0 
0 76 0 1 37 0 2 39 0 3 102 0 4 89 0 512 2 12 -1 39 0 0 5 0 1 33 0 2 17 0 3 53 0 
4 12 0 512 3 12 0 80 0 1 19 0 2 73 0 3 50 0 512 
1 13 0 68 0 1 33 0 2 34 0 3 90 0 4 79 0 512 2 13 2 15 0 3 47 0 512 
0 14 2 3 0 3 62 0 512 1 14 1 30 0 2 30 0 3 79 0 -512 

\EDIT
KEEP FIRST UNTIL C(25)
END
\LIST 12
FULL
END
\SFLS
CALC
END
\EDIT
SPLIT 10 C(25)
END
\MOLAX
ATOM FIRST UNTIL c(4)
PLANE
SAVE
END
\ANISO
ATOM FIRST UNTIL c(4)
TLS
SAVE
ATOM C(25)
AX
SAVE
END
#PRINT 20                                                                       
END

# GIVE A MATRIX EXPLICITLY
#SLANT
MAP TYPE = F-C 0.0  10 NO
CENTROID  0.000     0.000     0.000
MATRIX 8.660    -5.000     0.000
CONT -5.000    -8.660     0.000
CONT  0.000     0.000   -11.000
DOWN  -2.5  20.  0.25
ACROSS  -2.5  20.  0.25
END


# USE SAVED MATRICES AND CENTROIDS
#SLANT
MAP TYPE = F-C 0.0  10 NO
SAVED MOLAX
DOWN  -2.5  20.  0.25
ACROSS  -2.5  20.  0.25
END
#SLANT
MAP TYPE = F-C 0.0 10 NO
SAVED TLS
DOWN  -2.5  20.  0.25
ACROSS  -2.5  20.  0.25
END
#SLANT
MAP TYPE = F-C 0.0  10 NO
SAVED AXES
DOWN  -2.5  20.  0.25
ACROSS  -2.5  20.  0.25
END
 
# LOOK AT SECTIONS ABOVE AND BELOW PRINCIPAL PLANE
#SLANT
MAP TYPE = F-C -.75  10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

#SLANT
MAP TYPE = F-C -.5  10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

#SLANT
MAP TYPE = F-C -.25  10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

#SLANT
MAP TYPE = F-C 0.0 10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

#SLANT
MAP TYPE = F-C .25  10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

#SLANT
MAP TYPE = F-C 0.5  10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

#SLANT
MAP TYPE = F-C 0.75  10 NO
SAV AX
DOWN  -1. 9.  0.25
ACROSS  -1. 9.  0.25
END

\FINI
\\                                                                              
****                                                                            
