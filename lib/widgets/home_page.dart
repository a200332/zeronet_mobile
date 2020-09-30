import '../imports.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgo;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(24)),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Column(
                children: <Widget>[
                  ZeroNetAppBar(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                  ZeroNetStatusWidget(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  PopularZeroNetSites(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  InAppUpdateWidget(),
                  if (kIsPlayStoreInstall)
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                  if (kIsPlayStoreInstall) RatingButtonWidget(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  AboutButtonWidget(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InAppUpdateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (uiStore.appUpdate != AppUpdate.NOT_AVAILABLE)
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'App Update Available : ',
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            RaisedButton(
              onPressed: uiStore.appUpdate.action,
              color: Color(0xFF008297),
              padding: EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Observer(builder: (context) {
                return Text(
                  uiStore.appUpdate.text,
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ],
        );
      return Container();
    });
  }
}

class AboutButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => uiStore.updateCurrentAppRoute(AppRoute.AboutPage),
      color: Color(0xFFAA5297),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        'Know More',
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RatingButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        final InAppReview inAppReview = InAppReview.instance;
        //TODO: remove this once we support non playstore reviews.
        if (await inAppReview.isAvailable() && kIsPlayStoreInstall) {
          inAppReview.requestReview();
        } else {
          //TODO: Handle this case. eg: Non-PlayStore Install, Already Reviewed Users etc.
        }
      },
      color: Color(0xFF008297),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        'Give Your Rating/Feedback',
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ZeroNetStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Text(
              'Status',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Observer(
              builder: (context) {
                return Chip(
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      uiStore.zeroNetStatus.message,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: uiStore.zeroNetStatus.statusChipColor,
                );
              },
            ),
            Spacer(
              flex: 1,
            ),
            Observer(builder: (context) {
              return InkWell(
                onTap: uiStore.zeroNetStatus.onAction,
                child: Chip(
                  elevation: 8.0,
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      uiStore.zeroNetStatus.actionText,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: uiStore.zeroNetStatus.actionBtnColor,
                ),
              );
            }),
            if (uiStore.zeroNetStatus == ZeroNetStatus.ERROR)
              Spacer(
                flex: 1,
              ),
            if (uiStore.zeroNetStatus == ZeroNetStatus.ERROR)
              InkWell(
                onTap: ZeroNetStatus.NOT_RUNNING.onAction,
                child: Chip(
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      ZeroNetStatus.NOT_RUNNING.actionText,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  backgroundColor: ZeroNetStatus.NOT_RUNNING.actionBtnColor,
                ),
              ),
            Spacer(
              flex: 4,
            ),
          ],
        ),
      ],
    );
  }
}

class PopularZeroNetSites extends StatelessWidget {
  const PopularZeroNetSites({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> zeroSites = [];
    List<String> siteKeys = Utils.initialSites.keys.toList();
    siteKeys.sort((item1, item2) {
      bool isZite1Exists = isZiteExitsLocally(
        Utils.initialSites[item1]['btcAddress'],
      );
      return isZite1Exists ? -1 : 1;
    });
    for (var key in siteKeys) {
      var name = key;
      zeroSites.add(
        SiteDetailCard(name: name),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Popular Sites',
                    style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 3,
                  width: 120,
                  color: Color(0xFF2B2BFF),
                )
              ],
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          children: zeroSites,
          physics: BouncingScrollPhysics(),
        )
        // wgt,
      ],
    );
  }
}

