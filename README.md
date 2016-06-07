# SessionBootTime
# Warning
This programm was designed for Windows 8.1. The 32-bits or 64-bits version doesn't matter. But since Windows is modifying his events between version. This programmm is only supposed to work under this version.
N.B: It will not work for Windows 7.

# Description
The purpose of this programm is the calculate the time of a session boot. To be more clear it's the elapsed time between the user loggin is verified and when the desktop is ready. I wanted to have two unvariable metrics. So I used 2 windows events for the delimitation.

#Program
It's constitued of two windows task (.xml files) added via the Task Scheduler and two script written in PowerShell (Windows kinda Shell). For the two first xml files can be imported in the Task Scheduler using  right-click.
The two others just need to be place on the desktop. If you want tomodify that you need to edit the paths in the program.
