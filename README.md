## Git config backup
This is my git config and ansible-vault merge driver, handy for fixing vault conflicts 

### How to set this up 

* Manual steps
	- Copy `.gitconfig` and `.gitattributes` to your home dir;
	- Make sure the `ansible-vault-merge` is executable;
	- Check the path for `ansible-vault-merge` in your `.gitconfig` to point to the right script;
	- Review and add your name/email or other custom config in your `.gitconfig`
* Scripted steps
	- Navigate to project root folder
	- Run `install.sh` script using `./install.sh`

### How to test if it's working

* Do a merge that resulted in a vault conflict prior of using this driver, and you should see it at work. It kicks in automatically, and most of the times it doesn't ask for input.
