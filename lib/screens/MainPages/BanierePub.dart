import 'dart:io';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/PubService.dart';
import 'package:khedma/entities/Pub.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/Card/ConfirmationNotficationCard.dart';
import '../../components/Card/SuccessNotificationCard.dart';


class BanierePublicitaire extends StatefulWidget {
  const BanierePublicitaire({Key? key}) : super(key: key);
  @override
  _BanierePublicitaireState createState() => _BanierePublicitaireState();
}

class _BanierePublicitaireState extends State<BanierePublicitaire> {
  final Pubservice _pubService = Pubservice();
  final MinIOService minIOService = MinIOService();

  List<Pub> _pubs = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPubs();
  }

  // Future<void> _loadLocationImages() async {
  //   try {
  //     String imagePrefix = 'pub';
  //     print(imagePrefix);
  //     List<String> cleanedImageNames = widgetImages
  //         .map((imageName) => imageName.replaceFirst('pub_', '')) // Enlever 'images_' des noms
  //         .where((imageName) => imageName.startsWith(imagePrefix)) // Filtrer les images par préfixe
  //         .toList();
  //     print(cleanedImageNames);
  //
  //     if (cleanedImageNames.isNotEmpty) {
  //       List<String> downloadedImagePaths = [];
  //       for (String imageName in cleanedImageNames) {
  //         String response = await minIOService.LoadFileFromServer('pubs', imageName);
  //         if (response.isNotEmpty) {
  //           downloadedImagePaths.add(response);
  //         } else {
  //           print('Image non trouvée pour : $imageName');
  //         }
  //       }
  //       if (downloadedImagePaths.isNotEmpty) {
  //         if (mounted) {
  //           setState(() {
  //             imageUrls = downloadedImagePaths;
  //           });
  //         }
  //       } else {
  //         print('Aucune image récupérée pour location ID : ${widget.travailId}');
  //       }
  //     } else {
  //       print('Aucune image correspondant à location ID : ${widget.travailId}');
  //     }
  //   } catch (e) {
  //     print('Erreur lors du chargement des images de la location : $e');
  //   }
  // }

  Future<void> _loadPubs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Pub> pubs = await _pubService.getAllPubs();
      setState(() {
        _pubs = pubs;
        _isLoading = false;
      });


      if (_pubs.isEmpty) {
        print('⚠️ Aucune publicité disponible.');
      } else {
        print('✅ ${_pubs.length} pubs chargées.');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des pubs: $e';
        _isLoading = false;
      });
      print('❌ Erreur lors du chargement des pubs: $e');
    }
  }


  // Méthode pour ouvrir un lien externe
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible d\'ouvrir le lien: $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Bannières Publicitaires',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else if (_errorMessage.isNotEmpty)
            Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
          else
            Container(
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    Pub pub = _pubs[index];
                    return GestureDetector(
                      onTap: () {
                        if (pub.link != null && pub.link!.isNotEmpty) {
                          _launchURL(pub.link!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Aucun lien disponible pour cette publicité.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            // pub.image ??
                                'assets/images/logo.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pub.title ?? 'Titre non disponible',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  pub.description ?? 'Description non disponible',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _pubs.length,
                  autoplay: true,
                  autoplayDelay: 3000,
                  duration: 1000,
                  viewportFraction: 0.9,
                  scale: 0.9,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white.withOpacity(0.5),
                      activeColor: Colors.white,
                      size: 8,
                      activeSize: 10,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}