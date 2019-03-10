/* Define where padding goes in struct msqid_ds.  MIPS version.
   Copyright (C) 2018-2019 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#ifndef _SYS_MSG_H
# error "Never use <bits/msq-pad.h> directly; include <sys/msg.h> instead."
#endif

#include <bits/timesize.h>

#ifdef __MIPSEL__
# define __MSQ_PAD_AFTER_TIME (__TIMESIZE == 32)
# define __MSQ_PAD_BEFORE_TIME 0
#else
# define __MSQ_PAD_AFTER_TIME 0
# define __MSQ_PAD_BEFORE_TIME (__TIMESIZE == 32)
#endif