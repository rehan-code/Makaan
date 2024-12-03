-- Function to reveal a coupon code
create or replace function public.reveal_coupon_code(p_assignment_id uuid)
returns table (
    code text,
    revealed_at timestamp with time zone
) as $$
declare
    v_revealed_at timestamp with time zone;
begin
    -- Check if the assignment exists and belongs to the user
    if not exists (
        select 1
        from public.coupon_assignments
        where id = p_assignment_id
        and user_id = auth.uid()
        and is_revealed = false
    ) then
        raise exception 'Invalid assignment or already revealed';
    end if;

    -- Update the assignment status and get the coupon code
    v_revealed_at := now();
    
    update public.coupon_assignments
    set is_revealed = true,
        revealed_at = v_revealed_at
    where id = p_assignment_id;

    return query
    select c.code, v_revealed_at
    from public.coupon_assignments ca
    join public.coupons c on c.id = ca.coupon_id
    where ca.id = p_assignment_id;
end;
$$ language plpgsql security definer;
