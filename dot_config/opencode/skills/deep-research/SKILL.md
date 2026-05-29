---
name: deep-research
description: >-
  Deep web research using parallel sub-agents. Classifies question into depth
  tier (quick/standard/deep), spawns proportional researcher sub-agents,
  synthesizes into short answer + detailed report with citations. Use when
  user asks "best X for Y", "compare A vs B", "what is best approach for Z",
  "research X", "how does X compare to Y", or needs deep investigation.
---

# Deep Research

## Depth tiers

Classify question into one of three tiers. Show tier + query plan to user
before spawning.

| Tier | When | Queries | Pages/agent |
|---|---|---|---|
| **Quick** | Fact, definition, single product, "what is X" | 2-3 | 1-2 |
| **Standard** | Comparison, recommendation, "best X for Y", "should I use X" | 4-6 | 2-3 |
| **Deep** | Architecture decision, comprehensive research, "design X for scenario Y" | 7-9 | 3-4 |

### Decision guide

- Single entity, no tradeoffs → Quick
- Wants best choice among options → Standard
- Broad topic, multi-faceted, or "how to design X" → Deep
- **When unsure: default to Standard.** Over-fetching is cheap; under-fetching wastes user time with follow-ups.

### Example classifications

**Quick** — "what is OIDC":
```
1. OpenID Connect explained
2. OIDC vs SAML vs OAuth2
3. how OIDC works
```

**Standard** — "best OIDC for homelabbing":
```
1. best OIDC provider homelab comparison 2026
2. Authentik vs Authelia vs Keycloak comparison self-hosted
3. Authentik review pros cons reddit
4. lightweight OIDC server homelab
5. self-hosted OIDC alternatives
6. Keycloak vs Authentik resource usage
```

**Deep** — "design auth system for homelab":
```
1. homelab identity provider architecture comparisons
2. Authentik vs Authelia vs Keycloak feature comparison 2026
3. self-hosted OIDC providers resource usage benchmarks
4. homelab auth system security best practices
5. LDAP vs OIDC vs SAML homelab use cases
6. Keycloak performance tuning homelab
7. Authentik setup guide integration walkthrough
8. Authelia forward-auth vs OIDC comparison
9. homelab SSO disaster recovery backup
```

### Reassess

If Standard or Quick results come back thin (few sources, weak consensus),
spawn a second wave on new angles. Tell user: "Results were thin, digging
deeper on [new angles]."

## Workflow

### Phase 1 — Classify and generate queries

1. Classify into Quick / Standard / Deep
2. Generate queries using the template per tier
3. Cover these angles (proportionally to query count):

- **Direct**: the core question
- **Comparison**: "X vs Y", "alternatives to X"
- **Reviews**: "best X", "X review", "X pros cons", site:reddit.com
- **Technical**: "X setup", "X guide", "X configuration"
- **Pitfalls**: "X issues", "X limitations"

4. Show the user: `[Tier: Standard] 6 queries` + list of queries

### Phase 2 — Spawn parallel sub-agents

For each query, spawn a `researcher` sub-agent via Task tool. Launch **all
in parallel** (single message, multiple Task calls):

```
Task(
  description="Research: <short query>",
  prompt="Query: <query>\n\nUse websearch then webfetch to research this. Return structured findings.",
  subagent_type="researcher"
)
```

For Deep tier, append to prompt: `"Research thoroughly — fetch 3-4 pages per query."`

Show progress:
```
🔍 [1/6] best OIDC provider homelab comparison 2026
🔍 [2/6] Authentik vs Authelia vs Keycloak comparison
... (all at once)
✅ [1/6] done — 3 sources
✅ [2/6] done — 4 sources
...
```

### Phase 3 — Synthesize

**1. Short answer** (1-3 sentences) — top recommendation + why.

**2. Detailed report:**

| Section | Content |
|---|---|
| **Recommendation** | Top pick + why, key differentiators |
| **Comparison table** | Options with features, pros, cons |
| **Setup complexity** | How hard each is to deploy and maintain |
| **Community consensus** | What most users agree on |
| **Gotchas** | Known issues, limitations |
| **Sources** | URLs grouped by section |

### Phase 4 — Verify

Before delivering:
- [ ] Short answer clearly states top pick
- [ ] Report covers at least 3 options/approaches
- [ ] Each claim has source URL
- [ ] Gotchas included (not just praise)
