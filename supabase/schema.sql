create extension if not exists pgcrypto;
create table if not exists students(id uuid primary key default gen_random_uuid(), roll text unique not null, name text not null, section text, branch text, active boolean default true, created_at timestamptz default now());
create table if not exists student_questions(id uuid primary key default gen_random_uuid(), student_id uuid references students(id) on delete cascade not null, question_text text not null, answer_salt text not null, answer_hash text not null, active boolean default true, created_at timestamptz default now());
create table if not exists sessions(id uuid primary key default gen_random_uuid(), student_id uuid references students(id) on delete cascade not null, expires_at timestamptz not null default now()+interval '30 minutes', used boolean default false, created_at timestamptz default now());
create table if not exists ratings(id uuid primary key default gen_random_uuid(), student_id uuid references students(id) on delete cascade not null, session_id uuid unique references sessions(id) on delete cascade not null, rating int not null check(rating between 1 and 5), feedback text, created_at timestamptz default now());
create table if not exists auth_attempts(id bigint generated always as identity primary key, roll text, ip_hash text, created_at timestamptz default now());
create table if not exists admin_users(user_id uuid primary key references auth.users(id) on delete cascade, created_at timestamptz default now());
create index if not exists idx_questions_student on student_questions(student_id) where active=true;
create index if not exists idx_sessions_expiry on sessions(expires_at);
create index if not exists idx_attempts_created on auth_attempts(created_at);

alter table students enable row level security; alter table student_questions enable row level security; alter table sessions enable row level security; alter table ratings enable row level security; alter table auth_attempts enable row level security; alter table admin_users enable row level security;

create policy "no client access students" on students for all to anon, authenticated using(false) with check(false);
create policy "no client access questions" on student_questions for all to anon, authenticated using(false) with check(false);
create policy "no client access sessions" on sessions for all to anon, authenticated using(false) with check(false);
create policy "no client access ratings" on ratings for all to anon, authenticated using(false) with check(false);
create policy "no client access attempts" on auth_attempts for all to anon, authenticated using(false) with check(false);
create policy "no client access admin users" on admin_users for all to anon, authenticated using(false) with check(false);
