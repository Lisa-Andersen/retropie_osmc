# retropie_osmc
I want to be capable of installing Retropie on my OSMC, which runs on an rpi4b.

@mcorbit has made an excellent solution to this issue with https://github.com/mcobit/retrosmc. 
However, after Kodi V19 Matrix this has run into some issues:
https://github.com/mcobit/retrosmc/issues/67

As seen in this thread @ornostar have created some updated script files which ensures that Emulationstation starts up before the watchdog script is run.

However, this appears to only work on rpi 1,2 and 3 - but if I first install using this guide:
https://github.com/danielfreer/raspberrypi5-retropie-setup/blob/main/Install_RetroPie.md
And afterwards add the script files, and uses the excec in the kodi menu it works.
