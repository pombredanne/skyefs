/*
 * RPC definitions for the SkyeFs
 */

#include <asm-generic/errno-base.h>
#include "defaults.h"

#ifdef RPC_HDR
%#include <pvfs2-types.h>
%#include <sys/types.h>
#elif RPC_XDR
%#include "skye_rpc_helper.h"
%#pragma GCC diagnostic ignored "-Wunused-variable"
%#pragma GCC diagnostic ignored "-Wunused-parameter"
#elif RPC_SVC
%#pragma GCC diagnostic ignored "-Wunused-parameter"
#endif

typedef string skye_pathname<MAX_PATHNAME_LEN>;
typedef opaque skye_file_data<MAX_SIZE>;
typedef long skye_bitmap;

union skye_result switch (int errnum) {
	case -EAGAIN:
		skye_bitmap bitmap;
	default:
		void;
};

union skye_lookup switch (int errnum) {
	case 0:
		PVFS_object_ref ref;
	case -EAGAIN:
		skye_bitmap bitmap;
	default:
		void;
};

/* RPC definitions */

program SKYE_RPC_PROG {                 /* program number */
	version SKYE_RPC_VERSION {          /* version number */
		bool SKYE_RPC_INIT(void) = 1;
		skye_lookup SKYE_RPC_LOOKUP(PVFS_credentials, PVFS_object_ref, skye_pathname) = 2;
		
		skye_lookup SKYE_RPC_CREATE(PVFS_credentials, PVFS_object_ref, skye_pathname,
				mode_t) = 101;
		skye_result SKYE_RPC_MKDIR(PVFS_credentials, PVFS_object_ref, skye_pathname,
				mode_t) = 102;
		skye_result SKYE_RPC_RENAME(PVFS_credentials, skye_pathname, PVFS_object_ref,
				skye_pathname, PVFS_object_ref) = 103;
	} = 1;
} = 522222; /* FIXME: Is this a okay value for program number? */
