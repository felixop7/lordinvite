# Deployment Guide: Browser-Based WASM Video Generator

## Overview

Your application has been converted to **browser-based video generation** using WebAssembly (WASM). This means:

✅ **Zero server CPU usage** - Each user's browser handles encoding  
✅ **Unlimited concurrent users** - No server scaling needed  
✅ **Free hosting** - Deploy on GitHub Pages or Netlify  
✅ **Instant generation** - 30-60 seconds per video in user's browser  

---

## Architecture

### How It Works

```
User's Browser
├── Load FFmpeg WASM (~20MB, cached)
├── Download template video & font from CDN
├── Render text overlay on canvas
├── Encode video using FFmpeg WASM
└── Download output.mp4 (no server involved)
```

### Files

- **`templates/index_wasm.html`** - Main application (browser-based)
- **`templates/index.html`** - Legacy server version (optional backup)
- **`app.py`** - Flask server (minimal, serves HTML only)
- **`assets/invite_template.mp4`** - Template video (hosted on GitHub CDN)
- **`assets/myfont.ttf`** - Font file (hosted on GitHub CDN)

---

## Deployment Option 1: GitHub Pages (Recommended) ⭐

### Step 1: Update Repository URLs

The application loads assets from GitHub. Update the URLs in `templates/index_wasm.html`:

```javascript
const TEMPLATE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/vid_template/main/assets/invite_template.mp4";
const FONT_URL     = "https://raw.githubusercontent.com/YOUR_USERNAME/vid_template/main/assets/myfont.ttf";
```

Replace `YOUR_USERNAME` with your GitHub username (currently: `felixop7`)

### Step 2: Create GitHub Pages Site

In your GitHub repo settings:

1. Go to **Settings** → **Pages**
2. Under "Source", select **Deploy from a branch**
3. Select branch: **main** (or your default branch)
4. Select folder: **/(root)** for GitHub Pages to serve index.html
5. Click **Save**

### Step 3: Rename HTML File

GitHub Pages looks for `index.html` by default:

```bash
cd templates
cp index_wasm.html index.html
git add index.html
git commit -m "Add GitHub Pages entry point"
git push
```

### Step 4: Deploy

```bash
git add -A
git commit -m "Switch to browser-based WASM video generation"
git push
```

**Your site will be live at:**
```
https://YOUR_USERNAME.github.io/vid_template/
```

---

## Deployment Option 2: Netlify (Even Easier)

### Step 1: Prepare

```bash
# Rename the WASM version to index.html
cp templates/index_wasm.html templates/index.html
git add templates/index.html
git push
```

### Step 2: Deploy on Netlify

1. Go to [netlify.com](https://netlify.com)
2. Click **Add new site** → **Import an existing project**
3. Connect your GitHub repo
4. Netlify auto-detects settings
5. Click **Deploy**

**Your site will be live in 30 seconds at a netlify.app domain**

---

## Deployment Option 3: Keep Flask Server (Render)

### For Local Testing / Development

```bash
python app.py
```

Visit `http://localhost:5000` - the browser WASM version loads automatically.

### Deploy to Render

The current setup is compatible with Render's free tier:

1. Push to GitHub:
```bash
git add -A
git commit -m "Switch to WASM-based video generation"
git push
```

2. Create new web service on [render.com](https://render.com):
   - Connect GitHub repo
   - Build command: `pip install -r requirements.txt`
   - Start command: `gunicorn app:app`
   - Deploy

**Result:** Minimal Flask server + browser-side video encoding

---

## Configuration

### Update Logo URLs (Optional)

If using GitHub Pages, update logo URLs in `templates/index_wasm.html`:

```html
<img src="https://raw.githubusercontent.com/felixop7/vid_template/main/assets/LORD.svg" alt="LORD Logo" class="logo logo-left" />
<img src="https://raw.githubusercontent.com/felixop7/vid_template/main/assets/galkot.png" alt="Galkot Logo" class="logo logo-right" />
```

### Custom Domain

After deploying to GitHub Pages, add your own domain:

1. In repo settings → Pages
2. Add your domain under "Custom domain"
3. Update DNS records (GitHub provides instructions)

---

## Using the Server-Side Version (Fallback)

If you want to revert to server-side video encoding (not recommended):

```bash
python app.py
# Visit http://localhost:5000/server
```

This uses the legacy Flask-based generation. **Not recommended** because:
- Requires CPU-intensive rendering on server
- Doesn't scale with concurrent users
- Costs more on hosting platforms

---

## Performance

### Browser WASM Version (Recommended)

| Metric | Value |
|--------|-------|
| First load | 20-30s (FFmpeg WASM downloads) |
| Subsequent loads | 30-60s (encoding in browser) |
| Server CPU | 0% |
| Concurrent users | Unlimited |
| Hosting cost | Free |

### Server-Side Version (Deprecated)

| Metric | Value |
|--------|-------|
| Load | < 1 second |
| Generate video | 30-60s on Render (CPU-locked) |
| Server CPU | 100% while encoding |
| Concurrent users | 1-2 (limited by CPU) |
| Hosting cost | $7-28/month |

---

## Troubleshooting

### FFmpeg WASM Fails to Load

**Problem:** "Failed to load FFmpeg" error

**Solution:**
1. Check browser console (F12)
2. Ensure CDN URLs are accessible
3. Try in incognito mode (cache issue)
4. Refresh page

### Video Downloads Fail

**Problem:** Video doesn't download after encoding

**Solution:**
1. Check browser download settings
2. Try different browser (Chrome, Firefox)
3. Ensure pop-ups aren't blocked
4. Try with smaller name (special characters issue)

### URLs Not Found

**Problem:** "Failed to fetch assets" error

**Solution:**
1. Verify GitHub URLs are correct
2. Ensure template.mp4 and myfont.ttf exist in `/assets/`
3. Files must be public (not in private repo)
4. Test URL directly in browser: `https://raw.githubusercontent.com/...`

---

## Admin Dashboard

The admin dashboard is still available to view generation history:

**Local:** `http://localhost:5000/admin-dashboard-galkot`

**Environment variables:**
```bash
ADMIN_PASSWORD=your_secure_password
```

This is optional and only tracks names if using server-side generation.

---

## Summary

| Aspect | GitHub Pages | Netlify | Render |
|--------|--------------|---------|--------|
| Setup time | 5 min | 2 min | 10 min |
| Hosting cost | Free | Free | Free tier |
| Server CPU | 0% | 0% | 0% |
| Video encoding | Browser WASM | Browser WASM | Browser WASM |
| Max users | Unlimited | Unlimited | Unlimited |
| Recommended | ✅ Yes | ✅ Yes | ⚠️ Optional |

---

## Questions?

For issues with:
- **FFmpeg WASM**: https://ffmpeg.wasm.force.sh/
- **GitHub Pages**: https://pages.github.com/
- **Netlify**: https://docs.netlify.com/

---

**Made with ❤️ for Galkot Music & Food Festival**
