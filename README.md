# TeamsViewerCleanupInstall
Powershell script to enable TeamsViewer Clean up, install and config

-----------------------------------
 ~ TEAMSVIEWER UNINSTALL/INSTALL ~
-----------------------------------
This script (TV_install_auto.ps1) is designed for unattended cleanup any discovered old TeamViewer installs (whether msi or exe installed) and then following cleanup will install fresh version of TeamsViewer along with any required organization configuration (e.g. easy access). 

*** TIP *** : optionally, if you run following:

.\TV_install_auto.ps1 -Verbose  4> VerboseMessages.txt

This will dump output from script into text file that may help capture troubleshooting for later.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NOTE:
(1) MUST be logged on with machine Admin account, running elevated, for this script to work
(2) MUST run PowerShell with elevate execution policy for this script to work.
		E.g:   Set-ExecutionPolicy -ExecutionPolicy unrestricted

(3) Must run this script from same directory as the location of TeamViewer_Host.msi

(4) Script contains TeamsViewer credentials so do NOT share outside of control.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
See Teamviewer web site for more details on configuration: https://community.teamviewer.com/English/kb/articles/34447-command-line-parameters 
