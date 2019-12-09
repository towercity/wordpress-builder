# Wordpress Autobuild Script

__a fantastic program that builds simple wordpress sites all on its own__

---

This is still _technically_ a work in progress, but it's a completely
functional work in progress. It just needs to be cleaned up a little, 
and it could have a few more quality of life features, but it __will__
save you time.

But just what _does_ it do?

1. Create a digital ocean droplet for your project 
2. Install Wordpress on a LAMP stack on this new droplet
    - Maybe you've come in here with your advance knowledge of the digital
    ocean platform. That's great! I'm glad to have you. Maybe you've
    heard of Digital Ocean's (frankly wonderful) __One Click Wordpress
    Droplet__, and you're wondering now... _Why not use Digital Ocean's
    (frankly wonderful) __One Click Wordpress Droplet__?_. Well, this
    build script was developed without complete domain names in mind (to
    make it easy to redeploy sites to virtual hosts, for example, or for
    clinets who don't want their work-in-progress site associated with
    thier domain name yet) and Digital Ocean's
    (frankly wonderful) __One Click Wordpress Droplet__ is set up to only work with a bespoke 
    domain name. This one decision on Digital Ocean's part led to all sorts of problems.  Let me explain them here: 

    - every time you ssh'd into a server _without_
    a domain name attached to your droplet, unless you enter a series
    of exit commands in the _exact_ right way, you risk moving the root
    of the site--yes, _technically_ recoverable, but a huge bummer and
    terrible waste of time

3. Upload a basic standardarized theme and dummy content to get you started on the site 

4. Connect your local project to the remote theme via sftp, if you're using visual studio code, that is. Why visual studio
code? Because it's what _I_ know. In future, this can be easily adapted for any IDE of your choice, even vim if you're like that.

In other words: __Wow!__ _That does a lot!_

<!-- vscode-markdown-toc -->
* [Installation](#Installation)
	* [Dependencies](#Dependencies)
* [Running](#Running)
* [Bugs, etc, and how to](#Bugsetcandhowto)
* [To-Do](#To-Do)
* [All the cli calls, in order](#Alltheclicallsinorder)

<!-- vscode-markdown-toc-config
	numbering=false
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## <a name='Installation'></a>Installation

This part's easy:

1. Make sure you don't have an installation of the build script
in your working directory. If you do, there'll be a folder named
`wordpress-builder` . You can just go ahead and delete that
now. It'll cause errors.

### <a name='Dependencies'></a>Dependencies

This script is build for NIX-style OS's (it _is_ a bash script after all), so it assumes you have some standard NIX/POSIX/whatever type cli utilities installed. Beyond those, however, the script makes use of the following:

* `jq` 
* `npm` and `node`

## <a name='Running'></a>Running

1. Install it (see above) 
2. Run `/bin/bash wp-build -d “Project Name”` → the so-called __make-droplet__ command
    1. This will create the droplet in digital ocean. At the moment,
    it makes a Ubuntu 18.04 LTS Ubuntu server, but this image can be
    changed in `functions/make-droplet.sh` . The variable’s name is `droplet_image` , and its on line `7` .
        * Finding the list of avaialable images can be... a bit	unneccessarily difficult, in my opinion. I've been finding them by using `curl` to pull the info from the digital ocean API then piping in thru a few bash programs like so: 
        *`curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer	$DO_TOKEN" "https://api.digitalocean.com/v2/images?page=1&per_page=100&type=distribution" | jq . | grep -A 5 'Ubuntu'`
        * Note also that this above'll find
        you the Ubuntu distros available on Digital Ocean. If you're
        one of _those_ types (ie, developers who feel more comfortable
        with other linux distributions), just change `Ubuntu` to your
        distro of choice. `-A 5` prints out 5 lines of context after
        any use of the term `Ubuntu` , which is usually enough to find
        the Digital Ocean API image name 
        * __Big Note Here:__ You can't
        have special characters in your project name. The script errors
        out on them. In the future, we could update this to include them,
        but for now, drop any &s, \s, or %s, etc.

    2. The script will also copy over your local ssh key to the droplet
    to make the rest of the setup mecha-easier

        * If you _don't_ have an ssh key set up on your machine, the script won't fail -- in fact it will _create_ an ssh key
        _for_ you! _How convenient!_ 
        * Note that this part is _very_
        untested. I've only used this script on my machine, so I haven't
        had the best chance to debug things.

    3. Once done, the script’ll prompt you to wait for the digital ocean
    droplet to build. Do this. You can run `/bin/bash wp-build -c` 
    to check if it's ready 
    4. It's worth noting that the next command
    _will_ check if the droplet has an IP before it runs though, so it's
    not unsafe to skip checking

3. Once the droplet's finished, run `/bin/bash wp-build -i` → the so-called __init wordpress site__ command
    1. This command will ssh into your brand new digital ocean droplet and
    install WordPress onto a LAMP stack.  
    2. It's gonna take a while.
    3. After WP is installed, the
    script will create a standard crinkle-cut `it` user. It'll
    prompt for a password then. 
    4. The script will now print
    out a handy link to the ip so you can finish the wordpress install
    in the browser.

4. Now visit the IP address to install wordpress in the frontend → let's call this __web install__
    - (note to self but you can read it too: research if the wp-cli can
    do this part automatically) 
    1. As stated above, the script’ll even
    give you a link in the terminal to get there more quickly 
    2. This is a good opportunity
    to remove the site tagline wordpress automatically generates: it gives you an excuse to glance
    over the settings page for any unexpected errors

5. Run `/bin/bash wp-build -b` → the so-called __build__ command
or __the part that does all the work__

    1. The theme builder will ask for the client's email address and phone
    number, as well as the `it` user's password. Fill these parts
    out.  
    2. A lot of copying over/installations will happen here. Where `-i` built the LAMP stack and installed wordpress on top of it, `-b` creates the WordPress theme and fills the site with dummy content
    3. A prompt will come up asking you if you want to delete script files. Say `y` . It's just easier

6. The script will then change your directory name for you. You might
have to reposition yourself on the commandline manually to get back to
the directory you want 
7. Go to the WP dashboard and do your standard
set up procedures:
    1. Activate the theme 
    2. Change the homepage to the static homepage
    3. Add a header menu to the theme

----

## <a name='Bugsetcandhowto'></a>Bugs, etc, and how to address them

1. Sometimes a call to `/bin/bash wp-build -i` will fail even if the
IP address is set. If it ever fails on you (it'll return with some error
akin to connection refused), just run the command again. 10 times out
of 10, the script will then work 

## <a name='To-Do'></a>To-Do

1. Research if `wp-cli` can automate these browser install options:
    * wp browser set up 
    * Activate the theme 
    * Change the homepage to the static homepage 
    * Add a header menu to the theme

2. Make the plugins/certain pages and post types optional, requested by
the templating enginge
    - with, of course, a 'select all' flag
3. Auto remove (or replace the content of) the reademe.md 
4. Create
symbolic links in both the `it` and `root` home directories to
the site root. Go ahead and call it the project name variable.	
5. Make
the longnames start with two hyphens ( `--` ) to better match regular bash
syntax 
6. Write out the rest of the help file ( `functions/help.sh` )
7. Multicommands? Silent invoking?  

---
