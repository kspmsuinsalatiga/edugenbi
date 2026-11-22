# Supabase — GENBI MISSION

Project ref: `gavsepqkjudrtjftuafa`.

## Participant data
- `public.teams`: 10 event teams.
- `public.team_members`: Auth user to team membership.
- `public.mission_progress`: participant progress and digital mission answers.
- `public.mission_events`: activity log.
- `public.leaderboard_public`: derived leaderboard.

Participants authenticate using anonymous Auth and join via `public.join_team(p_code)`. Team-scoped RLS limits participant progress and event reads/writes to their own team. Participant invite codes are bcrypt-hashed in `private.team_invites`.

## Facilitator authorization
Migration `facilitator_access_and_assessment_layer` added:
- `private.facilitator_users`: allowlist of approved Supabase Auth user IDs. RLS limits a facilitator to checking their own allowlist entry.
- `public.is_genbi_facilitator()`: authorization RPC, returning true only for allowlisted signed-in users.
- `public.facilitator_assessments`: facilitator's official score, completion flag and notes per team/mission. RLS requires facilitator allowlist membership and `updated_by = auth.uid()`.
- Read policies for facilitators on all teams' mission progress and events.
- A database trigger recalculates leaderboard entries using the facilitator assessment where it exists; participant results remain stored separately.

### Create a facilitator account
1. In Supabase Dashboard, open **Authentication → Users → Add user** and create an email/password user for each authorized facilitator.
2. Open SQL Editor and run the parameterized template from `supabase/facilitator-setup.sql`, replacing `EMAIL_FASILITATOR` with that exact email.
3. The facilitator opens `/facilitator.html` and signs in using the account credentials. The page checks `is_genbi_facilitator()` before loading cross-team information.
4. To revoke access, delete that user's row from `private.facilitator_users` (keep or delete the Auth user as your policy requires).

Do not expose a Supabase service-role/secret key in any browser page. The publishable key in these static pages is designed for client-side use under RLS.

## Dashboard configuration
For participant accounts, enable **Anonymous Sign-Ins** in Authentication → Sign In / Providers. Confirm `public` is exposed via Project Settings → Data API. Email/password auth must be enabled for facilitators.

## Security Advisor item that still needs administrator action
The current Security Advisor reports RLS disabled for `private.team_invites`. The table is in the non-exposed private schema and has no client grants, and the join RPC performs the invite verification. Nevertheless, enable RLS as defense-in-depth from the Supabase SQL Editor:

```sql
ALTER TABLE "private"."team_invites" ENABLE ROW LEVEL SECURITY;
```

No client policy should be added to this private invite table. This command has **not** been applied automatically; it is left for the project administrator to review and run.

The Advisor also warns that `public.join_team(p_code text)` is a SECURITY DEFINER function callable by authenticated users. This is intentional in the current design: the function checks the anonymous-auth JWT claim, validates bcrypt hashes in the private invite table, and creates only the current user's team membership. Review its definition before changing auth permissions.

## Realtime
Publication includes `mission_progress`, `leaderboard_public`, and `facilitator_assessments`. Facilitator dashboard also subscribes to `mission_events` (Realtime must be enabled for it in your project if live activity push is required; periodic manual refresh remains available).
