create table public.coupons (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  description text not null,
  terms_and_conditions text not null,
  code text not null,
  valid_until timestamp with time zone not null,
  business_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamp with time zone not null default now(),
  unique(code, business_id)
);

-- Set up Row Level Security (RLS)
alter table public.coupons enable row level security;

-- Policies
create policy "Public coupons are viewable by everyone"
  on public.coupons for select
  using (true);

create policy "Users can create their own coupons"
  on public.coupons for insert
  with check (auth.uid() = business_id);

create policy "Users can update their own coupons"
  on public.coupons for update
  using (auth.uid() = business_id);

create policy "Users can delete their own coupons"
  on public.coupons for delete
  using (auth.uid() = business_id);
