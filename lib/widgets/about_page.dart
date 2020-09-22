import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:zeronet/others/donation_const.dart';

import '../imports.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        uiStore.updateCurrentAppRoute(AppRoute.Home);
        return Future.value(false);
      },
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(24)),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZeroNetAppBar(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          width: 100.0,
                          height: 100.0,
                        ),
                        Padding(padding: const EdgeInsets.all(8.0)),
                        Flexible(
                          child: Container(
                            child: Text(
                              'ZeroNet Mobile is a full native client for ZeroNet, a platform for decentralized websites using Bitcoin ',
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text.rich(
                        TextSpan(
                          text:
                              'crypto and the BitTorrent network. you can learn more about ZeroNet at ',
                          style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'https://zeronet.io/',
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: Color(0xFF8663FF),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch('https://zeronet.io/');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                    ),
                    DeveloperWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    DonationWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text(
                      'Contribute',
                      style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                    ),
                    Text(
                      "If you want to support project's further development, you can contribute your time or money, If you want to contribute money you can send bitcoin or other supported crypto currencies to above addresses or buy in-app purchases, if want to contribute translations or code, visit official GitHub repo.",
                      style: GoogleFonts.roboto(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DonationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donation Addresses',
          style: GoogleFonts.roboto(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
        ),
        LayoutBuilder(
          builder: (ctx, cons) {
            List<Widget> children = [];
            for (var crypto in donationsAddressMap.keys) {
              children.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto,
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
                      ),
                    ),
                    ClickableTextWidget(
                      text: donationsAddressMap[crypto],
                      textStyle: GoogleFonts.roboto(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xFF8663FF),
                        decoration: TextDecoration.underline,
                      ),
                      onClick: () =>
                          FlutterClipboard.copy(donationsAddressMap[crypto]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                    )
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );
          },
        ),
        Flexible(
          child: Text(
            "* Click on Address to copy",
            style: GoogleFonts.roboto(
              fontSize: 16.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Flexible(
          child: Text(
            "* Any Donation can activate all pro-features in app, "
            "these are just an encouragement to me to work more on the app. "
            "Pro-features will be made available to general public after certain time, "
            "thus you don't need to worry about exclusiveness of a feature. "
            "If you purchase from any source other than Google Play Purchase, "
            "just send your transaction id to canews.in@gmail.com / ZeroMail: zeromepro, "
            "so than I can send activation code to activate pro-features.",
            style: GoogleFonts.roboto(
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }
}

class DeveloperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Developers',
          style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(padding: const EdgeInsets.all(4.0)),
        LayoutBuilder(
          builder: (ctx, cons) {
            List<Widget> children = [];
            for (var developer in appDevelopers) {
              children.add(
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                ExactAssetImage(developer.profileIconLink),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                developer.name + '(${developer.developerType})',
                                style: GoogleFonts.roboto(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              LayoutBuilder(builder: (context, cons) {
                                List<Widget> children = [];
                                final iconsPath = 'assets/icons';
                                List<String> assets = [
                                  '$iconsPath/github_dark.png',
                                  '$iconsPath/twitter_dark.png',
                                  '$iconsPath/facebook_dark.png',
                                ];
                                List<String> links = [
                                  developer.githubLink,
                                  developer.twitterLink,
                                  developer.facebookLink,
                                ];
                                for (var item in assets) {
                                  children.add(InkWell(
                                    onTap: () {
                                      var i = assets.indexOf(item);
                                      launch(links[i]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        item,
                                        height: 30.0,
                                        width: 30.0,
                                      ),
                                    ),
                                  ));
                                }
                                return Row(
                                  children: children,
                                );
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: children,
            );
          },
        ),
      ],
    );
  }
}
