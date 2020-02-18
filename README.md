# Jeremy Durnell's: `~/.emacs.d`

Borrowed heavily from: https://gist.github.com/amirrajan/6371290a721220c6b553f18b8c77b715
<br />
The one cool thing I figured out is that the packages will auto-install:
```
cd ~/.emacs
rm -rf elpa
emacs
```

This is because we call `package-refresh-contents` automatically if `package-initialize` fails.
<br />
https://github.com/JeremyDurnell/.emacs.d/blob/5db4029f19bafe8ee08ba6df6e8b40361f5fe5df/init.el#L17

### Mac
Install karabiner: `brew cask install karabiner-elements`
<br />
Copy karabiner.json (in this repo) AND remove comment at top of file

#### iTerm2
Swap Left Command and Control key under _Preferences -> Keys -> Remap Modifiers_
<br />
__NOTE:__ This will have some side effects (i.e. CTRL+C becomes CMD+C, CMD+K becomes CTRL+K)
