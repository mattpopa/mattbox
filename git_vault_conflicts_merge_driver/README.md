# Git config for fixing vault conflicts
This is my git config backup file and ansible-vault merge driver, handy for fixing vault conflicts. 

## How to set this up 

* Install script
	- Run `install.sh` script using `./install.sh`
	- Congrats! You should now have the merge driver set up in your `~/.gitattributes` and `~/.gitconfig`

OR
</br>


* Manual steps
	- Copy `.gitconfig` and `.gitattributes` to your home dir;
	- Make sure the `ansible-vault-merge` is executable;
	- Check the path for `ansible-vault-merge` in your `.gitconfig` to point to the right script;
	- Review and add your name/email or other custom config in your `.gitconfig`

## How to test if it's working

* Do a merge that resulted in a vault conflict prior of using this driver, and you should see it at work. It kicks in automatically, and most of the times it doesn't ask for input.

* Or create a vault conflict to test this. You can create such scenario by editing a vault file from 2 branches. It looks like this:


<details><summary>Show how</summary>
<p>
	
   - Create a branch from your `develop` or `master` <br>
    `git checkout -b aaa`
   - Create a vault file and write 2 lines in it <br>
    `vim secrets.vault` <br>
    write
        ~~~~
        aaa : aaa
        bbb : bbb

   - Encrypt the file using ansible-vault <br>
     `ansible-vault encrypt secrets.vault`
   - Commit the changes <br>
    `git add . &&  git commit -am "1st commit from aaa"`
   - Move to another branch now, branched off of master or develop
    `git checkout -b bbb develop`
   - Repeat the steps from branch aaa, but using a new line ccc<br>
    `vim secrets.vault` <br>
        ~~~~
        bbb : bbb
        ccc : ccc

   - Encrypt the file from bbb <br>
    `ansible-vault encrypt secrets.vault`
   - Commit<br>
    `git add . &&  git commit -am "1st commit on bbb"`<br>
    `git status`
   - Merge aaa into bbb<br>
     `git merge --no-edit aaa`
   - Double check your changes using
        ~~~~
        $ cat secrets.vault 
        $ANSIBLE_VAULT;1.1;AES256
        64313536383536353364626664323935613363663461653461323737616665333263326233656335
        6161636566316139373461653662626135663865303936620a323438633839636432343066333338
        38336439646261643866383039646562656165646462356261383661303539306539306135323933
        3434393265323738380a306633353638643435343665333836633634613139633963643465303338
        65653966323636303838663738393664626134323137646635343839663161303736
    
        $ ansible-vault view secrets.vault 
        bbb : bbb
        ccc : ccc
        aaa : aaa
   - Congrats! 


</p>
</details>
