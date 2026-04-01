# Galkot Music & Food Festival - Invite Video Generator

**Browser-Based Video Generator using WebAssembly** 🎬

## What This Does

Generate personalized 28-second video invites for festival attendees using their own browser. No server CPU needed!

```
User enters name → FFmpeg encodes in their browser → Video downloads
```

---

## Key Features

✅ **Browser-Based Encoding** - Uses ffmpeg.wasm (no server CPU)  
✅ **Unlimited Concurrent Users** - Everyone can generate simultaneously  
✅ **30-60 Second Generation** - On user's computer  
✅ **Free Hosting** - Deploy on GitHub Pages or Netlify  
✅ **High Quality** - Matches original template (3500k bitrate)  
✅ **Beautiful UI** - Luxury gold/dark theme with animations  

---

## Quick Start

### Local Testing (30 seconds)

```bash
# 1. Install
pip install -r requirements.txt

# 2. Run
python app.py

# 3. Open browser
http://localhost:5000

# 4. Enter name and generate
# Video encodes in your browser, downloads automatically!
```

### Deploy to GitHub Pages (5 minutes)

```bash
# 1. Update your username in index_wasm.html (line ~348)
# 2. Create entry point
cp templates/index_wasm.html templates/index.html

# 3. Push and enable Pages
git add -A
git commit -m "Deploy WASM video generator"
git push

# 4. Enable Pages in repo settings → your site is live!
```

**Result:** Your app is live on GitHub Pages with ZERO hosting cost and unlimited users!

---

## Architecture

### Modern (Current) ⭐

```
┌─────────────────────────────────────────┐
│  User's Browser                         │
│  ┌─────────────────────────────────┐   │
│  │ Download Template Video (3.1MB) │   │
│  │ Load FFmpeg WASM (20MB, cached) │   │
│  │ Render Text Overlay (Canvas)    │   │
│  │ Encode Video (30-60 sec)        │   │
│  │ Download output.mp4             │   │
│  └─────────────────────────────────┘   │
│  User's CPU: 100%                      │
└─────────────────────────────────────────┘
         ↓
   GitHub Pages / Netlify / Render
   (Serves HTML only, CPU: 0%)
```

### Legacy (Old) 🚫

```
┌─────────────────────────────────────────┐
│  User's Browser                         │
│  ┌──────────────────────────────────┐  │
│  │ Send name to Flask server        │  │
│  └──────────────────────────────────┘  │
│              ↓                          │
│  ┌──────────────────────────────────┐  │
│  │ Flask Server (CPU: 100%)         │  │
│  │ - Load template video            │  │
│  │ - Render text overlay (PIL)      │  │
│  │ - Encode video (ffmpeg)          │  │
│  │ - Return MP4                     │  │
│  └──────────────────────────────────┘  │
│              ↓                          │
│  │ Download video                   │  │
└─────────────────────────────────────────┘
Server Cost: $$$ (Render free tier: 100% CPU-bound)
Max Users: 1-2 simultaneously per server
```

---

## Technology Stack

- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Video Encoding:** FFmpeg WASM (runs in browser)
- **Text Rendering:** Canvas API
- **Hosting:** GitHub Pages / Netlify (free)
- **Optional Backend:** Flask (serves HTML only)

---

## File Structure

```
vid_template/
├── templates/
│   ├── index_wasm.html       ← YOUR MAIN APP (browser-based WASM)
│   ├── index.html            ← Legacy server version (backup)
│   └── admin.html            ← Admin dashboard (optional)
├── assets/
│   ├── invite_template.mp4   ← Template video
│   ├── myfont.ttf            ← Font file
│   ├── LORD.svg              ← Logo 1
│   └── galkot.png            ← Logo 2
├── static/
│   ├── LORD.svg              ← Copy for Flask
│   └── galkot.png            ← Copy for Flask
├── app.py                    ← Flask app
├── requirements.txt          ← Dependencies
├── QUICKSTART.md             ← Quick deployment guide
└── DEPLOYMENT.md             ← Detailed deployment guide
```

---

## Configuration

### Change Template Video

1. Replace `assets/invite_template.mp4`
2. Update the duration info in spinner text
3. Adjust `NAME_Y` in `app.py` if needed

### Change Font

1. Replace `assets/myfont.ttf`
2. Update `NAME_FONTSIZE` in `app.py` if text is too large/small

### Change Text Position

Edit `app.py`:
```python
NAME_Y        = 1462   # Vertical position (0=top, 1920=bottom)
NAME_X        = 540    # Horizontal (usually centered at 540 for 1080px width)
NAME_FONTSIZE = 85     # Font size
```

