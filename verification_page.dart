import 'package:cuan_store/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final String phone;
  final String fullName;

  const VerificationPage({Key? key, required this.email, required this.phone, required this.fullName})
    : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  late AnimationController _timerController;
  List<bool> _selection = [true, false]; // [Email, SMS]

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    )..reverse(from: 1);
  }

  @override
  void dispose() {
    _timerController.dispose();
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  String get _timerText {
    final seconds =
        (_timerController.duration! * _timerController.value).inSeconds;
    final display = seconds.toString().padLeft(2, '0');
    return '00:$display';
  }

  String get _selectedDestination {
    return _selection[0] ? widget.email : widget.phone;
  }

  void _toggleMethod(int index) {
    setState(() {
      for (int i = 0; i < _selection.length; i++) {
        _selection[i] = i == index;
      }
      // reset timer when method changes
      _timerController.reset();
      _timerController.reverse(from: 1);
    });
  }

  void _resendCode() {
    if (_timerController.isAnimating) return;
    // TODO: trigger resend logic to _selectedDestination
    _timerController.reset();
    _timerController.reverse(from: 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode verifikasi dikirim ulang ke $_selectedDestination'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _submit() {
    final code = _controllers.map((c) => c.text).join();
    // TODO: verify code
    if (code == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verifikasi berhasil'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(fullName: widget.fullName)),
        );
        // Navigate to home page or next step
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode salah, coba lagi'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade800, Colors.deepPurple.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, size: 80, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Verifikasi Kode',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      isSelected: _selection,
                      onPressed: _toggleMethod,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Email'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('SMS'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Masukkan kode yang kami kirim ke $_selectedDestination',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: size.width * 0.15,
                                  child: TextField(
                                    controller: _controllers[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      if (val.isNotEmpty && index < 3) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 24),
                            AnimatedBuilder(
                              animation: _timerController,
                              builder: (context, child) {
                                return Text(
                                  _timerText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 12),
                            TextButton(
                              onPressed: _resendCode,
                              child: Text('Kirim Ulang Kode'),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _submit,
                              child: Center(
                                child: Text(
                                  'Lanjutkan',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
