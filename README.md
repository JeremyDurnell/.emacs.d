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
