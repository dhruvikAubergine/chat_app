// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:chat_app/features/authentication/pages/Authentication_page.dart';
import 'package:chat_app/features/authentication/pages/sign_up_page.dart';
import 'package:chat_app/features/home/pages/home_page.dart';
import 'package:chat_app/features/home/pages/profile_page.dart';
import 'package:chat_app/features/home/pages/user_list_page.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:chat_app/l10n/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ChatsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return const HomePage();
            }
            return const AuthenticationPage();
          },
        ),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          UserListPage.routeName: (context) => const UserListPage(),
          AuthenticationPage.routeName: (context) => const AuthenticationPage(),
        },
      ),
    );
  }
}
