import 'package:Prism/data/pexels/provider/pexels.dart';
import 'package:Prism/data/wallhaven/provider/wallhaven.dart';
import 'package:Prism/routing_constants.dart';
import 'package:Prism/theme/jam_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimized_cached_image/widgets.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class WallpaperScreen extends StatefulWidget {
  final List arguements;
  WallpaperScreen({@required this.arguements});
  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String provider;
  int index;
  String link;

  bool isLoading = true;
  PaletteGenerator paletteGenerator;
  List<Color> colors;

  Future<void> _updatePaletteGenerator() async {
    setState(() {
      isLoading = true;
    });
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      new NetworkImage(link),
      maximumColorCount: 20,
    );
    setState(() {
      isLoading = false;
    });
    colors = paletteGenerator.colors.toList();
    if (paletteGenerator.colors.length > 5) {
      colors = colors.sublist(0, 5);
    }
  }

  @override
  void initState() {
    super.initState();
    provider = widget.arguements[0];
    index = widget.arguements[1];
    link = widget.arguements[2];
    isLoading = true;
    _updatePaletteGenerator();
  }

  void _showBottomSheetCallback() {
    _scaffoldKey.currentState.showBottomSheet<void>(
      (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF2F2F2F),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .42,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        JamIcons.chevron_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      colors.length,
                      (color) {
                        return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors[color],
                                borderRadius: BorderRadius.circular(500),
                              ),
                              height: MediaQuery.of(context).size.width / 8,
                              width: MediaQuery.of(context).size.width / 8,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              SystemChrome.setEnabledSystemUIOverlays([
                                SystemUiOverlay.top,
                                SystemUiOverlay.bottom
                              ]);
                              Navigator.pushNamed(
                                context,
                                ColorRoute,
                                arguments: [
                                  colors[color]
                                      .toString()
                                      .replaceAll("Color(0xff", "")
                                      .replaceAll(")", ""),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
                provider == "WallHaven"
                    ? Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(35, 0, 35, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                    child: Text(
                                      Provider.of<WallHavenProvider>(context,
                                              listen: false)
                                          .walls[index]
                                          .id
                                          .toString()
                                          .toUpperCase(),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        JamIcons.eye,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${Provider.of<WallHavenProvider>(context, listen: false).walls[index].views.toString()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        JamIcons.heart_f,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${Provider.of<WallHavenProvider>(context, listen: false).walls[index].favorites.toString()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        JamIcons.save,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${double.parse(((double.parse(Provider.of<WallHavenProvider>(context, listen: false).walls[index].file_size.toString()) / 1000000).toString())).toStringAsFixed(2)} MB",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          Provider.of<WallHavenProvider>(
                                                      context,
                                                      listen: false)
                                                  .walls[index]
                                                  .category
                                                  .toString()[0]
                                                  .toUpperCase() +
                                              Provider.of<WallHavenProvider>(
                                                      context,
                                                      listen: false)
                                                  .walls[index]
                                                  .category
                                                  .toString()
                                                  .substring(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          JamIcons.unordered_list,
                                          size: 20,
                                          color: Colors.white70,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        "${Provider.of<WallHavenProvider>(context, listen: false).walls[index].resolution.toString()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        JamIcons.set_square,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        provider.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        JamIcons.database,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : provider == "Pexels"
                        ? Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(35, 0, 35, 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      child: Text(
                                        Provider.of<PexelsProvider>(context, listen: false).wallsP[index].url.toString().replaceAll("https://www.pexels.com/photo/", "").replaceAll("-", " ").replaceAll("/", "").length > 8
                                            ? Provider.of<PexelsProvider>(context, listen: false)
                                                    .wallsP[index]
                                                    .url
                                                    .toString()
                                                    .replaceAll(
                                                        "https://www.pexels.com/photo/", "")
                                                    .replaceAll("-", " ")
                                                    .replaceAll("/", "")[0]
                                                    .toUpperCase() +
                                                Provider.of<PexelsProvider>(context, listen: false)
                                                    .wallsP[index]
                                                    .url
                                                    .toString()
                                                    .replaceAll(
                                                        "https://www.pexels.com/photo/", "")
                                                    .replaceAll("-", " ")
                                                    .replaceAll("/", "")
                                                    .substring(
                                                        1,
                                                        Provider.of<PexelsProvider>(context, listen: false).wallsP[index].url.toString().replaceAll("https://www.pexels.com/photo/", "").replaceAll("-", " ").replaceAll("/", "").length -
                                                            8)
                                            : Provider.of<PexelsProvider>(context, listen: false)
                                                    .wallsP[index]
                                                    .url
                                                    .toString()
                                                    .replaceAll(
                                                        "https://www.pexels.com/photo/", "")
                                                    .replaceAll("-", " ")
                                                    .replaceAll("/", "")[0]
                                                    .toUpperCase() +
                                                Provider.of<PexelsProvider>(context,
                                                        listen: false)
                                                    .wallsP[index]
                                                    .url
                                                    .toString()
                                                    .replaceAll("https://www.pexels.com/photo/", "")
                                                    .replaceAll("-", " ")
                                                    .replaceAll("/", "")
                                                    .substring(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Icon(
                                                JamIcons.camera,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .4,
                                                child: Text(
                                                  Provider.of<PexelsProvider>(
                                                          context,
                                                          listen: false)
                                                      .wallsP[index]
                                                      .photographer
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                JamIcons.set_square,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${Provider.of<PexelsProvider>(context, listen: false).wallsP[index].width.toString()}x${Provider.of<PexelsProvider>(context, listen: false).wallsP[index].height.toString()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                Provider.of<PexelsProvider>(
                                                        context,
                                                        listen: false)
                                                    .wallsP[index]
                                                    .id
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                JamIcons.info,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                provider.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                JamIcons.database,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : provider.length > 6 &&
                                provider.substring(0, 6) == "Colors"
                            ? Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 35, 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          child: Text(
                                            Provider.of<PexelsProvider>(context, listen: false).wallsC[index].url.toString().replaceAll("https://www.pexels.com/photo/", "").replaceAll("-", " ").replaceAll("/", "").length > 8
                                                ? Provider.of<PexelsProvider>(context, listen: false)
                                                        .wallsC[index]
                                                        .url
                                                        .toString()
                                                        .replaceAll(
                                                            "https://www.pexels.com/photo/", "")
                                                        .replaceAll("-", " ")
                                                        .replaceAll("/", "")[0]
                                                        .toUpperCase() +
                                                    Provider.of<PexelsProvider>(context, listen: false)
                                                        .wallsC[index]
                                                        .url
                                                        .toString()
                                                        .replaceAll(
                                                            "https://www.pexels.com/photo/", "")
                                                        .replaceAll("-", " ")
                                                        .replaceAll("/", "")
                                                        .substring(
                                                            1,
                                                            Provider.of<PexelsProvider>(context, listen: false).wallsC[index].url.toString().replaceAll("https://www.pexels.com/photo/", "").replaceAll("-", " ").replaceAll("/", "").length -
                                                                8)
                                                : Provider.of<PexelsProvider>(context, listen: false)
                                                        .wallsC[index]
                                                        .url
                                                        .toString()
                                                        .replaceAll(
                                                            "https://www.pexels.com/photo/", "")
                                                        .replaceAll("-", " ")
                                                        .replaceAll("/", "")[0]
                                                        .toUpperCase() +
                                                    Provider.of<PexelsProvider>(
                                                            context,
                                                            listen: false)
                                                        .wallsC[index]
                                                        .url
                                                        .toString()
                                                        .replaceAll("https://www.pexels.com/photo/", "")
                                                        .replaceAll("-", " ")
                                                        .replaceAll("/", "")
                                                        .substring(1),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Icon(
                                                    JamIcons.camera,
                                                    size: 20,
                                                    color: Colors.white70,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .4,
                                                    child: Text(
                                                      Provider.of<PexelsProvider>(
                                                              context,
                                                              listen: false)
                                                          .wallsC[index]
                                                          .photographer
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(
                                                    JamIcons.set_square,
                                                    size: 20,
                                                    color: Colors.white70,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "${Provider.of<PexelsProvider>(context, listen: false).wallsC[index].width.toString()}x${Provider.of<PexelsProvider>(context, listen: false).wallsC[index].height.toString()}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text(
                                                    Provider.of<PexelsProvider>(
                                                            context,
                                                            listen: false)
                                                        .wallsC[index]
                                                        .id
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    JamIcons.info,
                                                    size: 20,
                                                    color: Colors.white70,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Pexels",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    JamIcons.database,
                                                    size: 20,
                                                    color: Colors.white70,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 35, 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 10),
                                            child: Text(
                                              Provider.of<WallHavenProvider>(
                                                      context,
                                                      listen: false)
                                                  .wallsS[index]
                                                  .id
                                                  .toString()
                                                  .toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                JamIcons.eye,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${Provider.of<WallHavenProvider>(context, listen: false).wallsS[index].views.toString()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                JamIcons.heart_f,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${Provider.of<WallHavenProvider>(context, listen: false).wallsS[index].favorites.toString()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                JamIcons.save,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "${double.parse(((double.parse(Provider.of<WallHavenProvider>(context, listen: false).wallsS[index].file_size.toString()) / 1000000).toString())).toStringAsFixed(2)} MB",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  Provider.of<WallHavenProvider>(
                                                              context,
                                                              listen: false)
                                                          .wallsS[index]
                                                          .category
                                                          .toString()[0]
                                                          .toUpperCase() +
                                                      Provider.of<WallHavenProvider>(
                                                              context,
                                                              listen: false)
                                                          .wallsS[index]
                                                          .category
                                                          .toString()
                                                          .substring(1),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                                SizedBox(width: 10),
                                                Icon(
                                                  JamIcons.unordered_list,
                                                  size: 20,
                                                  color: Colors.white70,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                "${Provider.of<WallHavenProvider>(context, listen: false).wallsS[index].resolution.toString()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                JamIcons.set_square,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                provider
                                                        .toString()[0]
                                                        .toUpperCase() +
                                                    provider
                                                        .toString()
                                                        .substring(1),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                JamIcons.search,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print("Download");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.25),
                                  blurRadius: 4,
                                  offset: Offset(0, 4))
                            ],
                            borderRadius: BorderRadius.circular(500),
                          ),
                          padding: EdgeInsets.all(17),
                          child: Icon(
                            JamIcons.download,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Wallpaper");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.25),
                                  blurRadius: 4,
                                  offset: Offset(0, 4))
                            ],
                            borderRadius: BorderRadius.circular(500),
                          ),
                          padding: EdgeInsets.all(17),
                          child: Icon(
                            JamIcons.layers,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Fav");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.25),
                                  blurRadius: 4,
                                  offset: Offset(0, 4))
                            ],
                            borderRadius: BorderRadius.circular(500),
                          ),
                          padding: EdgeInsets.all(17),
                          child: Icon(
                            JamIcons.heart,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    try {
      return provider == "WallHaven"
          ? Scaffold(
              key: _scaffoldKey,
              backgroundColor:
                  isLoading ? Theme.of(context).primaryColor : colors[0],
              body: Stack(
                children: <Widget>[
                  OptimizedCacheImage(
                    imageUrl: Provider.of<WallHavenProvider>(context)
                        .walls[index]
                        .path,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            isLoading
                                ? Theme.of(context).accentColor
                                : colors[0].computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      child: Center(
                        child: Icon(
                          JamIcons.close_circle_f,
                          color: isLoading
                              ? Theme.of(context).accentColor
                              : colors[0].computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Color(0xFF2F2F2F)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 20,
                          child: Center(
                            child: Icon(
                              JamIcons.chevron_up,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: !isLoading ? _showBottomSheetCallback : () {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: isLoading
                            ? Theme.of(context).accentColor
                            : colors[0].computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                        icon: Icon(
                          JamIcons.chevron_left,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : provider == "Pexels"
              ? Scaffold(
                  key: _scaffoldKey,
                  backgroundColor:
                      isLoading ? Theme.of(context).primaryColor : colors[0],
                  body: Stack(
                    children: <Widget>[
                      OptimizedCacheImage(
                        imageUrl: Provider.of<PexelsProvider>(context)
                            .wallsP[index]
                            .src["portrait"],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                isLoading
                                    ? Theme.of(context).accentColor
                                    : colors[0].computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          child: Center(
                            child: Icon(
                              JamIcons.close_circle_f,
                              color: isLoading
                                  ? Theme.of(context).accentColor
                                  : colors[0].computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: Color(0xFF2F2F2F)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 20,
                              child: Center(
                                child: Icon(
                                  JamIcons.chevron_up,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          onTap: !isLoading ? _showBottomSheetCallback : () {},
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: isLoading
                                ? Theme.of(context).accentColor
                                : colors[0].computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                            icon: Icon(
                              JamIcons.chevron_left,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : provider.length > 6 && provider.substring(0, 6) == "Colors"
                  ? Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: isLoading
                          ? Theme.of(context).primaryColor
                          : colors[0],
                      body: Stack(
                        children: <Widget>[
                          OptimizedCacheImage(
                            imageUrl: Provider.of<PexelsProvider>(context)
                                .wallsC[index]
                                .src["portrait"],
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    isLoading
                                        ? Theme.of(context).accentColor
                                        : colors[0].computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              child: Center(
                                child: Icon(
                                  JamIcons.close_circle_f,
                                  color: isLoading
                                      ? Theme.of(context).accentColor
                                      : colors[0].computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Color(0xFF2F2F2F)),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Center(
                                    child: Icon(
                                      JamIcons.chevron_up,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onTap:
                                  !isLoading ? _showBottomSheetCallback : () {},
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: isLoading
                                    ? Theme.of(context).accentColor
                                    : colors[0].computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white,
                                icon: Icon(
                                  JamIcons.chevron_left,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: isLoading
                          ? Theme.of(context).primaryColor
                          : colors[0],
                      body: Stack(
                        children: <Widget>[
                          OptimizedCacheImage(
                            imageUrl: Provider.of<WallHavenProvider>(context)
                                .wallsS[index]
                                .path,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    isLoading
                                        ? Theme.of(context).accentColor
                                        : colors[0].computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              child: Center(
                                child: Icon(
                                  JamIcons.close_circle_f,
                                  color: isLoading
                                      ? Theme.of(context).accentColor
                                      : colors[0].computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Color(0xFF2F2F2F)),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  child: Center(
                                    child: Icon(
                                      JamIcons.chevron_up,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onTap:
                                  !isLoading ? _showBottomSheetCallback : () {},
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: isLoading
                                    ? Theme.of(context).accentColor
                                    : colors[0].computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white,
                                icon: Icon(
                                  JamIcons.chevron_left,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
    } catch (e) {
      print(e.toString());
      Navigator.pop(context);
      return Container();
    }
  }
}