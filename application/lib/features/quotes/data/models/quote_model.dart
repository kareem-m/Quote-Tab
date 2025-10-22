import 'package:clean_quote_tab_todo/features/quotes/domain/entities/quote_entity.dart';

class QuoteModel extends QuoteEntity{
  QuoteModel({required super.quote, required super.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json){
    return QuoteModel(quote: json['quote'], author: json['author']);
  }

  QuoteEntity toEntity(){
    return QuoteEntity(quote: quote, author: author);
  }
}