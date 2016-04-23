#!/opt/sfw/bin/gsed -Enuf

:init-matrix
	# as a first line i'm always getting position of first two first numbers in matrix
	/&/ b output

:iter
	# if we're here we've matrix in holder space. So append it to the pattern space
	G
	s/\n/:/
	y/AB/ab/
# now we need to reverse or rotate
	# we can merge blocks by left and right moving as is
	/[UD]/b rotate

	/[L]/b concat
:reflect
	/[R]C[N]{0,4}/{
		h		
	}
	s/&(.)(.)(.)(.)&(.)(.)(.)(.)(&....&....)/\&\4\3\2\1\&\8\7\6\5\9/
	s/(&....&....)&(.)(.)(.)(.)&(.)(.)(.)(.)/\1\&\5\4\3\2\&\9\8\7\6/
	b concat

:rotate
	# well. What we need to do when we're trying to move up?
	#We need to rotate matrix clockwise. 
	# So then to move down need to rotate matrix anti- clockwise
	/[UD]C[N]{0,4}/{
		h	
	}
	/[U]/b anti-clockwise

	#clockwise for up moving
	
	# a b|c d ->  m i|e a
	# e f|g h ->  n j|f b
 	# -------     -------
	# i j|k l ->  o k|g c
	# m n|o p ->  p l|h d

	# (ab)|(cd) ->  (ij)|(ab)
	# (ef)|(gh) ->  (mn)|(ef)
	# --------- ->  ---------
	# (ij)|(kl) ->  (kl)|(cd)
	# (mn)|(op) ->  (op)|(gh)
	#	ab  cd   ef  gh   ij  kl   mn  op    ijab  mnef klcd opgh
	s/&(..)(..)&(..)(..)&(..)(..)&(..)(..)/\&\5\1\&\7\3\&\6\2\&\8\4/

	# i j|a b ->  m i|a b
	# m n|e f ->  n j|e f
	# ------- ->  ------- 
	# k l|c d ->  k l|c d
	# o p|g h ->  o p|g h
	#	i  j  ab   m  n  ef
	s/&(.)(.)(..)&(.)(.)(..)/\&\4\1\3\&\5\2\6/1

	# i j|a b ->  m i|e a
	# m n|e f ->  n j|f b
	# ------- ->  ------- 
	# k l|c d ->  k l|c d
	# o p|g h ->  o p|g h
	#	mi  a  b   nj  e  f
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\5\2\&\4\6\3/1

	# m i|e a ->  m i|e a
	# n j|f b ->  n j|f b
	# ------- ->  -------
	# k l|c d ->  o k|g c
	# o p|g h ->  p l|h d

	s/&(.)(.)(..)&(.)(.)(..)/\&\4\1\3\&\5\2\6/2
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\5\2\&\4\6\3/2

	b concat
	:anti-clockwise
	#anticlockwise for up moving
	
	# a b|c d -> d h|l p   
	# e f|g h -> c g|k o
 	# -------    -------
	# i j|k l -> b f|j n
	# m n|o p -> a e|i m

	# (ab)|(cd) ->  (cd)|(kl)
	# (ef)|(gh) ->  (gh)|(op)
	# --------- ->  ---------
	# (ij)|(kl) ->  (ab)|(ij)
	# (mn)|(op) ->  (ef)|(mn)
	#	ab  cd   ef  gh   ij  kl   mn  op     cdkl  ghop abij  efmn
	s/&(..)(..)&(..)(..)&(..)(..)&(..)(..)/\&\2\6\&\4\8\&\1\5\&\3\7/

	# rotate with same ideas as you see before  
	
	#	c  d  kl   g  h  op  	
	#   1  2  3    4  5   6    dhkl     cgop
	s/&(.)(.)(..)&(.)(.)(..)/\&\2\5\3\&\1\4\6/1
	#	dh  k  l   cg  o  p
	#   1   2  3   4   5  6
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\3\6\&\4\2\5/1
	
	s/&(.)(.)(..)&(.)(.)(..)/\&\2\5\3\&\1\4\6/2
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\3\6\&\4\2\5/2
	

