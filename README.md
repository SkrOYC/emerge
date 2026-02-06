# Emerge

A research and educational platform for observing autonomous LLM-to-LLM dialogue sessions.

## Quick Start

```bash
bun install
bun run src/index.ts
```

## Architecture

- **PRD.md** - Product requirements and functional capabilities
- **Architecture.md** - System design, containers, and execution flows
- **TechSpec.md** - Technical implementation details, API contracts, and database schema
- **Tasks.md** - Ordered implementation tasks with dependencies

## Stack

- **Runtime:** Bun
- **Agent Orchestration:** LangGraph
- **Database:** SQLite (bun:sqlite)
- **CLI:** OpenTUI
- **Web:** React + shadcn/ui + TanStack Query

## License

MIT