import 'package:bagisto_flutter/core/wishlist/wishlist_cubit.dart';
import 'package:bagisto_flutter/features/category/data/repository/category_repository.dart';
import 'package:bagisto_flutter/features/search/presentation/pages/search_page.dart';
import 'package:bagisto_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store_config_fakes.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final hidden in [true, false]) {
    testWidgets(
      'search page ${hidden ? 'hides' : 'shows'} Image Search',
      (tester) async {
        final cubit = seededStoreConfigCubit(
          hidden ? const {'imageSearchEnabled': false} : const {},
        );
        addTearDown(cubit.close);

        await tester.pumpWidget(
          RepositoryProvider(
            create: (_) => CategoryRepository(
              client: GraphQLClient(
                link: HttpLink('https://example.com/graphql'),
                cache: GraphQLCache(),
              ),
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider(create: (_) => WishlistCubit()),
              ],
              child: MaterialApp(
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const SearchPage(),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byIcon(Icons.image_outlined),
          hidden ? findsNothing : findsOneWidget,
        );
      },
    );
  }
}
