-- Function to get business_id for current user
create or replace function get_business_id_for_auth_user()
returns uuid
language sql
stable
as $$
  select id from public.business_details
  where user_id = auth.uid()
  limit 1;
$$;

create table public.coupons (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  description text not null,
  terms_and_conditions text not null,
  code text not null,
  valid_until timestamp with time zone not null,
  business_id uuid not null default get_business_id_for_auth_user() references public.business_details(id) on delete cascade,
  created_at timestamp with time zone not null default now(),
  unique(code, business_id)
);

-- Set up Row Level Security (RLS)
alter table public.coupons enable row level security;

-- Policies
create policy "Public coupons are viewable by everyone"
  on public.coupons for select
  using (true);

create policy "Users can create coupons for their business"
  on public.coupons for insert
  with check (
    business_id = get_business_id_for_auth_user()
  );

create policy "Users can update coupons for their business"
  on public.coupons for update
  using (
    business_id = get_business_id_for_auth_user()
  );

create policy "Users can delete coupons for their business"
  on public.coupons for delete
  using (
    business_id = get_business_id_for_auth_user()
  );
