program parse

implicit none

CHARACTER *100 BUFFER ! Buffer for command line arhguments

!-------------------------------------------------------------------

! CHOOSE THE CHANNEL YOU WANT TO CALCULATE FOR (E_i)
INTEGER 			:: chosenchannel=300

! SET THE NUMBER OF SPECTRA (this is nspectra from TCL script + 1)
INTEGER,PARAMETER	:: nspectra=101

! SET THE MAX AND MIN TEMPERATURE
REAL				:: temp_min=0.1, temp_max=15.

!-------------------------------------------------------------------

INTEGER,PARAMETER						:: nchannels=1024 
INTEGER,DIMENSION(nspectra,nchannels)	:: channel, count
INTEGER									:: i,n
REAL,DIMENSION(nspectra)				:: temps
DOUBLE PRECISION						:: temp, stepsize
CHARACTER 								:: dummy*7, fnamein*32, fnameout*32

! Get command line arguments. If we get one, assume its the chosen channel and overwrite that variable.
CALL GETARG(1,BUFFER)
READ(BUFFER,*) chosenchannel

stepsize = (temp_max-temp_min)/(nspectra-1)

temps(1) = temp_min
do n = 2, nspectra
	temps(n) = temps(n-1)+stepsize
end do

do n = 1, nspectra
	if (temps(n) < 9.999) then
		write(fnamein,'(a,F5.3,a)') './output/fakespec_',temps(n),'.txt'
	else
		write(fnamein,'(a,F6.3,a)') './output/fakespec_',temps(n),'.txt'
	end if
	!print *, 'Processing file: ', fnamein
	open(1,file=fnamein,form='formatted')
	read(1,*) dummy ! Skip the column names
	do i = 1,nchannels
		read(1,*) channel(n,i), count(n,i)
	end do
end do
close(1)

! Print output to file (2-d)
write(fnameout,'(a,I5,a)') './output/temp_profile_',chosenchannel,'.txt'
open(2,file=fnameout, status="replace", form='FORMATTED')

do n = 1,nspectra
	write(2,'(F6.3,a,I10)') temps(n), ' ', count(n,chosenchannel)
end do
close(2)

! Print output to file (3-d)
! open(2,file='./output/temp_profile.txt', status="replace", form='FORMATTED')
! 
! do i = 1, 300/3 ! Loop over channels.
! 	do n = 1,30 ! Loop over temperatures
! 		write(2,'(I4,a,F6.3,a,I10)') i*3, ' ', temps(n), ' ', count(n,i*3)
! 	end do
! end do
! close(2)

write(*,*) 'DONE PROCESSING FILES!'
write(*,'(a,I5,a)') 'Output written to: ./output/temp_profile_',chosenchannel,'.txt'

end program parse