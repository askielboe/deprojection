program profile

implicit none

CHARACTER *100 BUFFER ! Buffer for command line arguments

!-------------------------------------------------------------------

! CHOOSE THE CHANNEL YOU WANT TO CALCULATE FOR (E_i)
INTEGER 			:: chosenchannel=300

! SET THE PARAMTER TO THE ONE YOU OF CHOISE
! (1: Temp, 2: nH, 3: Abundance, 4: redshift, 6: norm)
INTEGER				:: ipar=6

! SET THE NUMBER OF SPECTRA (this is nspectra from TCL script + 1)
INTEGER,PARAMETER	:: nspectra=101

! SET THE MAX AND MIN VALUE OF CHOSEN PARAMETER
REAL				:: param_min=1., param_max=500.

!-------------------------------------------------------------------

INTEGER,PARAMETER						:: nchannels=1024 
INTEGER,DIMENSION(nspectra,nchannels)	:: channel, count
INTEGER									:: i,n
REAL,DIMENSION(nspectra)				:: params
REAL									:: param, stepsize
CHARACTER 								:: dummy*7, fnamein*32, fnameout*32

! Get command line arguments. If we get one, assume its the chosen channel and overwrite that variable.
CALL GETARG(1,BUFFER)
READ(BUFFER,*) chosenchannel

stepsize = (param_max-param_min)/(nspectra-1.)

params(1) = param_min
do n = 2, nspectra
	params(n) = params(n-1)+stepsize
end do

do n = 1, nspectra
	if (params(n) < 9.999) then
		write(fnamein,'(a,I1,a,F5.3,a)') './output/fakespec_',ipar,'-',params(n),'.txt'
	else if (params(n) < 99.999) then
		write(fnamein,'(a,I1,a,F6.3,a)') './output/fakespec_',ipar,'-',params(n),'.txt'
	else if (params(n) < 999.999) then
		write(fnamein,'(a,I1,a,F7.3,a)') './output/fakespec_',ipar,'-',params(n),'.txt'
	else
		write(fnamein,'(a,I1,a,F8.3,a)') './output/fakespec_',ipar,'-',params(n),'.txt'
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
! write(fnameout,'(a,I1,a,I5,a)') './output/profile_',ipar,'_',chosenchannel,'.txt'
! open(2,file=fnameout, status="replace", form='FORMATTED')
! 
! do n = 1,nspectra
! 	write(2,'(F7.3,a,I10)') params(n), ' ', count(n,chosenchannel)
! end do
! close(2)

! Print output to file (3-d)
open(2,file='./output/profile.txt', status="replace", form='FORMATTED')

do i = 1, 300/3 ! Loop over channels.
	do n = 1,nspectra ! Loop over parameters
		write(2,'(I4,a,F7.3,a,I10)') i*3, ' ', params(n), ' ', count(n,i*3)
	end do
end do
close(2)

write(*,*) 'DONE PROCESSING FILES!'
write(*,'(a,I1,a,I5,a)') 'Output written to: ./output/profile_',ipar,'_',chosenchannel,'.txt'

end program profile