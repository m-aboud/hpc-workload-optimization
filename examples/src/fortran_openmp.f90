program fortran_openmp
  use omp_lib
  implicit none
  integer :: i, n
  real(8) :: s
  n = 1000000
  s = 0.0d0
!$omp parallel do reduction(+:s)
  do i = 1, n
     s = s + 1.0d0 / dble(i)
  end do
!$omp end parallel do
  print *, 'threads=', omp_get_max_threads(), ' harmonic_sum=', s
end program fortran_openmp
