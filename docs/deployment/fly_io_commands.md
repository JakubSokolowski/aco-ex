# Connecting to console on deployment
Ensure you're logge in with
```bash
fly auth login
```
And then run the following command to connect to the console
```bash
fly ssh console
```
# Connecting to iex on deployment

```bash
fly ssh console --pty -C "/app/bin/aoc remote"
```
If you get error like:
```
❯ fly ssh console --pty -C "/app/bin/aoc remote"
WARN The running flyctl agent (v0.1.149) is older than the current flyctl (v0.3.13).
WARN The out-of-date agent will be shut down along with existing wireguard connections. The new agent will start automatically as needed.
Error: app aoc-ex has no started VMs.
It may be unhealthy or not have been deployed yet.
Try the following command to verify:

fly status
```
The `fly status` output was:
```
❯ fly status
App
  Name     = aoc-ex
  Owner    = personal
  Hostname = aoc-ex.fly.dev
  Image    = aoc-ex:deployment-01J92HVAAMMK2BNP1BNV2CDF8Z

Machines
PROCESS	ID            	VERSION	REGION	STATE  	ROLE	CHECKS	LAST UPDATED
app    	d890de6f6923e8	11     	waw   	stopped	    	      	2024-09-30T22:54:31Z
app    	e2867647b00178	11     	waw   	stopped	    	      	2024-09-30T22:47:44Z
```
Visiting the app url at https://aoc-ex.fly.dev/ seems to start the VMS. After that, the command works.
