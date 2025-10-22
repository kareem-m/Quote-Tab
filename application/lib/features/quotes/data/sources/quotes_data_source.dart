import 'dart:convert';

import 'package:clean_quote_tab_todo/features/quotes/data/models/quote_model.dart';
import 'package:flutter/services.dart';

class QuotesDataSource {

  Future<List<QuoteModel>> getAllQuotes () async {
    try{
      final String jsonData = await rootBundle.loadString('assets/quotes/quotes.json');
      final List<dynamic> quotesJson = jsonDecode(jsonData);
      final List<QuoteModel> quotes = quotesJson.map((quote) => QuoteModel.fromJson(quote)).toList();
      return quotes;
    }
    catch(e){
      throw Exception('Error getting Quotes');
    }
  }
}