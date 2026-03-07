# 🎌 ani-stream

> A fast, lightweight anime streaming CLI — like `ani-cli`, but self-contained.
> Works on **Linux**, **macOS**, **Android (Termux)**, and with the **MPV Android** app.

```
 ░█████╗░███╗░░██╗██╗░░░░░░░░░░██████╗████████╗██████╗░███████╗░█████╗░███╗░░░███╗
 ██╔══██╗████╗░██║██║░░░░░░░░░██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗████╗░████║
 ███████║██╔██╗██║██║░░░░░░░░░╚█████╗░░░░██║░░░██████╔╝█████╗░░███████║██╔████╔██║
 ██╔══██║██║╚████║██║░░░░░░░░░░╚═══██╗░░░██║░░░██╔══██╗██╔══╝░░██╔══██║██║╚██╔╝██║
 ██║░░██║██║░╚███║██║░░░░░░░░░██████╔╝░░░██║░░░██║░░██║███████╗██║░░██║██║░╚═╝░██║
 ╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░░░░░░░╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝
```

---

## Features

- 🔍 **Search anime** by name with a fuzzy-finder menu (fzf)
- 📺 **Stream directly** in mpv, vlc, or iina
- 📱 **Android support** — Termux CLI or open in full MPV Android app
- ⬇️ **Download mode** — save episodes locally
- 📜 **Watch history** — resume where you left off
- 🎚️ **Quality selection** — 360p to 1080p
- 🎭 **Sub/Dub toggle**
- ⚙️ **Persistent config** — saved preferences

---

## Installation

### One-liner (all platforms)

```bash
curl -fsSL https://raw.githubusercontent.com/aliabdoxd27-source/ani-stream/main/install.sh | bash
```

### Manual install

```bash
git clone https://github.com/aliabdoxd27-source/ani-stream
cd ani-stream
chmod +x ani-stream install.sh
./install.sh
```

---

## Platform-specific Setup

### 🐧 Linux (Debian/Ubuntu)

```bash
sudo apt install mpv fzf curl python3 python3-pip
pip3 install yt-dlp
```

### 🐧 Linux (Arch)

```bash
sudo pacman -S mpv fzf curl python yt-dlp
```

### 🍎 macOS

```bash
brew install mpv fzf yt-dlp curl
```

### 📱 Android (Termux)

```bash
# 1. Install Termux from F-Droid (NOT Play Store)
#    https://f-droid.org/packages/com.termux/

# 2. Inside Termux:
pkg update && pkg upgrade
pkg install mpv fzf curl python
pip install yt-dlp

# 3. Install ani-stream
curl -fsSL https://raw.githubusercontent.com/aliabdoxd27-source/ani-stream/main/install.sh | bash
```

### 📱 Android — MPV Android App (Full-screen, HW decode)

For the best Android experience, install the **MPV Android** app alongside Termux:

1. Download from [F-Droid](https://f-droid.org) or [GitHub Releases](https://github.com/mpv-android/mpv-android/releases)
2. Run `ani-stream` in Termux
3. Go to **Settings → Use MPV Android app (intent)**
4. Episodes will now open in the full MPV Android app with:
   - Hardware decoding (hevc, AV1, etc.)
   - Gesture controls
   - Picture-in-Picture
   - Background playback

---

## Usage

```
ani-stream [OPTIONS] [QUERY]

OPTIONS:
  -s, --search QUERY    Search for anime
  -e, --episode NUM     Start at episode number
  -d, --download        Download instead of stream
  -q, --quality QUAL    Set quality (best/1080p/720p/480p/360p)
  --dub                 Use dub if available
  --install             Show install guide
  --history             Show watch history
  --settings            Open settings menu
  -h, --help            Show this help
  -v, --version         Show version
```

### Examples

```bash
# Interactive mode (recommended)
ani-stream

# Search directly
ani-stream "One Piece"

# Jump to a specific episode
ani-stream -s "Attack on Titan" -e 25

# Download episode at 720p
ani-stream -d -q 720p "Naruto Shippuden"

# Dub mode
ani-stream --dub "My Hero Academia"
```

---

## Interactive Navigation

When an episode finishes, you get a navigation prompt:

```
── Episode Navigation ──────────────────────────────
  n - Next episode (Ep 24)
  p - Previous episode (Ep 22)
  r - Replay current episode (Ep 23)
  s - Select episode
  q - Quit to main menu

Action: _
```

You can also type an episode number directly (e.g., `42`).

---

## Configuration

Config is saved at `~/.config/ani-stream/config`:

```bash
PLAYER="mpv"
QUALITY="best"
DUB_MODE=false
AUTO_NEXT=true
MPV_ARGS="--sub-scale=0.8 --volume=80"
```

---

## Dependencies

| Tool     | Required | Purpose               |
|----------|----------|-----------------------|
| `curl`   | ✅ Yes   | HTTP requests         |
| `mpv`    | Recommended | Video playback   |
| `fzf`    | Optional | Fuzzy menu selection  |
| `yt-dlp` | Recommended | Stream extraction |
| `python3`| Optional | URL encoding          |
| `vlc`    | Alt      | Fallback player       |
| `iina`   | macOS alt| macOS fallback player |

---

## Troubleshooting

**No stream URL found**
- Install `yt-dlp`: `pip install yt-dlp`
- The scraping source may be blocked — try a VPN

**mpv not found on Android**
- Run: `pkg install mpv`
- Or use MPV Android app with intent mode

**fzf menu not showing**
- Install fzf: `pkg install fzf` (Termux) / `brew install fzf` / `apt install fzf`
- Falls back to numbered list automatically

**Video stutters on Android**
- Go to Settings in ani-stream
- Ensure `--hwdec=mediacodec` is in MPV args
- Or use MPV Android intent mode for better hardware decode

---

## Sources

ani-stream scrapes anime from **Gogoanime/Anitaku** mirrors, similar to how ani-cli works. These are the same sources used by millions of anime viewers.

> **Note:** ani-stream is for personal use only. Support the creators by watching on official platforms like Crunchyroll, Funimation, or Netflix when possible.

---

## License

MIT — do whatever you want with it.
