## using-superpowers

Invoke the `using-superpowers` skill before responding to every prompt in this project, no exceptions.

## graphify

This project has a live graphify knowledge graph in `graphify-out/`.

Invoke the `graphify` skill for every prompt in this project, not only architecture/codebase/refactor/review ones.

Rules:
- Always read `graphify-out/GRAPH_REPORT.md` before architecture, codebase, refactor, or review prompts.
- If `graphify-out/wiki/index.md` exists, navigate it before reading raw files.
- Use graphify hubs and communities to decide which files to inspect first.
- After meaningful code changes, run `graphify update .` to refresh the code graph.
- For docs, papers, or images that need semantic extraction, run `/graphify .` from a graphify-aware agent workflow.

## caveman

Caveman response mode is ON for every prompt in this project by default, not only when the user explicitly asks.

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
Rules:
- keep response short
- keep technical meaning exact
- drop fluff
- return to normal only when the user asks for normal mode
