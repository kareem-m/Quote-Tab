import 'dart:io';

import 'package:clean_quote_tab_todo/core/common/ui/loading_widget.dart';
import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/auth_gate.dart';
import 'package:clean_quote_tab_todo/features/version_check/presentation/providers/version_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckGate extends ConsumerWidget {
  const VersionCheckGate({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final versionStatus = ref.watch(versionCheckProvider);
    return versionStatus.when(data: (status){
      if(status == VersionStatus.upToDate){
        return const AuthGate();
      }
        else{
          Future.microtask(() => _showUpdateDialog(context));
          return _buildEmptyScaffold();
        }
      }
    , error: (error, trace){
      Future.microtask(() => _showErrorDialog(context, error.toString()));
        return _buildEmptyScaffold();
    }, loading: () => const LoadingWidget());
  }
}

Widget _buildEmptyScaffold() {
    return Scaffold(
      backgroundColor: mainAppColor,
      body: const LoadingWidget(),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 37, 45, 65),
          title: Text("Update Available!"),
          content: Text('Please Update The Application to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                final url = Uri.parse('https://quote-tab.netlify.app/');
                  await launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 37, 45, 65),
          title: Text('Error'),
          content: Text('Failed to connect to the internet. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  exit(0);
                }
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }