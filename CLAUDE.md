
Default to using Bun instead of Node.js.

- Use `bun <file>` instead of `node <file>` or `ts-node <file>`
- Use `bun test` instead of `jest` or `vitest`
- Use `bun build <file.html|file.ts|file.css>` instead of `webpack` or `esbuild`
- Use `bun install` instead of `npm install` or `yarn install` or `pnpm install`
- Use `bun run <script>` instead of `npm run <script>` or `yarn run <script>` or `pnpm run <script>`
- Use `bunx <package> <command>` instead of `npx <package> <command>`
- Bun automatically loads .env, so don't use dotenv.

## APIs

- `Bun.serve()` supports WebSockets, HTTPS, and routes. Don't use `express`.
- `bun:sqlite` for SQLite. Don't use `better-sqlite3`.
- `Bun.redis` for Redis. Don't use `ioredis`.
- `Bun.sql` for Postgres. Don't use `pg` or `postgres.js`.
- `WebSocket` is built-in. Don't use `ws`.
- Prefer `Bun.file` over `node:fs`'s readFile/writeFile
- Bun.$`ls` instead of execa.

## Testing

Use `bun test` to run tests.

```ts#index.test.ts
import { test, expect } from "bun:test";

test("hello world", () => {
  expect(1).toBe(1);
});
```

## Frontend

Use React with shadcn/ui components and TanStack Query for state management. Bun.serve handles the HTTP/WebSocket server.

**Directory:** `src/interfaces/web/`

```tsx#dashboard.tsx
import { useQuery, useMutation } from '@tanstack/react-query'
import { Card, Button } from '@/components/ui/card'

export function SessionDashboard() {
  const { data: sessions } = useQuery({
    queryKey: ['sessions'],
    queryFn: fetchSessions
  })

  return (
    <div className="grid gap-4 p-4">
      {sessions?.map(session => (
        <Card key={session.id}>{session.name}</Card>
      ))}
    </div>
  )
}
```

**TanStack Query patterns:**
- Query client for server state management
- Optimistic updates for user actions
- Invalidation-based refetching

**shadcn/ui:**
- Copy components from shadcn-ui library
- Customize via CSS variables in globals.css
- Use Radix UI primitives for accessibility

## CLI Framework

Use **OpenTUI** for terminal interface.

**Directory:** `src/interfaces/cli/`

```ts#cli.ts
import { Application, Command } from 'open-tui'

export async function createApp(): Promise<Application> {
  const app = new Application({
    name: 'emerge',
    description: 'LLM dialogue research platform'
  })

  app.addCommand('session', new SessionCommand())
  app.addCommand('export', new ExportCommand())

  return app
}
```

**Patterns:**
- Commands for discrete operations
- Prompts for interactive input
- Table/List components for data display

## LangGraph Agent Orchestration

Use LangGraph for agent state management. Each Actor is a LangGraph agent with custom state and edges.

**Directory:** `src/agents/`

```ts#actor-agent.ts
import { createAgent, AgentState } from 'langgraph'

interface ActorState extends AgentState {
  actorId: string
  provider: Provider
  conversationHistory: Turn[]
}

export const createActorAgent = (config: ActorConfig) =>
  createAgent({
    name: `actor-${config.id}`,
    initialState: { actorId: config.id, ... },
    nodes: {
      generateResponse: generateResponseNode,
      validateTurn: validateTurnNode
    },
    edges: [[generateResponse, validateTurn]]
  })
```

**LangChain integration:**
- Use `langchain` core packages for abstractions
- Provider integrations via `@langchain/community` or custom
- Messages abstraction for conversation history

## Database

Use `bun:sqlite` for SQLite persistence.

```ts#checkpointer.ts
import { Database } from 'bun:sqlite'

export class SQLiteCheckpointer {
  private db: Database

  constructor(path: string) {
    this.db = new Database(path)
  }

  async saveState(sessionId: string, state: unknown): Promise<void> {
    this.db.prepare(
      'INSERT OR REPLACE INTO checkpoints (session_id, state, timestamp) VALUES (?, ?, ?)'
    ).run(sessionId, JSON.stringify(state), Date.now())
  }

  async loadState(sessionId: string): Promise<unknown | null> {
    return this.db.prepare(
      'SELECT state FROM checkpoints WHERE session_id = ? ORDER BY timestamp DESC LIMIT 1'
    ).get(sessionId)?.state as unknown
  }
}
```

**Schema:** See TechSpec.md section 3.1

## Server

Bun.serve with routes and WebSocket for real-time events.

```ts#server.ts
import { serve } from 'bun'

Bun.serve({
  routes: {
    '/api/sessions': sessionsRouter,
    '/api/export': exportRouter,
    '/': serveStatic('src/interfaces/web/index.html')
  },
  websocket: {
    open: (ws) => eventBus.subscribe(ws),
    message: (ws, message) => handleMessage(ws, message)
  }
})
```

For more information, read the Bun API docs in `node_modules/bun-types/docs/**.mdx`.
