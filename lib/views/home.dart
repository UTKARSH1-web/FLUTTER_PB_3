import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news/helper/data.dart';
import 'package:news/helper/news.dart';
import 'package:news/models/article_model.dart';
import 'package:news/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news/views/article_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState()  {
    //TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:MainAxisAlignment.center ,
          children: <Widget>[
            Text("Daily"),
            Text("News",style: TextStyle(
              color: Colors.blue
            ),)
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body:_loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[

              ///Categories
              Container(
                height: 70,
                child: ListView.builder(
                  itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                    return CategoryTile(
                     imageUrl: categories[index].imageUrl,categoryName:categories[index].categoryName,
                    );
        }),
              ),

              ///Blogs
              Container(
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount: articles.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                    return BlogTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      desc: articles[index].description,
                      url: articles[index].url,
                      author: articles[index].author,
                      de: articles[index].publishedAt,
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
class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl,this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl, width: 120,height: 60,fit: BoxFit.cover,)
            ),
            Container(
              alignment: Alignment.center,
              width: 120,height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26
              ),
              child: Text(categoryName,style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500
              )),
            )
          ],
        ),
      ),
    );
  }
}







class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc,url,author;
  final DateTime de;
  BlogTile({@required this.imageUrl,@required this.title,@required this.author,@required this.desc,@required this.url,@required this.de});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(
              blogUrl: url,
            )
        ));
      },
      child: Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Column(
    children: <Widget>[
      ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: Image.network(imageUrl),
    ),
      SizedBox(height: 8,),
      Text(title,style: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.w500
      ),),
      SizedBox(height: 8,),
      Text(desc,style: TextStyle(
        color: Colors.blueGrey
      ),),
      SizedBox(height: 4,),
      Align(
        alignment: Alignment.topLeft,
        child: Text(de.toString().substring(0,20),
        style: TextStyle(color: Colors.black12),
        ),
      ),
      Align(
          alignment: Alignment.topLeft,
          child: Text(author, style: TextStyle(color: Colors.black12))),
      SizedBox(
        height: 4,
      ),
    ],
    ),
    ));
  }
}
