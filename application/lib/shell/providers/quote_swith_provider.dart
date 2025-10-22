import 'package:clean_quote_tab_todo/core/common/providers/prefs_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quoteSwitchNotifierProvider = NotifierProvider<QuoteSwitchNotifier, bool>(
  () => QuoteSwitchNotifier(),
);

class QuoteSwitchNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(prefsProvider);
    bool quoteSwitchState = prefs.getBool('quotesEnabled') ?? true;
    return quoteSwitchState;
  }

  void change() {
    final prefs = ref.watch(prefsProvider);
    prefs.setBool('quotesEnabled', !state);

    state = !state;
  }
}
