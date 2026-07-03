Markdown
# bc-mulitjob

An advanced, lightweight multi-job system for FiveM servers running the **QBCore** framework, featuring a clean visual menu interface powered by `ox_lib`.

## 🛠️ Features
- **Visual Interface:** Dynamic job management menu using modern `ox_lib` context menus.
- **Player Metadata Storage:** Efficiently saves player job profiles seamlessly inside QBCore's native player metadata—no extra SQL queries or database setups needed!
- **On-the-Fly Switching:** Swap between saved job roles securely with exploit prevention checks.
- **Job Resignation:** Dedicated sub-menus allowing players to permanently quit a backup job slot (cannot quit an active on-duty job).
- **Admin Utilities:** Built-in console and chat commands for server staff to easily grant or wipe job slots during player support or testing.

## 📦 Dependencies
Make sure you have these core resources installed and started before this script:
- `qb-core`
- `ox_lib`

## 🚀 Installation
1. Download or clone this repository into your server's `resources` directory.
2. Ensure the folder is named exactly `bc-mulitjob`.
3. Add the following line to your `server.cfg`:
   ```fxserver
   ensure bc-mulitjob
⚙️ Configuration
You can customize keybinds, max job limits, and menu icons inside the root config.lua file:

Config.MaxJobs - Set the maximum number of job profiles a player can hold at once (Default: 3).

Config.Command - The registration command to open the interface (Default: multijob).

Config.Keybind - The mapped keyboard button to open the menu instantly (Default: F5).

💻 Commands
Player Commands
/multijob (or your configured hotkey) - Opens the visual job management profile menu.

Admin Commands
/addjob <id> <jobName> <grade> - Forcefully injects a specific job tier into a player's saved multi-job profiles.

/clearjobs <id> - Wipes out all saved multi-job metadata slots for a specific player ID.

🔗 Developer Exports
You can trigger this script from external resources (like a job center, hiring NPC, or application system) using this export:

Lua
exports['bc-mulitjob']:AddJobToPlayer(source, 'police', 0)

### 📂 Updated Folder View
Once you drop it in, your finalized structure will look completely professional:
```text
📂 bc-mulitjob/
├── 📂 client/
│   └── 📄 client.lua
├── 📂 server/
│   └── 📄 server.lua
├── 📂 shared/
├── 📄 config.lua
├── 📄 fxmanifest.lua
└── 📄 README.md