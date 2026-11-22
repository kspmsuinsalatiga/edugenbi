-- GENBI MISSION · Register an already-created Supabase Auth user as a facilitator.
-- Step 1: Create this user's email/password account in Supabase Dashboard > Authentication > Users.
-- Step 2: Replace the placeholder below with the exact email address and run as a project admin.
-- Never place a service_role key or this SQL in a public browser page.

insert into private.facilitator_users (user_id)
select id
from auth.users
where lower(email) = lower('EMAIL_FASILITATOR')
on conflict (user_id) do nothing;

-- Verify the registration:
select u.email, fu.created_at
from private.facilitator_users fu
join auth.users u on u.id = fu.user_id
where lower(u.email) = lower('EMAIL_FASILITATOR');
