//
// Copyright 2017 Garrett D'Amore <garrett@damore.org>
// Copyright 2017 Capitar IT Group BV <info@capitar.com>
//
// This software is supplied under the terms of the MIT License, a
// copy of which should be located in the distribution where this
// file was obtained (LICENSE.txt).  A copy of the license may also be
// found online at https://opensource.org/licenses/MIT.
//

#ifndef NNG_PROTOCOL_REQREP0_REQ_H
#define NNG_PROTOCOL_REQREP0_REQ_H

#ifdef __cplusplus
extern "C" {
#endif

NNG_DECL int nng_req0_open(nng_socket *);

#ifndef nng_req_open
#define nng_req_open nng_req0_open
#endif

#define NNG_OPT_REQ_RESENDTIME "req:resend-time"

#ifdef __cplusplus
}
#endif

#endif // NNG_PROTOCOL_REQREP0_REQ_H
