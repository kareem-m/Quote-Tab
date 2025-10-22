import 'package:clean_quote_tab_todo/features/quotes/domain/entities/quote_entity.dart';

abstract class QuotesRepository {
  Future<List<QuoteEntity>> getAllQuotes();
}