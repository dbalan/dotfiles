#RTEMS variables

export RTEMS_VERSION=4.11
export RTEMS_ROOT=$HOME/development/rtems
export RTEMS=${RTEMS_ROOT}/${RTEMS_VERSION}


# Export path
export PATH=${RTEMS}/bin:$PATH

# Makefile 
export RTEMS_BSP=sparc-rtems${RTEMS_VERSION}/sis
export RTEMS_MAKEFILE_PATH=${RTEMS}/${RTEMS_BSP}
export RTEMS_SHARE=${RTEMS}/share/rtems${RTEMS_VERSION}
