module xraylike
	use ParamDef
	implicit none

	contains
	real function fxraylike(Params)
		!type(paramset) :: Params
		real, dimension(2) :: Params
		fxraylike = (Params(1)-3.)**2+(Params(2)-5.)**2
	end function fxraylike

end module xraylike