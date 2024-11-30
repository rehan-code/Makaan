create table public.business_details (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  business_name text not null,
  description text not null,
  tags text[] not null,
  is_halal boolean not null default false,
  is_halal_certified boolean not null default false,
  location text not null,
  instagram text,
  facebook text,
  website text,
  phone_number text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  constraint business_details_user_id_key unique (user_id)
);

-- Set up Row Level Security (RLS)
alter table public.business_details enable row level security;

create policy "Users can view all business details"
  on public.business_details for select
  using (true);

create policy "Users can insert their own business details"
  on public.business_details for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own business details"
  on public.business_details for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
