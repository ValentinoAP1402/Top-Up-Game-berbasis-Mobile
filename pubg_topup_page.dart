import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../halaman_validasi/invoice_page.dart'; // untuk FilteringTextInputFormatter

void main() {
  runApp(MaterialApp(home: PUBGTopUpPage()));
}

class PUBGTopUpPage extends StatefulWidget {
  const PUBGTopUpPage({super.key});
  @override
  _PUBGTopUpPageState createState() => _PUBGTopUpPageState();
}

class _PUBGTopUpPageState extends State<PUBGTopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  String? _selectedDiamondLabel;
  String? _selectedDiamondPrice;
  String? _selectedPayment;
  final _emailController = TextEditingController();

  final List<Map<String, String>> diamonds = [
    {"label": "30 UC", "price": "Rp. 7.000"},
    {"label": "60 UC", "price": "Rp. 14.000"},
    {"label": "300+25 UC", "price": "Rp. 70.000"},
    {"label": "600+60 UC", "price": "Rp. 140.000"},
    {"label": "3000+850 UC", "price": "Rp. 700.000"},
    {"label": "3000+850 UC", "price": "Rp. 700.000"},
    {"label": "6000+2100 UC", "price": "Rp. 1.400.000"},
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
              Text("Masukkan ID Pemain: ${_userIdController.text}"),
              Text("UC: $_selectedDiamondLabel"),
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
                // 5) Jika semua validasi berhasil, navigasikan ke halaman invoice
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoicePage(
                      topUpItem: _selectedDiamondLabel ?? "Tidak ada",
                      userInfo: _userIdController.text,
                      orderId: "PUBG-${timestamp}",
                      transactionId: "TX-${timestamp}",
                      orderDate: DateTime.now(),
                      paymentMethod: _selectedPayment ?? "Tidak ada",
                      totalPayment:
                          double.tryParse(
                            _selectedDiamondPrice
                                    ?.replaceAll("Rp. ", "")
                                    .replaceAll(".", "") ??
                                "0",
                          ) ??
                          0.0,
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
      appBar: AppBar(title: Text("Top Up PUBG Mobile")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        // 3) Bungkus formKey pada Form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// =======================
              /// Section: Masukkan ID Pemain PUBG Mobile
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
                      "Masukkan ID Pemain",
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: "Masukkan ID Pemain",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "⚠ Masukkan ID Pemain";
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
                      "Untuk menemukan ID Anda, klik pada ikon karakter. "
                      "User ID tercantum di bawah nama karakter Anda. "
                      "Contoh: '5363266446'.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              /// =======================
              /// Section: Pilih Jumlah UC PUBG
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
                                    'assets/payment/uc.png',
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
