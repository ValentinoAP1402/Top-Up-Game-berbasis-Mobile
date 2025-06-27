import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../halaman_validasi/transaction_page.dart'; // Ganti ke transaction_page.dart
// untuk FilteringTextInputFormatter

void main() {
  runApp(MaterialApp(home: FFTopUpPage()));
}

class FFTopUpPage extends StatefulWidget {
  const FFTopUpPage({super.key});
  @override
  _FFTopUpPageState createState() => _FFTopUpPageState();
}

class _FFTopUpPageState extends State<FFTopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  String? _selectedDiamondLabel;
  String? _selectedDiamondPrice;
  String? _selectedPayment;
  final _emailController = TextEditingController();

  // Tambahkan ScrollController dan GlobalKey untuk validasi seperti ML
  final _scrollController = ScrollController();
  final _diamondKey = GlobalKey();
  final _paymentKey = GlobalKey();

  final List<Map<String, String>> diamonds = [
    {"label": "5 Diamonds", "price": "Rp. 1.000"},
    {"label": "12 Diamonds", "price": "Rp. 2.000"},
    {"label": "50 Diamonds", "price": "Rp. 8.000"},
    {"label": "70 Diamonds", "price": "Rp. 10.000"},
    {"label": "140 Diamonds", "price": "Rp. 20.000"},
    {"label": "355 Diamonds", "price": "Rp. 50.000"},
    {"label": "720 Diamonds", "price": "Rp. 100.000"},
    {"label": "1450 Diamonds", "price": "Rp. 200.000"},
    {"label": "2180 Diamonds", "price": "Rp. 300.000"},
    {"label": "3640 Diamonds", "price": "Rp. 500.000"},
    {"label": "7290 Diamonds", "price": "Rp. 1.000.000"},
    {"label": "36500 Diamonds", "price": "Rp. 5.000.000"},
    {"label": "73100 Diamonds", "price": "Rp. 10.000.000"},
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

  // Fungsi untuk scroll ke key tertentu (sama seperti ML)
  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // Ganti fungsi _showOrderDetails dengan _validateAndShowDetails seperti ML
  void _validateAndShowDetails() {
    final formValid = _formKey.currentState?.validate() ?? false;
    bool diamondValid = _selectedDiamondLabel != null;
    bool paymentValid = _selectedPayment != null;

    if (!formValid) return;
    if (!diamondValid) {
      _scrollToKey(_diamondKey);
      setState(() {});
      return;
    }

    if (!paymentValid) {
      _scrollToKey(_paymentKey);
      setState(() {});
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Detail Pesanan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Masukkan Player ID: ${_userIdController.text}"),
            Text("Diamond: $_selectedDiamondLabel"),
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
              Navigator.pop(context); // tutup dialog
              // navigasi ke TransactionPage seperti ML
              final now = DateTime.now();
              final toString = now.millisecondsSinceEpoch.toString();
              final timestamp = toString.substring(toString.length - 6);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionPage(
                    userInfo: _userIdController.text,
                    orderId: now.millisecondsSinceEpoch.toString(),
                    transactionId: 'TXN$timestamp',
                    orderDate: DateTime.now(),
                    paymentMethod: _selectedPayment!,
                    topUpItem: 'Free Fire $_selectedDiamondLabel',
                    totalPayment: double.parse(
                      _selectedDiamondPrice!.replaceAll(RegExp(r'[^0-9]'), ''),
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
      appBar: AppBar(title: Text("Top Up Free Fire")),
      body: SingleChildScrollView(
        controller: _scrollController, // Tambahkan controller
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// =======================
              /// Section: Masukkan Player ID
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
                      "Masukkan Player ID",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                              hintText: "Masukkan Player ID",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "⚠ Masukkan Player ID";
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
              /// Section: Pilih Jumlah Diamonds Free Fire
              /// =======================
              Container(
                key: _diamondKey, // Tambahkan key
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
                                    'assets/payment/diamond.png',
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
                key: _paymentKey, // Tambahkan key
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
                  onPressed: _validateAndShowDetails, // Ganti fungsi
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
