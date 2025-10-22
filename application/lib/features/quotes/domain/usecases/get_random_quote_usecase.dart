import 'dart:math';

import 'package:clean_quote_tab_todo/features/quotes/domain/entities/quote_entity.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/repos/quotes_repository.dart';

class GetRandomQuoteUsecase {
  final QuotesRepository repo;

  GetRandomQuoteUsecase(this.repo);

  Future<QuoteEntity> call() async {
    final allQuotes = await repo.getAllQuotes();
    final random = Random();
    final randomIndex = random.nextInt(allQuotes.length);

    return allQuotes[randomIndex];
  }
}