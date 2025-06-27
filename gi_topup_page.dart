import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk FilteringTextInputFormatter
import '../halaman_validasi/transaction_page.dart'; // Import transaction page

void main() {
  runApp(MaterialApp(home: GITopUpPage()));
}

class GITopUpPage extends StatefulWidget {
  const GITopUpPage({super.key});
  @override
  _GITopUpPageState createState() => _GITopUpPageState();
}

class _GITopUpPageState extends State<GITopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  String? _selectedDiamondLabel;
  String? _selectedDiamondPrice;
  String? _selectedPayment;
  String? _selectedServer;

  /// Daftar server yang akan muncul di dropdown
  final List<String> servers = ['America', 'Asia', 'Europe', 'TW, HK, MO'];

  /// Daftar paket Genshin Crystal (label + harga)
  final List<Map<String, String>> diamonds = [
    {"label": "60 Genshin Crystal", "price": "Rp. 16.500"},
    {"label": "330 Genshin Crystal", "price": "Rp. 81.000"},
    {"label": "1090 Genshin Crystal", "price": "Rp. 255.000"},
    {"label": "2240 Genshin Crystal", "price": "Rp. 489.000"},
    {"label": "3880 Genshin Crystal", "price": "Rp. 815.000"},
    {"label": "8080 Genshin Crystal", "price": "Rp. 1.629.000"},
  ];

  /// Daftar metode pembayaran (nama + asset image)
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

  /// Fungsi untuk menampilkan dialog detail pesanan,
  /// setelah semua field di-form berhasil divalidasi.
  void _showOrderDetails() {
    if (_formKey.currentState!.validate() &&
        _selectedDiamondLabel != null &&
        _selectedPayment != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Detail Pesanan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("UID: ${_userIdController.text}"),
              Text("Server: $_selectedServer"),
              Text("Genshin Crystal: $_selectedDiamondLabel"),
              Text("Harga: $_selectedDiamondPrice"),
              Text("Metode Pembayaran: $_selectedPayment"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup dialog

                // Navigasi ke halaman transaksi seperti di ML
                final now = DateTime.now();
                final toString = now.millisecondsSinceEpoch.toString();
                final timestamp = toString.substring(toString.length - 6);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionPage(
                      userInfo: "${_userIdController.text} ($_selectedServer)",
                      orderId: now.millisecondsSinceEpoch.toString(),
                      transactionId: 'TXN$timestamp',
                      orderDate: DateTime.now(),
                      paymentMethod: _selectedPayment!,
                      topUpItem: 'Genshin Impact $_selectedDiamondLabel',
                      totalPayment: double.parse(
                        _selectedDiamondPrice!.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        ),
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
    // Jika validasi gagal, TextFormField dan Dropdown otomatis menampilkan error
  }

  /// Helper untuk menampilkan tiap baris metode pembayaran
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
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top Up Genshin Impact")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// ==========================
              /// 1. Section: Masukkan UID & Pilih Server
              /// ==========================
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
                      "Masukkan UID dan Pilih Server",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 1a) Field UID
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _userIdController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: "Masukkan UID",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "⚠ Masukkan UID";
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(width: 12),

                        // 1b) Dropdown untuk memilih Server
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _selectedServer,
                            hint: Text("Pilih Server"),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: servers.map((serverName) {
                              return DropdownMenuItem<String>(
                                value: serverName,
                                child: Text(serverName),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedServer = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "⚠ Pilih Server";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Untuk menemukan UID Anda, masuk pakai akun Anda. "
                      "Klik pada tombol profil di pojok kiri atas layar. "
                      "Temukan UID di bawah avatar. Selain itu, "
                      "Anda juga dapat menemukan UID di pojok bawah kanan layar.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              /// ==========================
              /// 2. Section: Pilih Nominal Genshin Crystal
              /// ==========================
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
                      "Pilih Nominal Genshin Crystal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Add validation message for diamond selection
                    if (_selectedDiamondLabel == null &&
                        _formKey.currentState?.validate() == false)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "⚠ Pilih nominal Genshin Crystal",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
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
                                    'assets/payment/gi.png',
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

              /// ==========================
              /// 3. Section: Pilih Metode Pembayaran
              /// ==========================
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
                    // Add validation message for payment selection
                    if (_selectedPayment == null &&
                        _formKey.currentState?.validate() == false)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "⚠ Pilih metode pembayaran",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
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

              /// ==========================
              /// 4. Tombol Beli Sekarang
              /// ==========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showOrderDetails,
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