class SiteDetailCard extends StatelessWidget {
  const SiteDetailCard({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    bool isZiteExists = isZiteExitsLocally(
      Utils.initialSites[name]['btcAddress'],
    );
    return Card(
      shadowColor: Color(0x52000000),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      margin: EdgeInsets.only(bottom: 14.0),
      child: Container(
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 16.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      size: 28,
                      color: Color(0xFF5A53FF),
                    ),
                    onPressed: () {
                      uiStore.currentBottomSheetController = showBottomSheet(
                        context: context,
                        elevation: 16.0,
                        builder: (ctx) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            constraints: BoxConstraints(
                              minHeight: 300.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                ),
                                Container(
                                  height: 5.0,
                                  width: 80.0,
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5A53FF),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SiteDetailsSheet(name),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  InkWell(
                    child: Icon(
                      isZiteExists ? Icons.play_arrow : Icons.file_download,
                      size: 36,
                      color: Color(isZiteExists ? 0xFF6EB69E : 0xDF6EB69E),
                    ),
                    onTap: uiStore.zeroNetStatus == ZeroNetStatus.NOT_RUNNING
                        ? () {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please Start ZeroNet First to Browse this Zite',
                                ),
                              ),
                            );
                          }
                        : () {
                            browserUrl =
                                zeroNetUrl + Utils.initialSites[name]['url'];
                            uiStore.updateCurrentAppRoute(AppRoute.ZeroBrowser);
                          },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SiteDetailsSheet extends StatelessWidget {
  SiteDetailsSheet(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    List<String> sites = sitesAvailable.keys
        .toList()
        .where((element) => element == Utils.initialSites[name]['btcAddress'])
        .toList();
    Site currentSite = Site();
    if (sites.length > 0) {
      currentSite = sitesAvailable[sites[0]]
        ..address = Utils.initialSites[name]['btcAddress'];
      uiStore.updateCurrentSiteInfo(
        SiteInfo().fromSite(currentSite),
      );
    }
    bool isZiteExists = isZiteExitsLocally(
      Utils.initialSites[name]['btcAddress'],
    );
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 31.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Color(0xFF5A53FF),
                      ),
                      onPressed: () => Share.share(
                        Utils.initialSites[name]['url'],
                      ),
                    ),
                    Observer(builder: (context) {
                      return RaisedButton(
                        color: Color(0xFF009764),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: uiStore.zeroNetStatus ==
                                ZeroNetStatus.NOT_RUNNING
                            ? () {
                                snackMessage =
                                    'Please Start ZeroNet First to Browse this Zite';
                                uiStore.updateShowSnackReply(true);
                              }
                            : () {
                                browserUrl = zeroNetUrl +
                                    Utils.initialSites[name]['url'];
                                uiStore.currentBottomSheetController?.close();
                                uiStore.updateCurrentAppRoute(
                                  AppRoute.ZeroBrowser,
                                );
                              },
                        child: Text(
                          isZiteExists ? 'OPEN' : 'DOWNLOAD',
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(6.0)),
            Text(
              Utils.initialSites[name]['description'],
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            Padding(padding: EdgeInsets.all(6.0)),
            Wrap(
              spacing: 16.0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                RaisedButton(
                  color: Color(0xFF008297),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () async {
                    File logoFile = File(getZeroNetDataDir().path +
                        "/${Utils.initialSites[name]['btcAddress']}/img/logo.png");
                    String logoPath = '';
                    if (logoFile.existsSync()) {
                      logoPath = logoFile.path;
                    } else {
                      //TODO: Default logo quality is very low, use inbuilt logo for this.
                    }
                    var added = await addToHomeScreen(
                      name,
                      Utils.initialSites[name]['url'],
                      logoPath,
                    );
                    if (added) {
                      snackMessage = '$name shortcut added to  HomeScreen';
                      uiStore.updateShowSnackReply(true);
                    }
                  },
                  child: Text(
                    'Add to HomeScreen',
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isZiteExists)
                  RaisedButton(
                    color: Color(0xFF517184),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      uiStore.currentBottomSheetController?.close();
                      uiStore.updateCurrentAppRoute(AppRoute.LogPage);
                    },
                    child: Text(
                      'Show Log',
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (!unImplementedFeatures.contains(Feature.SITE_PAUSE_RESUME))
                  if (isZiteExists && currentSite != null)
                    RaisedButton(
                      color: Color(0xFF009793),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        //TODO: Implement this function;
                        currentSite = (currentSite.serving)
                            ? currentSite.pause()
                            : currentSite.resume();
                        sitesAvailable[currentSite.address] = currentSite;
                        SiteManager().saveSettingstoFile(
                            File(getZeroNetDataDir().path + '/sites.json'),
                            sitesAvailable);
                      },
                      child: Text(
                        currentSite.serving ? 'Pause' : 'Resume',
                        maxLines: 1,
                        style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                if (!unImplementedFeatures.contains(Feature.SITE_DELETE))
                  if (isZiteExists && currentSite != null)
                    RaisedButton(
                      color: Color(0xFFBB4848),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        //TODO: Implement this function;
                      },
                      child: Text(
                        'Delete Zite',
                        maxLines: 1,
                        style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
              ],
            ),
            Padding(padding: EdgeInsets.all(6.0)),
            if (isZiteExists)
              Observer(builder: (context) {
                return SiteInfoWidget(
                  uiStore.currentSiteInfo,
                );
              }),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Observer(builder: (context) {
            Timer(Duration(seconds: 3), () {
              uiStore.updateShowSnackReply(false);
            });
            return uiStore.showSnackReply
                ? Container(
                    height: 50.0,
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          snackMessage,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Container();
          }),
        ),
      ],
    );
  }
}

class SiteInfoWidget extends StatelessWidget {
  final SiteInfo siteInfo;
  const SiteInfoWidget(this.siteInfo);
  @override
  Widget build(BuildContext context) {
    List<Widget> infoTitleWgts = [];
    List<Widget> infoWgts = [];
    for (var item in siteInfo.propStrings..remove('files')) {
      final i = siteInfo.propStrings.indexOf(item);
      infoTitleWgts.add(
        Text(
          siteInfo.propStrings[i].inCaps,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      if (siteInfo.props[i] != null) {
        String details = (siteInfo.props[i] is DateTime)
            ? timeAgo.format(siteInfo.props[i])
            : siteInfo.props[i].toString();
        if (item == 'size') {
          details = ((siteInfo.props[i] as int) ~/ 1000).toString() +
                  ' KB ($details Bytes)'
              //TODO : Enable this when we read sites content.json file.
              // +' (' +
              // siteInfo.props[siteInfo.propStrings.indexOf('files')].toString() +
              // ' Files)'
              ;
        } else if (siteInfo.props[i] is DateTime) {
          DateTime t = siteInfo.props[i];
          details = details + ' (${t.day}/${t.month}/${t.year})';
        }
        infoWgts.add(
          Text(
            '  :  ' + details,
            style: GoogleFonts.roboto(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SiteInfo',
          style: GoogleFonts.roboto(
            fontSize: 21.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(padding: EdgeInsets.all(2.0)),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []..addAll(infoTitleWgts),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: []..addAll(infoWgts),
            ),
          ],
        )
      ],
    );
  }
}
