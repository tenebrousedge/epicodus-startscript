# Epic Start

This is a shell script which is intended to set up a new workstation with some useful stuff. It's intended as a start-of-day process for Epicodus, but may be more generally useful (who knows). As of the time of this writing, I haven't actually tested this.

## Usage

So generally you just need to drop this somewhere and run it.

* clone the repo: `git clone https://github.com/tenebrousedge/epicodus-startscript ~/startscript`
* **source** the script by typing `. ~/startscript/startup_script.sh`
* get coffee, this may take a few minutes
* type `zsh`

Check out `prompt -p` if you want to see what prompts are available, and (example) `prompt steeef` to set the one you want.
You also get the new project creation script, so you can type `new_project` from anywhere, type in the project name, and it will create a new project in a folder with that name in your desktop.

Happy coding!

## Dependencies

This script requires npm, Atom, git, and zsh to be installed or it will fail horribly. All of these things should be installed by default at Epicodus.

## License
Copyright 2017 by Kai
licensed CC0
