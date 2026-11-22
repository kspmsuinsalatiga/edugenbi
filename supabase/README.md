# Supabase — GENBI MISSION

Project ref: `gavsepqkjudrtjftuafa`.

## Authentication and roles

### One facilitator account
Only the exact email `genbiedu@gmail.com` is accepted by the facilitator allowlist. No facilitator sign-up is available. An `auth.users` trigger automatically adds that single Auth user to `private.facilitator_users` when an administrator creates it in Supabase Authentication → Users.

Create the one account once in the Supabase dashboard; see `supabase/facilitator-setup.sql` for a verification query. The facilitator website signs in with email/password and calls `public.is_genbi_facilitator()` before loading data. The password is not stored in this repository or in browser source.

### Participant registration + approval
Participants are created with Supabase Anonymous Auth (no email/password form). They submit:
- Full name
- School
- Requested team (one of the 10 seeded teams)

The request is inserted into `public.participant_registrations` with status `pending`. The participant can only read their own request. The one facilitator can see the pending queue and choose **Approve** or **Reject**. On approval, an RLS-protected database function creates the `team_members` membership in the selected team, enforcing a maximum of 10 participants per team. Participants cannot enter mission pages or write progress until the membership exists. Rejected applicants may correct their details and resubmit.

The old invite-code RPC `public.join_team(text)` has had client EXECUTE privileges revoked to prevent bypassing facilitator approval. Existing invite hashes remain in the private schema but are no longer used by the participant UI.

## Tables and data
- `public.teams`: the 10 event teams.
- `public.team_members`: approved anonymous Auth users mapped to teams.
- `public.participant_registrations`: pending/approved/rejected registration requests, with private-to-owner or facilitator-only reads.
- `public.mission_progress`: one record per team and mission (`aris`, `peka`, `ekonomi`, `bi`, `final`).
- `public.mission_events`: activity records.
- `public.facilitator_assessments`: official facilitator score, completion flag and notes per team/mission.
- `public.leaderboard_public`: derived leaderboard maintained by database triggers.
- `private.facilitator_users`: one-account allowlist, not exposed to anonymous/public users.
- `private.team_invites`: legacy bcrypt invite hashes; no longer used by the participant route.

## RLS controls
- Participants may create only their own pending request, read their own request, and delete their own rejected request to reapply.
- Only the exact allowlisted facilitator may list all registrations, update decisions, insert team membership, view cross-team progress/events, or save facilitator assessments.
- The approval RPC runs as invoker and relies on the facilitator RLS policies.
- Participant mission progress/events remain team-scoped.
- Realtime publishes `participant_registrations`, `mission_progress`, `mission_events`, `facilitator_assessments`, and `leaderboard_public`.

## Dashboard settings
Enable **Anonymous Sign-Ins** in Authentication → Sign In / Providers. Confirm `public` is exposed via Project Settings → Data API. Email/password sign-in must be enabled for the one facilitator account.

## Security item to review
The project schema inspection still reports RLS disabled on the legacy `private.team_invites` table. It is in a non-exposed private schema and has no client grants, and the old join RPC is no longer executable by client roles. Nevertheless, enable RLS as defense-in-depth when the project administrator is ready:

```sql
ALTER TABLE "private"."team_invites" ENABLE ROW LEVEL SECURITY;
```

No client policy should be added to that private legacy table. This command has not been automatically applied.

Never expose a Supabase service-role/secret key in any browser page.
