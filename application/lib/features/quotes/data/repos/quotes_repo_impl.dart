import 'package:clean_quote_tab_todo/features/quotes/data/sources/quotes_data_source.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/entities/quote_entity.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/repos/quotes_repository.dart';

class QuotesRepoImpl implements QuotesRepository{
  final QuotesDataSource dataSource;

  QuotesRepoImpl(this.dataSource);

  @override
  Future<List<QuoteEntity>> getAllQuotes() async {
    final models = await dataSource.getAllQuotes();
    
    final quotes = models.map((model) => model.toEntity()).toList();

    return quotes;
  }
}