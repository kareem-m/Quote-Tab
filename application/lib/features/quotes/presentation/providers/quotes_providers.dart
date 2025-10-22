import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/quotes/data/repos/quotes_repo_impl.dart';
import 'package:clean_quote_tab_todo/features/quotes/data/sources/quotes_data_source.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/entities/quote_entity.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/repos/quotes_repository.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/usecases/get_all_quotes_length_usecase.dart';
import 'package:clean_quote_tab_todo/features/quotes/domain/usecases/get_random_quote_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final datasourceProvider = Provider<QuotesDataSource>((ref) {
  return QuotesDataSource();
});

final quotesRepoProvider = Provider<QuotesRepository>((ref) {
  return QuotesRepoImpl(ref.watch(datasourceProvider));
});

final getRandomQuoteProvider = Provider<GetRandomQuoteUsecase>((ref) {
  return GetRandomQuoteUsecase(ref.watch(quotesRepoProvider));
});

final getAllQuotesLengthProvider = Provider<GetAllQuotesLengthUsecase>((ref){
  return GetAllQuotesLengthUsecase(ref.watch(quotesRepoProvider));
});

final quotesStreamProvider = StreamProvider.autoDispose<QuoteEntity>((ref) {
  Stream<QuoteEntity> quoteStream() async* {
    List<QuoteEntity> viewedQuotes = [];
    final int allQuotesLength = await ref.read(getAllQuotesLengthProvider).call();

    while (true) {
      final quote = await ref.read(getRandomQuoteProvider).call();
      if(viewedQuotes.contains(quote) || quote.quote.length > 110){
        continue;
      }
      else{
        yield quote;
        viewedQuotes.add(quote);
      }
      if (viewedQuotes.length == allQuotesLength){
        viewedQuotes.clear();
      }
      await Future.delayed(quoteDuration);
    }
  }
  return quoteStream();
});
