import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

// ============================================================
// TEAM ALUM — SUPABASE CONFIGURATION
//
// HOW TO SET UP:
// 1. Go to https://supabase.com and create a free project called "team-alum"
// 2. Go to Project Settings -> API
// 3. Copy your "Project URL" and "anon public" key
// 4. Paste them below
// ============================================================

export const supabase = createClient(
  'YOUR_SUPABASE_PROJECT_URL',
  'YOUR_SUPABASE_ANON_KEY'
);
