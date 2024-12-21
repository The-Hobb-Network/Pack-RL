# The Hobb Network - Rising Legacy
[![Author](https://img.shields.io/badge/Author-Luuk%20Kablan-purple)](https://github.com/LuckyLuuk12)
[![Collaborator](https://img.shields.io/badge/Collaborator-C.M.R.%20Beute-purple)](https://github.com/CastilloNLDE)
![Type](https://img.shields.io/badge/Type-Resource%20Pack-gree)

### Description
This is the official resource pack for the Hobb Network's Rising Legacy gamemode. 
This pack is made to enhance the gameplay experience on the server and to make it more enjoyable for the players. 
If you want to **assist us** please first join our [Discord](https://dc.hobbnetwork.net) and apply for a Creator role.

### Installation
You can easily use the script manually or use below instructions to
perform automatic on-boot updating for you.
1. Open Task Scheduler
2. Create Task|
3. On General: Give it a name and description (optional)
4. On Triggers: Click new, and select “Begin the task at logon”
5. Make sure all boxes are unchecked, except the “enabled” one.
6. Click OK
7. On Actions: Click new, select "Action start a program" and type "Powershell.exe" under Program/Script
8. Add below arguments, to allow powershell to push the actions in the script
```ps1
-ExecutionPolicy Bypass -File "<path\to\the\script.ps1>”` 
```
9. Click OK
10. Skip conditions
11. On Settings: keep everything by default, but uncheck the box “stop the task if it runs longer than..”

Note that when your computer boots it opens a terminal / command prompt. DO NOT CLICK THIS AWAY!
This is the script running and updating the resource pack for you. It will close itself when done.
