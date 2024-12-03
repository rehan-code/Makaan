-- Create enum for assignment status
-- create type public.coupon_assignment_status as enum ('unrevealed', 'revealed');

-- Create coupon assignments table
create table public.coupon_assignments (
    id uuid default gen_random_uuid() primary key,
    coupon_id uuid not null references public.coupons(id) on delete cascade,
    user_id uuid not null references auth.users(id) on delete cascade,
    is_revealed boolean not null default false,
    revealed_at timestamp with time zone,
    created_at timestamp with time zone not null default now(),

    constraint valid_revealed_timestamp check (
        (is_revealed = false and revealed_at is null) or
        (is_revealed = true and revealed_at is not null)
    )
);

-- Create index for faster lookups
create index idx_coupon_assignments_coupon_id on public.coupon_assignments(coupon_id);
create index idx_coupon_assignments_user_id on public.coupon_assignments(user_id);
create index idx_coupon_assignments_is_revealed on public.coupon_assignments(is_revealed);

-- Set up Row Level Security (RLS)
alter table public.coupon_assignments enable row level security;

-- Policies for coupon assignments
create policy "Users can view their own assignments"
    on public.coupon_assignments
    for select
    using (auth.uid() = user_id);

create policy "Business owners can view their coupon assignments"
    on public.coupon_assignments
    for select
    using (
        exists (
            select 1 from public.coupons c
            where c.id = coupon_assignments.coupon_id
            and c.business_id = auth.uid()
        )
    );

-- Function to randomly assign coupons to users when a new coupon is created
create or replace function public.assign_coupons_on_creation()
returns trigger as $$
declare
    v_users uuid[];
    v_user_count integer;
    v_assignments_per_user integer;
    v_remaining_assignments integer;
begin
    -- Get all user IDs
    select array_agg(id)
    into v_users
    from auth.users
    where id != new.business_id;  -- Exclude the business owner

    v_user_count := array_length(v_users, 1);
    
    if v_user_count is null then
        return new;  -- No users to assign to
    end if;

    -- Calculate how many coupons each user gets
    v_assignments_per_user := new.num_coupons / v_user_count;
    v_remaining_assignments := new.num_coupons % v_user_count;

    -- Create base assignments (equal distribution)
    if v_assignments_per_user > 0 then
        insert into public.coupon_assignments (coupon_id, user_id)
        select new.id, u
        from unnest(v_users) u,
             generate_series(1, v_assignments_per_user);
    end if;

    -- Distribute remaining coupons randomly
    if v_remaining_assignments > 0 then
        insert into public.coupon_assignments (coupon_id, user_id)
        select new.id, u
        from (
            select u
            from unnest(v_users) u
            order by random()
            limit v_remaining_assignments
        ) random_users;
    end if;

    return new;
end;
$$ language plpgsql security definer;

-- Trigger to assign coupons when a new coupon is created
create trigger assign_coupons_on_creation_trigger
    after insert on public.coupons
    for each row
    execute function public.assign_coupons_on_creation();
