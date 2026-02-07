# Vencord User Plugins Updater

A simple, fast Windows batch script to update all your Vencord user plugins

### What it does
- Prompts you for your Vencord folder path (e.g. `D:\Vencord`)
- Automatically finds the `src\userplugins` folder (supports entering the full path, `src`, `userplugins`, or just a drive letter to search the entire drive)
- Goes through every subfolder in `userplugins`
- Runs `git pull` only on actual Git repositories (your real plugins)
- Shows clear output for each folder with Git's own messages
- At the end, gives a clean summary:
  - How many Git plugins were checked
  - How many actually received updates
  - How many folders were skipped (not Git repos)

### Why use this?
- No need to manually open each plugin folder and run `git pull`
- Perfect for users with many Vencord plugins

### Requirements
- Windows
- [Git installed and available in PATH](https://git-scm.com/install/)
- Vencord installed and must have userplugins folder (obviously)

### How to use
1. Download the script (save as `vencord-plugins-updater.bat`)
2. Double-click it.
3. Enter your Vencord folder path when prompted (e.g. `D:\Vencord`)
4. Watch it update everything automatically!

That's it!

Feel free to contribute if you have improvements!!!!!

Made for Vencord community :)