:concat
	# remove empty fields
	/[L]C[N]{0,4}/{
		h		
	}
	s/-//g
#	i\
#		preconcat
#	p
	/kk/{
		s/kk/l/g
		s/([UDLR])/\1W/
	}
	/jj/{
		s/jj/k/g
		s/([UDLR])/\1W/
	}
	/ii/{
		s/ii/j/g
	}
	/hh/{
		s/hh/i/g
	}
	/gg/{
		s/gg/h/g
	}
	/ff/{
		s/ff/g/g
	}
	/ee/{
		s/ee/f/g
	}
	/dd/{
		s/dd/e/g
	}
	/cc/{
		s/cc/d/g
	}
	/bb/{
		s/bb/c/g
	}
	/aa/{
		s/aa/b/g
	}
#	i\
#		postconcat
#	p
:expand
	#always expand anysize cell to size+4 dashes
	s/(&[^&]{,4})/\1----/g
	#and remove all symbols exclude first 4 after &
	s/(&....)[^&]*/\1/g
	/[UD]/b anti-rotate


:anti-reflect-if-right
	/[R]/ {
	s/&(.)(.)(.)(.)&(.)(.)(.)(.)(&....&....)/\&\4\3\2\1\&\8\7\6\5\9/
	s/(&....&....)&(.)(.)(.)(.)&(.)(.)(.)(.)/\1\&\5\4\3\2\&\9\8\7\6/
	} 
	b place-new-digit

:anti-rotate
	/[U]/b clockwise
	
	s/&(..)(..)&(..)(..)&(..)(..)&(..)(..)/\&\2\6\&\4\8\&\1\5\&\3\7/
	s/&(.)(.)(..)&(.)(.)(..)/\&\2\5\3\&\1\4\6/1
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\3\6\&\4\2\5/1
	s/&(.)(.)(..)&(.)(.)(..)/\&\2\5\3\&\1\4\6/2
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\3\6\&\4\2\5/2

	b place-new-digit
	:clockwise
	s/&(..)(..)&(..)(..)&(..)(..)&(..)(..)/\&\5\1\&\7\3\&\6\2\&\8\4/
	s/&(.)(.)(..)&(.)(.)(..)/\&\4\1\3\&\5\2\6/1
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\5\2\&\4\6\3/1
	s/&(.)(.)(..)&(.)(.)(..)/\&\4\1\3\&\5\2\6/2
	s/&(..)(.)(.)&(..)(.)(.)/\&\1\5\2\&\4\6\3/2

	
:place-new-digit

