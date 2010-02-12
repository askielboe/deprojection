proc fakespec { args } {
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# BEGIN > DEFINITIONS - CHANGE THESE TO YOUR SPECIFIC TASK! #

	# Filenames
	set file_response "1666_3.wrmf"
	set file_arf "1666_3.warf"
	
	# Model Parameters
	set nspectra 100. ; # Note that we actually get nspectra+1 spectra!
	set temp_min 1.   ; # Decimals are limited to 3 places,
	set temp_max 30.  ; # this can be changed, but then has to be changed in the fortran code as well.
	set nH 1.
	set abundance 0.3
	set redshift 0.18
	
	# Fakeit Parameters
	set exposuretime 41796.2
	
# END > DEFINITIONS                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	# Note that this way we actually get nspectra+1 spectra!
	set stepsize [expr ($temp_max-$temp_min)/$nspectra]

	# Initiate the model (ignoring parameters for now)
	model mekal & & & & & & &
	
	# Run through all parameters generating spectra and dumping to unique ACSII files
	for {set temp $temp_min} {$temp <= $temp_max} {set temp [expr $temp + $stepsize]} {
		newpar 1 & $temp
		puts "Faking spectrum with temp: $temp"
		fakeit none & $file_response & $file_arf & y & & ./output/fakespec.fak & $exposuretime &
		puts "Dumping spectrum to: fakespec_$temp.txt"
		fdump infile=./output/fakespec.fak outfile=./output/fakespec_[format "%1.3f" $temp].txt columns='COUNTS' rows=1-1024 prhead=no
	}
}