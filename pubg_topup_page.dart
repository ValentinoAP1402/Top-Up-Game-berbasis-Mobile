import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../halaman_validasi/transaction_page.dart';
// pastikan path ini sesuai dengan struktur project kamu

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

  final _scrollController = ScrollController();
  final _ucKey = GlobalKey();
  final _paymentKey = GlobalKey();

  final List<Map<String, String>> diamonds = [
    {"label": "30 UC", "price": "Rp. 7.000"},
    {"label": "60 UC", "price": "Rp. 14.000"},
    {"label": "300+25 UC", "price": "Rp. 70.000"},
    {"label": "600+60 UC", "price": "Rp. 140.000"},
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

  void _validateAndShowDetails() {
    final formValid = _formKey.currentState?.validate() ?? false;
    bool ucValid = _selectedDiamondLabel != null;
    bool paymentValid = _selectedPayment != null;

    if (!formValid) return;
    if (!ucValid) {
      _scrollToKey(_ucKey);
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
            Text("ID Pemain: ${_userIdController.text}"),
            Text("UC: $_selectedDiamondLabel"),
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
              Navigator.pop(context); // tutup dialog
              // navigasi ke halaman transaksi
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
                    topUpItem: 'PUBG Mobile $_selectedDiamondLabel',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top Up PUBG Mobile")),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Section: ID Pemain
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
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _userIdController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: "Masukkan ID Pemain",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "⚠ Masukkan ID Pemain"
                          : null,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Untuk menemukan ID Anda, klik pada ikon karakter. "
                      "User ID tercantum di bawah nama karakter Anda. "
                      "Contoh: '5363266446'.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              /// Section: UC
              Container(
                key: _ucKey,
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
                    SizedBox(height: 8),
                    ...diamonds.map((d) {
                      final label = d["label"]!;
                      final price = d["price"]!;
                      return RadioListTile<String>(
                        value: label,
                        groupValue: _selectedDiamondLabel,
                        activeColor: Colors.blue,
                        title: Row(
                          children: [
                            Image.asset('assets/payment/uc.png', height: 24),
                            SizedBox(width: 8),
                            Expanded(child: Text(label)),
                            Text(
                              price,
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                    }),
                  ],
                ),
              ),

              /// Section: Payment
              Container(
                key: _paymentKey,
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
                    SizedBox(height: 8),
                    Column(
                      children: payments.map((p) {
                        final isSelected = _selectedPayment == p;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedPayment = p);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  paymentImages[p]!,
                                  width: 36,
                                  height: 36,
                                ),
                                SizedBox(width: 12),
                                Expanded(child: Text(p)),
                                Text(
                                  _selectedDiamondPrice ?? "Rp. 0",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndShowDetails,
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
