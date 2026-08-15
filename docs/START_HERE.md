## Why NixOs?
Next question.

## How to install NixOs
You're going to need:
- A usb with at least 10ish gigs that can plug into your device
- Internet connection

### 1. Download the NixOs ISO
An [ISO file](https://en.wikipedia.org/wiki/Optical_disc_image) is a type of installer for operating systems. Unlike most installers, you can't just "run" an ISO file, you have to "boot" from some physical media(USB, CD, hard disk, etc). 

### 2. Flash the ISO on to the USB
If we just drag the ISO file to the USB, we still won't be able to boot the operating system. Thats because USBs(and other physical media) need to be formatted a specific way to make them bootable. The process of making a USB bootable with an ISO is called flashing.

There are a couple apps we can use to flash an ISO to a USB, but I suggest Ventoy.

### 3. Boot from the USB

The NixOs ISO has a [live boot](https://en.wikipedia.org/wiki/Live_USB), which means you get to try out NixOs on the USB before deciding whether you want to install it on your pc or not.
The NixOs ISO comes with two desktop environments for you to try:
- KDE Plasma, which is more Windows-like
- GNOME, which is more MacOS-like

I suggest you try both before deciding which to install.

## How to add packages

There are two main ways you can add packages as a beginner:
- temporarily via nix-shell
- persistently via environment.systemPackages

Two other ways you can use once you're more comfortable with nix:
- flakes
- home-manager

### Via nix-shell
The easiest way to install something is via the shell. Open a terminal and type:
```sh
nix-shell -p cowsay
```
Now cowsay is installed in your terminal! If you type ``cowsay hi`` into your terminal, you should see the following:
```
 ____
< hi >
 ----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

An important note here: with this method, cowsay is only installed in your **current terminal**, to install packages system wide, we'll need a different method.

## Via environment packages



```
sudo nixos-rebuild switch --flake .
```

## How to search for packages

## Whats a flake?

## Whats home manager?

## Whats nix helper?



