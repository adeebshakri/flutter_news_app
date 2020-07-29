import 'dart:convert';
import 'package:flutternewsapp/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{
  List<ArticleModel> news = [];
  ArticleModel articleModel;

  Future<void> getNews() async{
    String url = "http://newsapi.org/v2/top-headlines?country=in&apiKey=18df80209cdb452185cd47a7390c5c54";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if(jsonData['status'] == 'ok'){
      jsonData['articles'].forEach((element){

        if(element["urlToImage"] != null && element['description'] != null){
          articleModel = new ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content']
          );
          news.add(articleModel);
        }
      });
    }
  }
}

class CategoryNewsClass{
  List<ArticleModel> news = [];
  ArticleModel articleModel;

  Future<void> getNews(String category) async{
    String url = "http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=18df80209cdb452185cd47a7390c5c54";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if(jsonData['status'] == 'ok'){
      jsonData['articles'].forEach((element){

        if(element["urlToImage"] != null && element['description'] != null){
          articleModel = new ArticleModel(
              title: element['title'],
              author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              content: element['content']
          );
          news.add(articleModel);
        }
      });
    }

  }
}