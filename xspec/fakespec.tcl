proc fakespec { args } {
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# BEGIN > DEFINITIONS - CHANGE THESE TO YOUR SPECIFIC TASK! #

	# Filenames
	set file_response "1666_3.wrmf"
	set file_arf "1666_3.warf"
	
	# Model Parameters
	set nspectra 10.
	set temp_min 1.
	set temp_max 5.
	set nH 1.
	set abundance 0.3
	set redshift 0.18
	
	# Fakeit Parameters
	set exposuretime 41796.2
	
# END > DEFINITIONS                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

	set stepsize [expr ($temp_max-$temp_min)/$nspectra]

	# Initiate the model (ignoring parameters for now)
	model mekal & & & & & & &
	
	# Run through all parameters generating spectra and dumping to unique ACSII files
	for {set temp $temp_min} {$temp <= $temp_max} {set temp [expr $temp + $stepsize]} {
		newpar 1 & $temp
		puts "Faking spectrum with temp: $temp"
		fakeit none & $file_response & $file_arf & y & & ./output/fakespec.fak & $exposuretime &
		puts "Dumping spectrum to: fakespec_$temp.txt"
		fdump infile=./output/fakespec.fak outfile=./output/fakespec_$temp.txt columns='COUNTS' rows=1-1024 prhead=no
	}
}