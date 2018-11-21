# Oracle Conc Requests Log and Out File Transfer tool

Requirement:
Often Oracle AM Teams need concurrent request log and out files to verify errors and troubleshoot. However, since they do not always have application server access, it is quite a hassle for the DBA Team to provide these files. The task can be easily automated. Infact, most log file sharing can easily be optimized to reduce DBA team work load and wait time for incident resolution.

Objective:
Transfer concurrent request log and output files from production server to the development servers.

Access/Grants required:
Unix access to application servers for both Production and Dev environments.
Access of deploying shell scripts and schedule crontabs in the Concurrent node of the production instance.
'lftp' package must be installed in the server. Contact Server Team if not available.

Skills:
Unix Shell Scripting.

Time required to set up:
1 hour 