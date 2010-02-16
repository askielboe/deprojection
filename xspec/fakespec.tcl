proc fakespec { args } {
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# BEGIN > DEFINITIONS - CHANGE THESE TO YOUR SPECIFIC TASK! #

	# Filenames
	set file_response "1666_3.wrmf"
	set file_arf "1666_3.warf"
	
	# Parameter to vary
	set ipar 6			; # 1: Temp, 2: nH, 3: Abundance, 4: redshift, 6: norm
	set param_min 1.	; # Decimals are limited to 3 places,
	set param_max 500.	; # this can be changed, but then has to be changed in the fortran code as well.
	set nspectra 100.	; # Note that we actually get nspectra+1 spectra!
	
	# Model Parameters

	set temp 1.
	set nH 1.
	set abundance 0.3
	set redshift 0.18
	set switch 1.
	set norm 1.
	
	# Fakeit Parameters
	set exposuretime 41796.2
	
# END > DEFINITIONS                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if {[exec ls ./output/] == ""} then {
	# Note that this way we actually get nspectra+1 spectra!
	set stepsize [expr ($param_max-$param_min)/$nspectra]

	# Initiate the model (ignoring parameters for now)
	model mekal & $temp & $nH & $abundance & $redshift & $switch & $norm &

	dummy ; #0.1 5 1000

	# Run through all parameters generating spectra and dumping to unique ACSII files
	for {set param $param_min} {$param <= $param_max} {set param [expr $param + $stepsize]} {
		newpar $ipar & $param
		puts "Faking spectrum with parameter $ipar = $param."
		fakeit none & $file_response & $file_arf & y & & ./output/fakespec.fak & $exposuretime &
		# fakeit & y & & ./output/fakespec.fak & $exposuretime &
		puts "Dumping spectrum to: fakespec_$ipar-$param.txt"
		fdump infile=./output/fakespec.fak outfile=./output/fakespec_$ipar-[format "%4.3f" $param].txt columns='COUNTS' rows=1-1024 prhead=no
		}
} else {
	set question "N"
	puts "OUTPUT DIRECTORY NOT EMPTY!"
	puts "Please move files you want to save to another directory before running fakespec!"
	puts "If you want to delete all content of the output folder press 'y' now."
	gets stdin question
		if {$question == "y"} then {
			rm ./output/*
			puts "Deleting contents of output folder. Please run fakespec again to generate new spectra."
		} else {
			puts "Output directory NOT empty. Stopping..."
		}
}
}