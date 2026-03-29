# Skele Gamer Qt6

Personal SDDM theme repo for `skele-gamer-qt6`.

This theme is a neon cyber / skeleton gamer style SDDM login theme with:
- Qt6-based theme metadata
- looping video background
- neon pink and purple UI accents
- custom font bundled in the theme

![Skele Gamer Qt6](./screenshot.png)

## Repository Layout

[`skele-gamer-qt6`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6)

Contains the actual SDDM theme:
- [`Main.qml`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/Main.qml)
- [`BackgroundVideo.qml`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/BackgroundVideo.qml)
- [`theme.conf`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/theme.conf)
- [`metadata.desktop`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/metadata.desktop)
- [`bg.mp4`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/bg.mp4)
- [`preview.png`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/preview.png)

## Dependencies

Required:
- `sddm`
- `qt6-wayland`
- `xcb-util-cursor`

Recommended:
- `ffmpeg`

Notes:
- This theme is marked with `QtVersion=6` and is intended for the Qt6 greeter path.
- If your distro ships an SDDM Wayland override that is unstable on your machine, forcing SDDM back to X11 may be more reliable.

## Install

Copy the theme into SDDM's theme directory:

```bash
sudo rm -rf /usr/share/sddm/themes/skele-gamer-qt6
sudo cp -r ./skele-gamer-qt6 /usr/share/sddm/themes/
```

Set it as the active theme:

```bash
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=skele-gamer-qt6\n' | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
```

Restart SDDM:

```bash
sudo systemctl restart sddm
```

## Optional: Force X11 For SDDM

If your machine has problems with the vendor Wayland greeter config, add:

```bash
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/10-displayserver.conf >/dev/null <<'EOF'
[General]
DisplayServer=x11
GreeterEnvironment=
EOF
```

Then restart SDDM:

```bash
sudo systemctl restart sddm
```

## Edit Workflow

Edit the source theme in this repo:

[`skele-gamer-qt6`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6)

Then copy it over the installed theme:

```bash
sudo rm -rf /usr/share/sddm/themes/skele-gamer-qt6
sudo cp -r ./skele-gamer-qt6 /usr/share/sddm/themes/
```

## Video Background Tips

Create a more vivid neon 1080p version:

```bash
ffmpeg -i ./skele-gamer-qt6/bg.mp4 \
  -vf "scale=1920:1080:flags=lanczos,eq=saturation=1.38:contrast=1.12:brightness=0.015:gamma=1.03,unsharp=5:5:1.1:3:3:0.5" \
  -c:v libx264 -crf 16 -preset slow -pix_fmt yuv420p \
  -c:a copy \
  ./skele-gamer-qt6/bg-neon-1080p.mp4
```

Regenerate the preview image from the current video:

```bash
ffmpeg -y -i ./skele-gamer-qt6/bg.mp4 -frames:v 1 ./skele-gamer-qt6/preview.png
```

## Troubleshooting

If the screen goes black:
- switch to a TTY with `Ctrl+Alt+F2`
- log in
- switch back to Breeze:

```bash
printf '[Theme]\nCurrent=breeze\n' | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
sudo systemctl restart sddm
```

If the theme does not render with the Qt6 greeter:
- verify [`metadata.desktop`](/home/rabbit/Documents/sddm-themes/skele-gamer-qt6/metadata.desktop) contains `QtVersion=6`

## License

MIT. See [`LICENSE`](/home/rabbit/Documents/sddm-themes/LICENSE).
