# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Mandatory skills: apply to EVERY prompt

These rules apply to every user prompt in this repo, including simple questions,
one-line fixes, and follow-ups. Do them before any other response or tool call.

1. **`/superpowers:using-superpowers`**: invoke it first on every prompt (if not
   already loaded this session). Then check each available superpowers skill
   and invoke every one that could apply, for example:
   - new feature or behavior change: `superpowers:brainstorming`, then `superpowers:writing-plans`
   - bug, test failure, unexpected behavior: `superpowers:systematic-debugging`
   - writing code: `superpowers:test-driven-development`
   - before claiming "done" or committing: `superpowers:verification-before-completion`
2. **`/caveman:caveman`**: keep caveman mode active for every reply (default
   level `full`). Chat replies stay terse. Code, comments, commit messages, PR
   text, docs, and memory files stay normal prose. Only turn caveman off when
   the user says "stop caveman" or "normal mode".
3. **`/graphify`**: invoke the `graphify` skill for every prompt about code,
   architecture, file relationships, or project content.
   - If `graphify-out/` exists, query the graph first, before grep or file reads.
   - If `graphify-out/` does not exist, build it with `/graphify` first.
   - After significant code changes, update the graph so it stays current.

Order per prompt: `using-superpowers`, then `caveman`, then `graphify`, then the
task-specific skills (for example `flutter-expert`), then the work itself.

Do not skip these because a task "seems simple". Only skip a rule when the user
explicitly says so for that prompt.

## Project

Bagisto open-source e-commerce mobile app. Flutter (Dart SDK ^3.10.8), package
name `bagisto_flutter`, talks to a Bagisto backend over GraphQL.

## Commands

```bash
flutter pub get
flutter run
flutter analyze
flutter test                       # all tests
flutter test test/orders_bloc_test.dart
flutter gen-l10n                   # after editing any lib/l10n/app_*.arb
```

Maestro E2E flows live in `maestro/` (see `maestro/LABEL_BASED_INSTRUCTIONS.md`).

## Layout

- `lib/core/`: shared code (`graphql/`, `theme/`, `error/`, `locale/`, `currency/`, `widgets/`, ...)
- `lib/core/graphql/`: raw GraphQL query/mutation strings in static-only classes (`AccountQueries`, `ReturnsQueries`, ...)
- `lib/features/<feature>/`: `account`, `auth`, `cart`, `category`, `checkout`, `home`, `product`, `search`, `splash`
- `lib/l10n/`: 10 `app_*.arb` files plus generated `app_localizations*.dart` (committed)
- `Docs/`: setup guides; design specs under `Docs/superpowers/specs/`
- `Docs/ai-memory/`: notes for AI agents on past fix rounds (root causes,
  gotchas, backend-blocked issues). Read the relevant note before touching
  those areas, and add a new dated note after a large fix round.
- `test/`: flat directory of unit and widget tests

## House style

- **State**: `flutter_bloc` + `equatable`. Events, states, and bloc live in ONE
  file per bloc under `lib/features/<feature>/presentation/bloc/`.
- **Models**: hand-written defensive `fromJson`. No codegen, no `json_serializable`.
- **GraphQL**: `graphql_flutter`. Repositories call the client directly (no
  datasource layer) and throw feature exceptions built with
  `ErrorMapper.getUserMessage`. Single-entity Bagisto queries need IRI ids
  (for example `/api/shop/customer-orders/{id}`).
- **Pagination**: cursor (Relay). Repositories return records
  `({list, totalCount, hasNextPage, endCursor})`.
- **Navigation**: no route table or GoRouter. Use imperative
  `Navigator.push(MaterialPageRoute(...))` with `BlocProvider` created inline.
  Detail pages expose `static navigate(...)`.
- **l10n**: every user-facing string goes into all 10 arb files. Key format is
  camelCase `<feature><Thing>`. Placeholder metadata only in `app_en.arb`.
  Run `flutter gen-l10n` and commit the generated files.
- **UI**: widgets branch on `Theme.of(context).brightness` for dark mode.
  Primary color `AppColors.primary500` (#FF6900). Cards: radius 10, padding 12.
  Primary buttons: height 48, radius 54.
- **Tests**: fake repositories subclass the real repository with a dummy
  `GraphQLClient`. Seed bloc state through a `seedState` subclass
  (see `test/orders_bloc_test.dart`).

## Known baseline

- `flutter analyze` already reports about 49 info/warnings in category, home,
  and search files. Do not treat these as regressions.
- `test/address_debug_payload_test.dart` fails on a clean tree.
- Image upload for returns/messages is REST multipart only, not in GraphQL.
