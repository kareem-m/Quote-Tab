import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/core/router/app_router.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/providers/auth_providers.dart';
import 'package:clean_quote_tab_todo/shell/providers/quote_swith_provider.dart';
import 'package:clean_quote_tab_todo/shell/widgets/divider_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final drawerWidth = size.width * 3 / 4;
    return SafeArea(
      child: Drawer(
        width: drawerWidth,
        backgroundColor: drawerColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 30),
                UserInDrawer(),
                SizedBox(height: 10),
                DividerLine(width: drawerWidth - 50, thickness: 1.5),
                QuoteSwitch(),
              ],
            ),
            Column(
              children: [
                DividerLine(width: drawerWidth - 50, thickness: 1.5),
                LogoutTile(),
                SizedBox(height: 10,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutTile extends ConsumerWidget {
  const LogoutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      title: Text('Log out', style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.logout, color: Colors.white),
      onTap: () {
        final router = AppRouter();
        ref.read(logoutProvider).call();
        router.navigateToLogin(context);
      },
    );
  }
}

class UserInDrawer extends ConsumerWidget {
  const UserInDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        CircleAvatar(radius: 60, child: Icon(Icons.person, size: 90)),
        SizedBox(height: 10),
        Text(
          ref.watch(getUserProvider).call()?.username ?? 'Unknown',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class QuoteSwitch extends ConsumerWidget {
  const QuoteSwitch({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final quoteSwitchState = ref.watch(quoteSwitchNotifierProvider);
    final quoteSwitchChanger = ref.read(quoteSwitchNotifierProvider.notifier);

    return SwitchListTile(
      title: Text('Show Quotes', style: TextStyle(color: Colors.white)),
      value: quoteSwitchState,
      onChanged: (value) {
        quoteSwitchChanger.change();
      },
    );
  }
}
