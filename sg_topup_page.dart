import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../halaman_validasi/transaction_page.dart'; // Changed from invoice_page to transaction_page

void main() {
  runApp(MaterialApp(home: SGTopUpPage()));
}

class SGTopUpPage extends StatefulWidget {
  const SGTopUpPage({super.key});
  @override
  _SGTopUpPageState createState() => _SGTopUpPageState();
}

class _SGTopUpPageState extends State<SGTopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  String? _selectedDiamondLabel;
  String? _selectedDiamondPrice;
  String? _selectedPayment;

  // Added scroll controller and keys for validation like ML version
  final _scrollController = ScrollController();
  final _diamondKey = GlobalKey();
  final _paymentKey = GlobalKey();

  final List<Map<String, String>> diamonds = [
    {"label": "5 Gems", "price": "Rp. 1.423"},
    {"label": "12 Gems", "price": "Rp. 3.323"},
    {"label": "19 Gems", "price": "Rp. 5.223"},
    {"label": "28 Gems", "price": "Rp. 7.600"},
    {"label": "44 Gems", "price": "Rp. 11.400"},
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

  // Added scroll to key function like ML version
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

  // Modified validation function to match ML version logic
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
            Text("Username: ${_userIdController.text}"),
            Text("Gems: $_selectedDiamondLabel"),
            Text("Harga: $_selectedDiamondPrice"),
            Text("Metode Pembayaran: $_selectedPayment"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate to transaction page like ML version
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
                    topUpItem: 'Stumble Guys $_selectedDiamondLabel',
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
      appBar: AppBar(title: Text("Top Up Stumble Guys")),
      body: SingleChildScrollView(
        controller: _scrollController, // Added scroll controller
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// =======================
              /// Section: Masukkan Username Anda
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
                      "Masukkan Username Anda",
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
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9_]+$'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: "Masukkan Username Anda",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "⚠ Masukkan Username Anda";
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
                      "Untuk menemukan ID Unik anda, ketuk pada tombol edit nama profil di pojok kiri atas layar utama game."
                      "Di dalam profil anda, anda akan melihat identifikasi unik anda."
                      "Ketuk pada ikon salin di samping ID Unik anda untuk menyalinnya, sehingga anda dapat menempelkannya.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              /// =======================
              /// Section: Pilih Jumlah Gems Stumble Guys
              /// =======================
              Container(
                key: _diamondKey, // Added key for validation
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
                                    'assets/payment/gems.png',
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
                key: _paymentKey, // Added key for validation
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
                  onPressed: _validateAndShowDetails, // Updated function name
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
