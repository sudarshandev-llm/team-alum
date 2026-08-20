# Team Alum — Setup & Deployment Guide

## QUICK START (5 minutes)

### Step 1: Create Supabase Project
1. Go to https://supabase.com → Sign in → Create a new project
2. Project name: `team-alum`
3. Set a database password (save it)
4. Choose the region closest to your users
5. Wait for the project to be created (~30 seconds)

### Step 2: Get Your Keys
1. In your Supabase dashboard → Project Settings → API
2. Copy **Project URL** (looks like: `https://xxxxxxxx.supabase.co`)
3. Copy **anon public** key (looks like: `eyJhbG...`)

### Step 3: Paste Keys Into Your Code
Open `supabase-config.js` and replace:
```js
export const supabase = createClient(
  'YOUR_SUPABASE_PROJECT_URL',   // ← paste Project URL here
  'YOUR_SUPABASE_ANON_KEY'        // ← paste anon key here
);
```

### Step 4: Create the Database Table
1. In Supabase dashboard → SQL Editor
2. Paste and run this SQL:

```sql
create table questions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  question text not null,
  created_at timestamptz default now(),
  answered boolean default false
);

alter table questions enable row level security;

create policy "Anyone can insert a question"
on questions for insert
to anon
with check (true);

create policy "Only admin can read questions"
on questions for select
to authenticated
using (auth.jwt() ->> 'email' = 'socialsudarshan8@gmail.com');

create policy "Only admin can update questions"
on questions for update
to authenticated
using (auth.jwt() ->> 'email' = 'socialsudarshan8@gmail.com');
```

### Step 5: Enable Google OAuth (for admin login)
1. Go to https://console.cloud.google.com
2. Create a new project (or use existing) → name it anything (e.g. "team-alum-auth")
3. Go to APIs & Services → Credentials → Create Credentials → OAuth client ID
4. Application type: **Web application**
5. Name: "Team Alum Admin"
6. Under **Authorized redirect URIs**, paste:
   ```
   https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback
   ```
   (Replace YOUR_PROJECT_REF with your Supabase project reference from the URL)
7. Click Create → Copy the **Client ID** and **Client Secret**
8. Go back to Supabase dashboard → Authentication → Providers → Google
9. Enable Google → Paste the Client ID and Client Secret → Save
10. Go to Authentication → URL Configuration:
    - Site URL: `https://your-deployed-domain.com` (or `http://localhost:3000` for testing)
    - Redirect URLs: add `https://your-deployed-domain.com/admin.html`

---

## DEPLOYMENT

### Option A: Vercel (Recommended — Free)
1. Push your code to GitHub:
   ```bash
   cd team-alum
   git init
   git add .
   git commit -m "Team Alum website"
   git remote add origin https://github.com/YOUR_USERNAME/team-alum.git
   git push -u origin main
   ```
2. Go to https://vercel.com → Sign in with GitHub
3. Import your `team-alum` repository
4. Click Deploy — done!
5. Your site is live at `https://team-alum.vercel.app`

### Option B: Netlify (Free)
1. Push to GitHub (same as above)
2. Go to https://app.netlify.com → Add new site → Import from Git
3. Select your repository → Deploy
4. Your site is live at `https://team-alum.netlify.app`

### Option C: GitHub Pages (Free)
1. Push to GitHub
2. Go to repo Settings → Pages → Source: Deploy from branch `main`
3. Your site is live at `https://YOUR_USERNAME.github.io/team-alum/`

---

## AFTER DEPLOYMENT

### Update Supabase Auth URLs
1. Go to Supabase → Authentication → URL Configuration
2. Set **Site URL** to your deployed domain
3. Add your domain to **Redirect URLs**: `https://your-domain.com/admin.html`

### Test the Admin Dashboard
1. Visit `https://your-domain.com/admin.html`
2. Click "Sign in with Google"
3. Sign in with `socialsudarshan8@gmail.com`
4. You should see the questions dashboard

### Test the Ask Us Form
1. Visit your main site → Ask Us page
2. Submit a test question
3. Go to admin.html → the question should appear

---

## FILE STRUCTURE
```
team-alum/
├── index.html          # Main site (6 pages)
├── style.css           # All styles
├── script.js           # Page transitions, forms, animations
├── admin.html          # Admin dashboard (private)
├── supabase-config.js  # Supabase credentials (EDIT THIS)
├── vercel.json         # Vercel deployment config
├── _redirects          # Netlify deployment config
└── SETUP.md            # This file
```

## LOCAL TESTING
To test locally, you need a simple HTTP server (ES modules require it):
```bash
# Option 1: Python
python -m http.server 3000

# Option 2: Node.js
npx serve .

# Option 3: PHP
php -S localhost:3000
```
Then open `http://localhost:3000`
