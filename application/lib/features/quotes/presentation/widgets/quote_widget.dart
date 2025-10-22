import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/entities/quote_entity.dart';
import 'package:clean_quote_tab_todo/features/quotes/presentation/providers/quotes_providers.dart';
import 'package:clean_quote_tab_todo/features/quotes/presentation/widgets/countdown_timer.dart';
import 'package:clean_quote_tab_todo/shell/widgets/divider_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuoteWidget extends ConsumerWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final quoteStream = ref.watch(quotesStreamProvider);
    
    return Column(
      children: [
        DividerLine(width: size.width - 15,),
        quoteStream.when(
          data: (quote) {
            return QuoteContent(quote);
          },
          error: (error, stackTrace) {
            return Text('Cannot Fetch a new quoto');
          },
          loading: () => LinearProgressIndicator(),
        ),
      ],
    );
  }
}

class QuoteContent extends StatelessWidget {
  final QuoteEntity quote;
  const QuoteContent(
    this.quote, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quote.quote, style: TextStyle(fontSize: 16)),
          SizedBox(height:5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("- ${quote.author}", style: Theme.of(context).textTheme.bodySmall,),
              CircularCountdownTimer(duration: quoteDuration, key: ValueKey(quote),)
            ],
          ),
        ],
      ),
    );
  }
}