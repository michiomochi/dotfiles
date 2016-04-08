1. Install Xcode from app store

2. Install command line tool
https://developer.apple.com/downloads/

4. Sign to xcode license

```
$ sudo xcodebuild -license
```

5. Modify mac name

System preferences > Sharing

5. Mute alert sound

System preferences > Sounds > Sounds effect > Mute


6. Install Homebrew

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

7. Prepare dotfiles

```
$ cd ${HOME}
$ git clone git@github.com:michiomochi/dotfiles.git
$ cd dotfiles
$ git submodule init
$ git submodule update
$ ./setup.sh
$ ./package_setup.sh
```
