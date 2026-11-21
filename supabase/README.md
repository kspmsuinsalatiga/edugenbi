# Supabase setup

Project ref: `gavsepqkjudrtjftuafa`

Initial schema migration: `genbi_mission_initial_schema`.

## Tables
- `public.teams`: 10 event groups.
- `public.team_members`: anonymous Auth user → team membership.
- `public.mission_progress`: one record per team and mission (`aris`, `peka`, `ekonomi`, `bi`, `final`).
- `public.mission_events`: activity records.
- `public.leaderboard_public`: derived leaderboard maintained by database triggers.
- `private.team_invites`: bcrypt invite-code hashes; no client grants.

## Client model
- Participant sessions use Supabase anonymous Auth.
- Participants join through `public.join_team(p_code)`.
- Row Level Security limits progress and events to the participant's own team.
- Leaderboard is readable to authenticated participants.
- Realtime publishes `mission_progress` and `leaderboard_public`.

## Dashboard settings
Enable **Anonymous Sign-Ins** in Authentication → Sign In / Providers. Confirm `public` is exposed through Project Settings → Data API.

## Security Advisor
Security Advisor flagged that `private.team_invites` currently has RLS disabled. The schema is non-exposed and all client grants are revoked, but enable RLS as defense-in-depth:

```sql
ALTER TABLE private.team_invites ENABLE ROW LEVEL SECURITY;
```

No client policy should be added to this private table. The join RPC performs the invite validation.

`public.join_team(text)` intentionally uses SECURITY DEFINER to validate a submitted code against the private table. It checks anonymous Auth claims and execute is granted only to authenticated users. Review this function before changing the authentication model.

Never expose a Supabase service-role or secret key in `index.html`.