#i\
#		after expand
#	p
	/C[N]{0,4}/{
		G
		s/\n/%/
#i\
#			failcheck
#		p
		/([ULDRCNP]* (&....){4})%\1/{
			# didnt changed? So just add more one N to C
			s/%.*//
			s/(C[NP]{0,4})/\1N/
			h
			b lose-check
		}
		#test passed
		s/(C[NP]{0,4})/\1P/
		b lose-check
	}
	# at this time we've [UDLR] \d;2|4 in our string so just
	# add number in empty cell. 

	# at this time we've new order and old in holder buffer
	G
	y/AB/ab/
   # so then
   s/\n/:/
	# that means what if previous state duplicate current we mustnt
   # fill empty cell
   /([^:]{20}).*\1/ {
   #remove moving-checker
   s/([UDLR][W]? [;0-9]+:[^:]*:).*/\1/
	# move to end of script. We dont need to redraw matrix if 
	# it's has not changed
   	b 
   }
   #remove moving-checker
   s/([UDLN][W]? [;0-9]+:[^:]*:).*/\1/
   # duplicate matrix 9 times. Later i will select one of them 	
	#that contains a marker
   s/([^:]{20})/\1:\1:\1:\1:\1:\1:\1:\1:\1:\1:\1:\1:\1:\1:\1:\1/
	/ 16;/ {
	   	s/-/A/16
	   	b replace-A-to-B-if-four
	   }
	/ 15;/ {
	   	s/-/A/15
	   	b replace-A-to-B-if-four
	   }
	/ 14;/ {
	   	s/-/A/14
	   	b replace-A-to-B-if-four
	   }
	/ 13;/ {
	   	s/-/A/13
	   	b replace-A-to-B-if-four
	   }
	/ 12;/ {
	   	s/-/A/12
	   	b replace-A-to-B-if-four
	   }
	/ 11;/ {
   		s/-/A/11
   		b replace-A-to-B-if-four
  	}

	/ 10;/ {
		s/-/A/10
		b replace-A-to-B-if-four
	}
	/ 9;/ {
		s/-/A/9
		b replace-A-to-B-if-four
	}
	/ 8;/{
		s/-/A/8
		b replace-A-to-B-if-four
	}
	/ 7;/{
		s/-/A/7
		b replace-A-to-B-if-four
	}
	/ 6;/{
		s/-/A/6
		b replace-A-to-B-if-four
	}
	/ 5;/{
		s/-/A/5
		b replace-A-to-B-if-four
	}
	/ 4;/{
		s/-/A/4
		b replace-A-to-B-if-four
	}
	/ 3;/{
		s/-/A/3
		b replace-A-to-B-if-four
	}
	/ 2;/{
		s/-/A/2
		b replace-A-to-B-if-four
	}
	/ 1;/{
		s/-/A/1
		b replace-A-to-B-if-four
	}
	
   :replace-A-to-B-if-four
   	/;4/s/A/B/
   # now need to extract matrix contains A|B
   s/[UDLR]([W]?).*(:[^:]*[AB][^:]*:).*/\1\2/
   t place-new-digit-end
	
:place-new-digit-end

:output
	# move to hell dat garbage
	s/([W]?).*:([^ ]{20}):.*/\1\2/

 	# save buffer for next iteration
	h
	# change tokens to numbers
	s/-/|____/g
	s/a/|__2_/g
	s/b/|__4_/g
	s/c/|__8_/g
	s/d/|__16/g
	s/e/|__32/g
	s/f/|__64/g
	s/g/|_128/g
	s/h/|_256/g
	s/i/|_512/g
	s/j/|1024/g
	s/k/|2048/g
	s/l/|4096/g
	s/A/|±±2±/g
	s/B/|±4±±/g

   # build matrix with borders
	s/^/[2J[H/
	s/&/|\n/g
	s/$/|\n/g
	s/\|\n/+-------------------+\n/

	/W/ {
		s/W//
		p
		i\
			You win!
		q
	}
	#out
	p
#lose check
#you lose if there are no possible movings. 
#need to check possible movings in all directions and if there is no movings, quit with game over message
:lose-check
	/P/{
		#test passed
		g
		s/^[^&]*//
		h
		b
	}
	/NNNN/{
#i\
#			frth
		b fail
	}
	/NNN/{
#i\
#			thrd
		b right-lose-check
	}
	/NN/{
#i\
#			scnd
		b down-lose-check
	}
	/N/{
#i\
#			fst
		b up-lose-check
	}
:left-lose-check
	g
	s/([ULDRCNP]* )(&....){4}\n((&....){4})/\1\3/
	y/AB/ab/
	#set up C (lose-Check) flag
	s/^/LC /
	#  as is
	b concat
:up-lose-check
	g
	s/([ULDRCNP]* )(&....){4}\n((&....){4})/\1\3/
	y/AB/ab/
	s/^LC/UC/
#	i\
#		up-lose-check
#	p
	b rotate
:down-lose-check
	g
	s/([ULDRCNP]* )(&....){4}\n((&....){4})/\1\3/
	y/AB/ab/
	s/UC/DC/
	b rotate
:right-lose-check
	g
	s/([ULDRCNP]* )(&....){4}\n((&....){4})/\1\3/
	y/AB/ab/
	s/DC/RC/
	b reflect
:fail
/NNNN/{
	i\
		Game over
	q
}

