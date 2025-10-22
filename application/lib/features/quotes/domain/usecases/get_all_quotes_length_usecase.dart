import 'package:clean_quote_tab_todo/features/quotes/domain/repos/quotes_repository.dart';

class GetAllQuotesLengthUsecase {
  final QuotesRepository repo;

  GetAllQuotesLengthUsecase(this.repo);

  Future<int> call () async {
    final quoteList = await repo.getAllQuotes();
    return quoteList.length;
  }
}