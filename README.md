# ispconfig dns-sync

The script is used to automatically download a list of domains from the ispconfig server database and automatically configure these domains on the slave DNS server on which the script is run.

## Setup

Create an ssh account named slavens on the server running the ispconfig panel.

Set the IP address of the ispconfig server in the shadow_master_dns variable.

In the masters variable, set the IP addresses of the master DNS servers.

Set the IP address of the slave dns server to the this_nsip variable. 
