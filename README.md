<<<<<<< HEAD
install Xcode from app store

2. modify mac name
System preferences > Sharing

Mute alert sound
System preferences > Sounds > Sounds effect > Mute

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ cd ${HOME}
$ git clone https://github.com/michiomochi/dotfiles
$ cd dotfiles
$ git submodule init
$ git submodule update
```

=======
1. Install Xcode from app store

2. Install command line tool

```
$ xcode-select --install
$ sudo xcodebuild --license
```

3. Modify mac name

System preferences > Sharing

4. Mute alert sound

System preferences > Sounds > Sounds effect > Mute


5. Install Homebrew

```
$ export HOMEBREW_DEVELOPER=true
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

6. Install and enable apple-gcc42 for el capitan

```
$ brew tap homebrew/dupes
$ brew install apple-gcc42
$ export CC=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/gcc-4.2
$ export CXX=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/g++-4.2
$ export CPP=/usr/local/Cellar/apple-gcc42/4.2.1-5666.3/bin/cpp-4.2
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
>>>>>>> 957dbbb72609a18a4377f1955d888aa01eb065a5
