Barnsley IFS Fractals

One of the most remarkable spin-offs of
fractal geometry is the ability to "encode"
realistic images in very small sets of numbers
- parameters for a set of functions that map
a region of two-dimensional space onto
itself. In principle (and increasingly in
practice), a scene of any level of complexity
and detail can be stored as a handful of
numbers, achieving amazing "compression"
ratios... how about a super-VGA image of a 
forest, more than 300,000 pixels at eight bits
a piece, from a 1-KB "seed" file?
Again, Michael Barnsley and his co-workers 
at the Georgia Institute of Technology are to 
be thanked for pushing the development of
these iterated function systems (IFS).

Fern
IFS.Init 200 50 40
	0.0 0.85 0.2 -0.15
	0.0 0.04 -0.26 0.28
	0.0 -0.04 0.23 0.26
	0.16 0.85 0.22 0.24
	0.0 0.0 0.0 0.0 
	0.0 1.6 1.6 0.44
	0.01 0.85 0.07 0.07~
IFS.Draw	press "s" to stop

Dragon
IFS.Init 200 50 40
	0.824074 0.088272  0.0 0.0
	0.281482 0.520988 0.0 0.0
	-0.212346 -0.463889 0.0 0.0
	0.864198 -0.377778 0.0 0.0
	-1.882290 0.785360 0.0 0.0
	-0.110607 8.095795 0.0 0.0
	0.787473 0.212527 0.0 0.0~
IFS.Draw	press "s" to stop

Binary
IFS.Init 200 50 40
	0.5 0.5 0.0 0.0
	0.0 0.0 -0.5 0.0
	0.0 0.0 0.5 0.0
	0.5 0.5 0.0 0.0
	-2.563477 2.436544 4.873085 0.0
	-0.000003 -0.000003 7.563492 0.0
	0.333333 0.333333 0.333333 0.0~
IFS.Draw	press "s" to stop

Coral
IFS.Init 200 50 40
	0.307692 0.307692 0.0 0.0
	-0.531469 -0.076923 0.545455 0.0
	-0.461538 0.153846 0.692308 0.0
	-0.293706 -0.447552 -0.195804 0.0
	5.401953 -1.295248 -4.893637 0.0
	8.655175 4.152990 7.269794 0.0
	0.4 0.15 0.45 0.0~
IFS.Draw	press "s" to stop

Crystal
IFS.Init 200 50 40
	0.69697 0.090909 0.0 0.0
	-0.481061 -0.443182 0.0 0.0
	-0.393939 0.515152 0.0 0.0
	-0.662879 -0.094697 0.0 0.0
	2.147003 4.286558 0.0 0.0
	10.310288 2.925762 0.0 0.0
	0.747826 0.252174 0.0 0.0~
IFS.Draw	press "s" to stop

Floor
IFS.Init 200 50 40
	0.0 0.5 0.0 0.0
	-0.5 0.0 0.5 0.0
	0.5 0.0 -0.5 0.0
	0.0 0.5 0.0 0.0
	-1.732366 -0.027891 1.620804 0.0
	3.366182 5.014877 3.310401 0.0
	0.333333 0.333333 0.333333 0.0~
IFS.Draw	press "s" to stop

Koch3
IFS.Init 200 50 40
	0.307692 0.192308 0.192308 0.307692
	-0.0 -0.205882 0.205882 -0.0
	0.0 0.653846 -0.653846 0.0
	0.294118 0.088235 0.088235 0.294118
	4.119164 -0.688840 0.668580 -4.136530
	1.604278 5.978916 5.962514 1.604278
	0.151515 0.253788 0.253788 0.151515~
IFS.Draw	press "s" to stop

Spiral
IFS.Init 200 50 40
	0.787879 -0.121212 0.181818 0.0
	-0.424242 0.257576 -0.136364 0.0
	0.242424 0.151515 0.090909 0.0
	0.859848 0.053030 0.181818 0.0
	1.758647 -6.721654 6.086107 0.0
	1.408065 1.377236 1.568035 0.0
	0.895652 0.052174 0.052174 0.0~
IFS.Draw	press "s" to stop

Triangle
IFS.Init 200 50 40
	0.5 0.5 0.5 0.0
	0.0 0.0 0.0 0.0
	0.0 0.0 0.0 0.0
	0.5 0.5 0.5 0.0
	0.0 0.0 1.0 0.0
	0.0 1.0 1.0 0.0
	0.33 0.33 0.34 0.0~
IFS.Draw	press "s" to stop

Zigzag
IFS.Init 200 50 40
	-0.632407 -0.036111 0.0 0.0
	-0.614815 0.444444 0.0 0.0
	-0.545370 0.210185 0.0 0.0
	0.659259 0.037037 0.0 0.0
	3.840822 2.071081 0.0 0.0
	1.282321 8.330552 0.0 0.0
	0.888128 0.111872 0.0 0.0~
IFS.Draw	press "s" to stop

Tree
IFS.Init 200 50 40
	0.0 0.42 0.42 0.1
	0.0 -0.42 0.42 0.0
	0.0 0.42 -0.42 0.0
	0.5 0.42 0.42 0.1
	0.0 0.0 0.0 0.0
	0.0 0.2 0.2 0.2
	0.05 0.4 0.4 0.15~
IFS.Draw	press "s" to stop

Swirl5
IFS.Init 200 50 40
	0.745455 -0.424242 0.0 0.0
	-0.459091 -0.065152 0.0 0.0
	0.406061 -0.175758 0.0 0.0
	0.887121 -0.218182 0.0 0.0
	1.460279 -3.809567 0.0 0.0
	0.691072 6.741476 0.0 0.0
	0.912675 0.087325 0.0 0.0~
IFS.Draw	press "s" to stop

Tool text contributed by W. Ibl
