-- GENBI MISSION — single facilitator account setup
--
-- 1) In Supabase Dashboard open Authentication → Users → Add user.
-- 2) Create exactly this account (set its initial password in the dashboard):
--      genbiedu@gmail.com
-- 3) A database trigger automatically inserts the Auth user ID into
--    private.facilitator_users. No separate signup page or manual allowlist insert
--    is required. Do not add other facilitator emails.
-- 4) Verify the account after creating it:

select
  u.email,
  fu.created_at as allowlisted_at
from auth.users u
left join private.facilitator_users fu on fu.user_id = u.id
where lower(u.email) = lower('genbiedu@gmail.com');

-- Expected: one row with allowlisted_at populated.
-- If the account is absent, create it through Authentication → Users first.
-- Never place the password or a Supabase service-role key in this repository.
