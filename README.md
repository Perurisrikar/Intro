# CSM-D CR Portal — Full Version

## Architecture
- GitHub Pages: responsive frontend
- Supabase Auth: CR admin email/password login
- Supabase Edge Functions: server-side authentication, question management, ratings
- Postgres: students, hashed private answers, sessions, ratings

## Setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. Run `supabase/seed_students.sql` to import the 64 students.
4. In Supabase Authentication, create the CR admin user with email/password.
5. Copy that user's UUID and run:
   `insert into admin_users(user_id) values ('PASTE-USER-UUID-HERE');`
6. Install Supabase CLI locally and deploy functions:
   `supabase login`
   `supabase link --project-ref YOUR_PROJECT_REF`
   `supabase functions deploy get-question`
   `supabase functions deploy authenticate`
   `supabase functions deploy submit-rating`
   `supabase functions deploy admin-students`
   `supabase functions deploy admin-questions`
   `supabase functions deploy admin-ratings`
7. Replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` in `config.js`.
8. Upload the project files to GitHub and enable GitHub Pages.
9. Open the site, click CR Admin, sign in, and add each student's private questions.

## Security notes
- Never put the Supabase service-role key in GitHub or frontend code.
- Student answers are PBKDF2-SHA256 hashed server-side with a unique salt.
- Student data and ratings are inaccessible directly through the browser database client.
- Authentication sessions expire after 30 minutes and are single-use for rating submission.
- Avoid using sensitive information (Aadhaar, phone numbers, exam credentials, marks, ranks, etc.) as questions.
- The current rate-limit example uses recent attempts per roll; for production, add IP-based edge/WAF rate limiting too.
