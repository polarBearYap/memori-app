import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/api/sync/sync_api.dart';
import 'package:memori_app/db/database.dart';
import 'package:memori_app/db/repositories/app_users_repository.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/db/repositories/time_zones_repository.dart';
import 'package:memori_app/features/authentication/bloc/delete_account_bloc.dart';
import 'package:memori_app/features/authentication/bloc/login_bloc.dart';
import 'package:memori_app/features/authentication/bloc/logout_bloc.dart';
import 'package:memori_app/features/authentication/bloc/signup_cubit.dart';
import 'package:memori_app/features/cards/bloc/card/add_edit_card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card/card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card/congratulate_card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card/learn_card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card/preview_card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/add_card_tag_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/card_tag_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/delete_card_tag_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/edit_card_tag_bloc.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/common/bloc/locale_cubit.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/add_deck_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/delete_deck_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/edit_deck_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck_setting/deck_setting_bloc.dart';
import 'package:memori_app/features/sync/bloc/sync_bloc.dart';
import 'package:memori_app/firebase/auth/authentication_repository.dart';
import 'package:memori_app/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Provider extends StatelessWidget {
  const Provider({
    required this.prefs,
    required this.child,
    super.key,
  });

  final SharedPreferences prefs;
  final Widget child;

  @override
  Widget build(final BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (final context) => SignUpCubit(),
          ),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AppDb>(
              create: (final BuildContext context) => AppDb(),
            ),
            RepositoryProvider<AppUsersRepository>(
              create: (final BuildContext context) => AppUsersRepository(
                context.read<AppDb>(),
              ),
            ),
            RepositoryProvider<TimeZonesRepository>(
              create: (final BuildContext context) => TimeZonesRepository(
                context.read<AppDb>(),
              ),
            ),
            RepositoryProvider<SyncApi>(
              create: (final BuildContext context) => SyncApi(),
            ),
            RepositoryProvider<AuthenticationRepository>(
              create: (final BuildContext context) => AuthenticationRepository(
                appUsersRepository: context.read<AppUsersRepository>(),
                timeZonesRepository: context.read<TimeZonesRepository>(),
                syncApi: context.read<SyncApi>(),
                signUpCubit: context.read<SignUpCubit>(),
              ),
            ),
            RepositoryProvider<DbRepository>(
              create: (final BuildContext context) => DbRepository(
                context.read<AppDb>(),
              ),
            ),
            RepositoryProvider<AppNavigatorObserver>(
              create: (final BuildContext context) => AppNavigatorObserver(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (final context) => LoginBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                ),
              ),
              BlocProvider(
                create: (final context) => LogoutBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                ),
              ),
              BlocProvider(
                create: (final context) => DeleteAccountBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                ),
              ),
              BlocProvider<ThemeBloc>(
                create: (final context) => ThemeBloc(
                  prefs: prefs,
                ),
              ),
              BlocProvider<DeckBloc>(
                create: (final context) => DeckBloc(
                  context.read<DbRepository>(),
                ),
              ),
              BlocProvider<AddDeckBloc>(
                create: (final context) => AddDeckBloc(
                  dbRepository: context.read<DbRepository>(),
                  deckBloc: context.read<DeckBloc>(),
                ),
              ),
              BlocProvider<EditDeckBloc>(
                create: (final context) => EditDeckBloc(
                  dbRepository: context.read<DbRepository>(),
                  deckBloc: context.read<DeckBloc>(),
                ),
              ),
              BlocProvider<DeleteDeckBloc>(
                create: (final context) => DeleteDeckBloc(
                  dbRepository: context.read<DbRepository>(),
                  deckBloc: context.read<DeckBloc>(),
                ),
              ),
              BlocProvider<DeckSettingBloc>(
                create: (final context) => DeckSettingBloc(
                  dbRepository: context.read<DbRepository>(),
                ),
              ),
              BlocProvider<CardTagBloc>(
                create: (final context) => CardTagBloc(
                  context.read<DbRepository>(),
                ),
              ),
              BlocProvider<CardBloc>(
                create: (final context) => CardBloc(
                  context.read<DbRepository>(),
                ),
              ),
              BlocProvider<AddCardTagBloc>(
                create: (final context) => AddCardTagBloc(
                  cardTagBloc: context.read<CardTagBloc>(),
                  dbRepository: context.read<DbRepository>(),
                ),
              ),
              BlocProvider<EditCardTagBloc>(
                create: (final context) => EditCardTagBloc(
                  cardBloc: context.read<CardBloc>(),
                  cardTagBloc: context.read<CardTagBloc>(),
                  dbRepository: context.read<DbRepository>(),
                ),
              ),
              BlocProvider<DeleteCardTagBloc>(
                create: (final context) => DeleteCardTagBloc(
                  cardTagBloc: context.read<CardTagBloc>(),
                  dbRepository: context.read<DbRepository>(),
                ),
              ),
              BlocProvider<PreviewCardBloc>(
                create: (final context) => PreviewCardBloc(),
              ),
              BlocProvider<AddEditCardBloc>(
                create: (final context) => AddEditCardBloc(
                  dbRepository: context.read<DbRepository>(),
                  cardBloc: context.read<CardBloc>(),
                ),
              ),
              BlocProvider<CongratulateCardBloc>(
                create: (final context) => CongratulateCardBloc(
                  dbRepository: context.read<DbRepository>(),
                ),
              ),
              BlocProvider<LearnCardBloc>(
                create: (final context) => LearnCardBloc(
                  dbRepository: context.read<DbRepository>(),
                  congratulateBloc: context.read<CongratulateCardBloc>(),
                ),
              ),
              BlocProvider(
                create: (final context) => LocaleCubit(
                  prefs: prefs,
                ),
              ),
              BlocProvider(
                create: (final context) => FontSizeCubit(
                  prefs: prefs,
                ),
              ),
              BlocProvider(
                create: (final context) => SyncBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                  dbRepository: context.read<DbRepository>(),
                  deckBloc: context.read<DeckBloc>(),
                ),
              ),
            ],
            child: child,
          ),
        ),
      );
}
