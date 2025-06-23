import 'package:flutter/material.dart';
import 'dart:ui';
import '../halaman_validasi/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../voucher/ml_topup_page.dart';
import '../voucher/ff_topup_page.dart';
import '../voucher/pubg_topup_page.dart';
import '../voucher/gi_topup_page.dart';
import '../voucher/valo_topup_page.dart';
import '../voucher/sg_topup_page.dart';
import '../voucher/spotify_topup_page.dart';
import '../voucher/netflix_topup_page.dart';

class HomePage extends StatelessWidget {
  final String fullName;

  const HomePage({Key? key, required this.fullName}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data session/login

    // Navigasi kembali ke halaman Welcome/Login
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF0D47A1);

    final List<Map<String, String>> vouchers = [
      {'name': 'Mobile Legends', 'image': 'assets/images/ml.png'},
      {'name': 'Free Fire', 'image': 'assets/images/ff.png'},
      {'name': 'PUBG Mobile', 'image': 'assets/images/pubg.png'},
      {'name': 'Genshin Impact', 'image': 'assets/images/gi.png'},
      {'name': 'Valorant', 'image': 'assets/images/valo.png'},
      {'name': 'Stumble Guys', 'image': 'assets/images/stumble.png'},
      {'name': 'Spotify', 'image': 'assets/images/spotify.png'},
      {'name': 'Netflix', 'image': 'assets/images/netflix.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Voucher Game',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout(context),
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                // Pastikan fit: BoxFit.cover agar gambar mengisi seluruh area
                Image.asset('assets/images/cuan.png', fit: BoxFit.cover),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 60.0,
                left: 16.0,
                right: 16.0,
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vouchers.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (context, index) {
                      final String label = vouchers[index]['name']!;
                      final String imagePath = vouchers[index]['image']!;

                      return GestureDetector(
                        onTap: () {
                          // Jika hanya Mobile Legends yang ingin diarahkan:
                          if (label == 'Mobile Legends') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MLTopUpPage(
                                  // Jika ingin mengarahkan ke halaman TopUpPage dengan parameter gameName:
                                  // gameName: label,
                                ),
                              ),
                            );
                            // Jika ingin mengarahkan ke halaman TopUpPage dengan parameter gameName:
                          } else {
                            debugPrint('Tapped on \$label');
                          }
                          if (label == 'Free Fire') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FFTopUpPage(),
                              ),
                            );
                          }
                          if (label == 'PUBG Mobile') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PUBGTopUpPage(),
                              ),
                            );
                          }
                          if (label == 'Genshin Impact') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GITopUpPage(),
                              ),
                            );
                          }
                          if (label == 'Valorant') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VALOTopUpPage(),
                              ),
                            );
                          }
                          if (label == 'Stumble Guys') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SGTopUpPage(),
                              ),
                            );
                          }
                          if (label == 'Spotify') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SFTopUpPage(),
                              ),
                            );
                          }
                          if (label == 'Netflix') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NFTopUpPage(),
                              ),
                            );
                          }

                          // --------- OR (jika TopUpPage menerima parameter gameName) ---------
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => TopUpPage(gameName: label)),
                          // );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.redAccent,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.15),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 30,
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 12,
                                right: 12,
                                child: Text(
                                  label,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        color: Colors.black54,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    'Halo, $fullName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