---

## Performance Metrics

| Metric | Browser WASM | Server-Side |
|--------|--------------|-------------|
| **First load** | 20-30s (FFmpeg cached) | < 1s |
| **Video generation** | 30-60s (user's CPU) | ~60s (server) |
| **Concurrent users** | Unlimited | 1-2 |
| **Server CPU** | 0% | 100% |
| **Monthly cost** | $0 | $7-$25 |
| **Scalability** | ∞ | Limited |

---

## Deployment Options

### 1. GitHub Pages (Recommended) ⭐

**Pros:** Free, fast CDN, automatic HTTPS  
**Cons:** Static only (perfect for this app)  
**Cost:** $0  
**Setup:** 5 minutes

→ See `QUICKSTART.md`

### 2. Netlify

**Pros:** Drag & drop, fast, free tier generous  
**Cons:** Optional paid tier available  
**Cost:** $0 (free tier)  
**Setup:** 2 minutes

1. Go to netlify.com
2. Connect GitHub repo
3. Deploy!

### 3. Render (Current Setup)

**Pros:** Can run optional Flask backend, admin dashboard  
**Cons:** Minimal cost, limited free tier  
**Cost:** $0 (free tier, but limited credits)  
**Setup:** 10 minutes

```bash
git push
# Render auto-deploys
# Visit your-app.onrender.com
```

---

## Admin Dashboard (Optional)

Track who generated videos:

**Local:** `http://localhost:5000/admin-dashboard-galkot`  
**Password:** Set `ADMIN_PASSWORD` env var  

Note: Only works with server-side generation. Browser WASM doesn't log.

---

## Troubleshooting

### Video doesn't download

- Check browser download settings
- Try incognito mode
- Check browser console (F12 → Console) for errors
- Try another browser

### FFmpeg fails to load

- Ensure CDN is accessible (`https://cdn.jsdelivr.net`)
- Try hard refresh (Ctrl+Shift+R)
- Check browser console for error messages
- May take 20-30s on first load

### Assets not found

- Verify GitHub URLs contain your username
- Ensure files are in `/assets/` folder
- Files must be in public repo (check repo settings)

### Text looks blurry

- Canvas uses system fonts, not embedded fonts
- This is expected for browser WASM version
- Text positioning may vary slightly

---

## How FFmpeg WASM Works

1. **First visit:** Browser downloads FFmpeg WASM (~20MB)
2. **Storage:** Browser caches it (no re-download)
3. **Rendering:** Canvas creates text overlay PNG
4. **Encoding:** FFmpeg WASM encodes video in browser
5. **Download:** Video saves to user's downloads folder

**Power:** All on user's computer - zero server CPU!

---

## FAQ

**Q: Will this work on mobile?**  
A: Yes! Browser WASM works on iOS Safari, Android Chrome, etc.

**Q: How big is the download for first-time users?**  
A: ~20MB for FFmpeg WASM (cached forever after)

**Q: Can multiple users generate simultaneously?**  
A: Yes! Each uses their own device CPU.

**Q: What if the user closes their tab?**  
A: Encoding stops. They can start again. No server waste.

**Q: Can I customize the video template?**  
A: Yes! Replace `assets/invite_template.mp4` and adjust `NAME_Y` and `NAME_FONTSIZE`.

**Q: How do I track generations?**  
A: Server version has admin dashboard. Browser WASM doesn't track (no server connection).

---

## Learning Resources

- **FFmpeg WASM:** https://ffmpeg.wasm.force.sh/
- **Canvas API:** https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API
- **GitHub Pages:** https://pages.github.com/
- **WebAssembly:** https://webassembly.org/

---

## Next Steps

1. **Test locally:** `python app.py` → `http://localhost:5000`
2. **Update URLs:** Change `felixop7` to your GitHub username in `index_wasm.html`
3. **Deploy:** Push to GitHub → Enable Pages
4. **Share:** Your URL is live! 🚀

---

## Support

- 📖 See `QUICKSTART.md` for deployment
- 📖 See `DEPLOYMENT.md` for detailed options
- 🐛 Check browser console (F12) for errors
- 💅 Customize colors in CSS section of `index_wasm.html`

---

## License

This project is open source. Feel free to modify and deploy!

---

**Made with ❤️ for Galkot Music & Food Festival**

Generated personalized videos have **zero server cost** and **unlimited scaling**. Perfect! 🎉
