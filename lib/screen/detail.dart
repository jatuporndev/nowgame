import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:nowgame/data/model/GameInfo.dart';
import 'package:nowgame/repository/GameRepository.dart';

class Detail extends StatefulWidget {
  final int id;
  const Detail(this.id, {Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<GameInfo> futureGameInfo;


  @override
  void initState() {
    super.initState();
    futureGameInfo = GameRepository().fetchGameInfoById(widget.id);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: SingleChildScrollView (
          child: Column(
            children: [
              Stack(
                children: [
                  FutureBuilder<GameInfo>(
                    future: futureGameInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
                        );
                      } else if (snapshot.hasData) {
                        GameInfo? gameInfo = snapshot.data;
                        return Column (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: gameInfo!.thumbnail,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              placeholder: (context, url) => ClipRRect(
                                child: Image.asset('assets/images/thumbnail.jpg'),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            SizedBox(height: 16,),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(gameInfo.title,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 28),),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 4,
                                alignment: WrapAlignment.start,
                                children: [
                                  DetailCard(gameInfo.developer, "Developer"),
                                  DetailCard(gameInfo.publisher,"Publisher"),
                                  DetailCard(gameInfo.releaseDate,"Release"),
                                  DetailCard(gameInfo.genre,"Genre"),
                                  DetailCard(gameInfo.platform,"Platform"),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 24,right: 24),
                                child: ExpandableText(
                                  gameInfo.description,style: TextStyle(color: Colors.white),
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 3,
                                  linkColor: Colors.amber,
                                )),
                            Padding(
                              padding: EdgeInsets.only(left: 16,top: 18,bottom: 8),
                              child: Text("Minimum System Requirements",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),

                            ),
                            Padding(
                              padding:EdgeInsets.only(left: 16,right: 16),
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.amberAccent
                                  ),
                                  child: Column(
                                    children: [
                                      rowSystemReq(gameInfo.minimumSystemRequirements?.os,
                                          "Os:              "),
                                      SizedBox(height: 8),
                                      rowSystemReq(gameInfo.minimumSystemRequirements?.processor,
                                          "Processor:  "),
                                      SizedBox(height: 8),
                                      rowSystemReq(gameInfo.minimumSystemRequirements?.memory,
                                          "Memory:     "),
                                      SizedBox(height: 8),
                                      rowSystemReq(gameInfo.minimumSystemRequirements?.graphics,
                                          "Graphics:    "),
                                      SizedBox(height: 8),
                                      rowSystemReq(gameInfo.minimumSystemRequirements?.storage,
                                          "Storage:     "),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16,top: 18,bottom: 8),
                              child: Text("Screen Shots",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                            ),
                            CarouselSlider(
                              options: CarouselOptions(autoPlay: false,
                                  viewportFraction: 0.9,
                                  aspectRatio: 2.0,
                                  initialPage: 4),
                              items: gameInfo.screenshots.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          color: Colors.amber
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: i.image,
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width,
                                        placeholder: (context, url) => ClipRRect(
                                          child: Image.asset('assets/images/thumbnail.jpg'),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16,)
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No data available.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    },
                  ),
                  buildPositioned(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowSystemReq(String? system, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Flexible(
          child: Text(
            system ?? "-",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Container DetailCard(String developer,String title) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white12
        ),
        child: Column(
          children: [
            Text(title,style: TextStyle(color: Colors.white),),
            Text(developer,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
          ],
        )
    );
  }

  Positioned buildPositioned(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
