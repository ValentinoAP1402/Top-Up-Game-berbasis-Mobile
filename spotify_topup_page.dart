import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../halaman_validasi/invoice_page.dart'; // untuk FilteringTextInputFormatter

void main() {
  runApp(MaterialApp(home: SFTopUpPage()));
}

class SFTopUpPage extends StatefulWidget {
  const SFTopUpPage({super.key});
  @override
  _SFTopUpPageState createState() => _SFTopUpPageState();
}

class _SFTopUpPageState extends State<SFTopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  String? _selectedDiamondLabel;
  String? _selectedDiamondPrice;
  String? _selectedPayment;

  final List<Map<String, String>> diamonds = [
    {"label": "1 Bulan", "price": "Rp. 54.500"},
    {"label": "3 Bulan", "price": "Rp. 164.000"},
    {"label": "6 Bulan", "price": "Rp. 295.000"},
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
              Text("Voucher: $_selectedDiamondLabel"),
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
                // 5) Jika tombol konfirmasi ditekan, navigasi ke halaman invoice
                final orderId = "SF-${timestamp.toString()}";
                final transactionId = "TX-${timestamp.toString()}";
                final orderDate = DateTime.now();
                final userInfo =
                    "User: John Doe"; // Ganti dengan data user sebenarnya

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoicePage(
                      userInfo: userInfo,
                      orderId: orderId,
                      transactionId: transactionId,
                      orderDate: orderDate,
                      paymentMethod: _selectedPayment!,
                      topUpItem: _selectedDiamondLabel!,
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
      appBar: AppBar(title: Text("Spotify Premium")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        // 3) Bungkus formKey pada Form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// =======================
              /// Section: Pilih Voucher
              /// =======================

              /// =======================
              /// Section: Pilih Jumlah Voucher Spotify
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
                      "Pilih Voucher",
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
