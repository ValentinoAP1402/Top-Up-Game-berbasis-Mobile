import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../halaman_validasi/invoice_page.dart'; // untuk FilteringTextInputFormatter

void main() {
  runApp(MaterialApp(home: VALOTopUpPage()));
}

class VALOTopUpPage extends StatefulWidget {
  const VALOTopUpPage({super.key});
  @override
  _VALOTopUpPageState createState() => _VALOTopUpPageState();
}

class _VALOTopUpPageState extends State<VALOTopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  String? _selectedDiamondLabel;
  String? _selectedDiamondPrice;
  String? _selectedPayment;
  final _emailController = TextEditingController();

  final List<Map<String, String>> diamonds = [
    {"label": "475 VP", "price": "Rp. 56.000"},
    {"label": "1000 VP", "price": "Rp. 112.000"},
    {"label": "2050 VP", "price": "Rp. 224.000"},
    {"label": "3650 VP", "price": "Rp. 389.000"},
    {"label": "5350 VP", "price": "Rp. 559.000"},
    {"label": "11000 VP", "price": "Rp. 1.099.000"},
  ];

  final List<String> payments = [
    "GoPay",
    "Dana",
    "QRIS",
    "ShopeePay",
    "Bank Transfer",
    "OVO",
    "Indomaret",
    "Telkomsel",
  ];

  final Map<String, String> paymentImages = {
    "GoPay": "assets/payment/gopay.png",
    "Dana": "assets/payment/dana.png",
    "QRIS": "assets/payment/Qris.png",
    "ShopeePay": "assets/payment/ShopeePay.png",
    "Bank Transfer": "assets/payment/Bank.png",
    "OVO": "assets/payment/ovo.png",
    "Indomaret": "assets/payment/indomaret.png",
    "Telkomsel": "assets/payment/telkomsel.png",
  };

  void _showOrderDetails() {
    // 4) Sebelum menampilkan dialog, panggil validate()
    if (_formKey.currentState!.validate()) {
      // Jika semua field valid (tidak kosong), tampilkan detail pesanan
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Detail Pesanan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Masukkan Riot ID Anda: ${_userIdController.text}"),
              Text("VP: $_selectedDiamondLabel"),
              Text("Harga: $_selectedDiamondPrice"),
              Text("Metode Pembayaran: $_selectedPayment"),
              Text("Email: ${_emailController.text}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                // 5) Jika tombol konfirmasi ditekan, navigasi ke halaman invoice
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoicePage(
                      topUpItem: "Top Up Valorant $_selectedDiamondLabel",
                      userInfo: _userIdController.text,
                      orderId: "VALO-${timestamp}",
                      transactionId: "TX-${timestamp}",
                      orderDate: DateTime.now(),
                      paymentMethod: _selectedPayment ?? "Tidak ada",
                      totalPayment: double.parse(
                        _selectedDiamondPrice!
                            .replaceAll("Rp. ", "")
                            .replaceAll(".", ""),
                      ),
                    ),
                  ),
                );
              },
              child: Text("Konfirmasi"),
            ),
          ],
        ),
      );
    }
    // Jika validasi gagal, maka TextFormField yang kosong akan menampilkan border merah & errorText
  }

  Widget _buildPaymentMethodRow(
    String imagePath,
    String price,
    String paymentKey,
  ) {
    final bool isSelected = _selectedPayment == paymentKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = paymentKey;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 36, height: 36),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                paymentKey,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top Up Valorant")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        // 3) Bungkus formKey pada Form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// =======================
              /// Section: Masukkan Riot ID
              /// =======================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Masukkan Riot ID Anda",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 1) Ubah jadi TextFormField untuk User ID
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _userIdController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9#]+$'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: "Masukkan Riot ID Anda",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "⚠ Masukkan Riot ID Anda";
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(width: 12),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Untuk menemukan Riot ID Anda,"
                      "buka halaman profil akun dan salin Riot ID+Tag menggunakan tombol yang tersedia disamping Riot ID."
                      "Contoh: Westbourne#SEA",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              /// =======================
              /// Section: Pilih Jumlah Valorant Points (VP)
              /// =======================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Nominal Top Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...diamonds.map((d) {
                      final label = d["label"]!;
                      final price = d["price"]!;
                      final isSelected = _selectedDiamondLabel == label;
                      return RadioListTile<String>(
                        value: label,
                        groupValue: _selectedDiamondLabel,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blue,
                        title: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/payment/vp.png',
                                    height: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Text(
                                    price,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onChanged: (val) {
                          setState(() {
                            _selectedDiamondLabel = label;
                            _selectedDiamondPrice = price;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),

              /// =======================
              /// Section: Pilih Metode Pembayaran
              /// =======================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Metode Pembayaran",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: payments.map((p) {
                        final price = _selectedDiamondPrice ?? "Rp. 0";
                        final imagePath = paymentImages[p]!;
                        return _buildPaymentMethodRow(imagePath, price, p);
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Tombol Beli Sekarang
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showOrderDetails, // Validasi & tampilkan dialog
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Beli Sekarang", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
