import 'package:flutter/material.dart';
import 'package:flutternewsapp/helper/news_data.dart';
import 'package:flutternewsapp/models/article_model.dart';
import 'article_view.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({this.category});
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles  = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }
  getCategoryNews() async{
    CategoryNewsClass newsObj = CategoryNewsClass();
    await newsObj.getNews(widget.category);
    articles = newsObj.news;
    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("news"),
            Text("ByShakri", style: TextStyle(fontWeight:FontWeight.w700, color: Colors.teal),)
          ],
        ),
      ),
      body: _loading ? Center(child: Container(child: CircularProgressIndicator()))
          :SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10 ),
          child: Column(
            children: <Widget>[
              ///Blogs
              Container(
                padding: EdgeInsets.only(top: 10 ),
                margin: EdgeInsets.only(top: 16),
                child: ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),   //It wasn't scrolling. I had to use this then it worked!
                    itemBuilder: (context,index){
                      return BlogTile(
                          imageUrl: articles[index].urlToImage,
                          title: articles[index].title,
                          desc: articles[index].description,
                          url: articles[index].url
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl , title, desc , url;


  BlogTile({ @required this.imageUrl, @required this.title, @required this.desc, @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context , MaterialPageRoute(
            builder: (context) => ArticleView(
              blogUrl:url,
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl)),
            SizedBox(height: 8,),
            Text(title , style: TextStyle(fontSize: 17,color: Colors.teal ),),
            Text(desc, style: TextStyle( color: Colors.black54)),
          ],
        ),

      ),
    );
  }
}
