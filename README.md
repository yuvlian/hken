# hken

patch cn hsr client to en

## tutorial

1. open powershell

2. run `cd path` where path is the path to your folder with StarRail.exe

3. paste this script in powershell and press enter:

```
iex (iwr https://raw.githubusercontent.com/yuvlian/hken/main/main.ps1)
```

if that breaks your game, you can undo the change by running:

```
iex "& { $(iwr https://raw.githubusercontent.com/yuvlian/hken/main/main.ps1) } -u"
```

## old binary

i've deleted the source (main.c) of hken.exe (the one in prebuilt), but you can still find them in older commits.
