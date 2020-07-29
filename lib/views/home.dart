import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternewsapp/helper/category_data.dart';
import 'package:flutternewsapp/helper/news_data.dart';
import 'package:flutternewsapp/models/article_model.dart';
import 'package:flutternewsapp/models/category_model.dart';
import 'package:flutternewsapp/views/article_view.dart';
import 'package:flutternewsapp/views/category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    //articles = getNews();   This we cant do directly as done for categories because this one works as async , and we cant make initState() as async. That is why the function getNews is made below
    getNews();
  }

  getNews() async{
    News newsObj = News();
    await newsObj.getNews();
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
      body: _loading ? Center(child: Container(child: CircularProgressIndicator(),))
          :SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            ///Categories
            Container(
              padding: EdgeInsets.only(top: 10 ),
              height: 70,
              child: ListView.builder(
                itemCount: categories.length,
                  shrinkWrap: true,  //use Shrinkwrap whenever use column
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context , index){
                    return CategoryTile(
                      imageUrl: categories[index].imageUrl,
                      categoryName: categories[index].categoryName ,
                    );
                  }),
            ),

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
        )
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {

  final String imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryNews(
            category: categoryName.toLowerCase(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 19),
        child: Stack(
          children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(imageUrl:imageUrl, width: 120 , height: 60, fit: BoxFit.cover,)
              ),
            Container(
              alignment: Alignment.center,
              width: 120 , height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),
                color: Colors.black26,),
              child: Text(categoryName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 15),
              ),
            )
          ],
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
            SizedBox(height: 8,),
          ],
        ),

      ),
    );
  }
}
