//
// Copyright 2017 Garrett D'Amore <garrett@damore.org>
// Copyright 2017 Capitar IT Group BV <info@capitar.com>
//
// This software is supplied under the terms of the MIT License, a
// copy of which should be located in the distribution where this
// file was obtained (LICENSE.txt).  A copy of the license may also be
// found online at https://opensource.org/licenses/MIT.
//

#ifndef NNG_PROTOCOL_REQREP0_REP_H
#define NNG_PROTOCOL_REQREP0_REP_H

#ifdef __cplusplus
extern "C" {
#endif

NNG_DECL int nng_rep0_open(nng_socket *);

#ifndef nng_rep_open
#define nng_rep_open nng_rep0_open
#endif

#ifdef __cplusplus
}
#endif

#endif // NNG_PROTOCOL_REQREP0_REP_H
