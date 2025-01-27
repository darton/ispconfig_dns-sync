# ispconfig dns-sync
## Setup

Create an ssh account named slavens on the server running the ispconfig panel.

Set the IP address of the ispconfig server in the shadow_master_dns variable.

In the masters variable, set the IP addresses of the master DNS servers.

Set the IP address of the slave dns server to the this_nsip variable. 
