import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan import ini
import 'dart:async';
import 'invoice_page.dart';

class TransactionPage extends StatefulWidget {
  final String userInfo;
  final String orderId;
  final String transactionId;
  final DateTime orderDate;
  final String paymentMethod;
  final String topUpItem;
  final double totalPayment;

  const TransactionPage({
    Key? key,
    required this.userInfo,
    required this.orderId,
    required this.transactionId,
    required this.orderDate,
    required this.paymentMethod,
    required this.topUpItem,
    required this.totalPayment,
  }) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with TickerProviderStateMixin {
  bool _isProcessing = true;
  bool _paymentSuccess = false;
  Timer? _timer;
  int _countdown = 300; // 5 menit dalam detik
  late AnimationController _loadingController;
  late AnimationController _successController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _successAnimation;
  String? _fullName; // Tambahkan variabel untuk menyimpan nama lengkap

  @override
  void initState() {
    super.initState();
    _loadFullName(); // Panggil fungsi untuk mengambil nama lengkap

    // Setup animasi loading
    _loadingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    // Setup animasi success
    _successController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    // Simulasi proses pembayaran
    _startPaymentProcess();

    // Mulai countdown
    _startCountdown();
  }

  // Fungsi untuk mengambil nama lengkap dari SharedPreferences
  Future<void> _loadFullName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('nama_pelanggan') ?? 'User';
    });
  }

  void _startPaymentProcess() {
    // Simulasi proses pembayaran selama 3-5 detik
    Timer(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _paymentSuccess = true;
        });
        _loadingController.stop();
        _successController.forward();

        // Auto redirect ke invoice setelah 2 detik
        Timer(Duration(seconds: 2), () {
          if (mounted) {
            _navigateToInvoice();
          }
        });
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        if (_isProcessing) {
          // Timeout - anggap gagal
          setState(() {
            _isProcessing = false;
            _paymentSuccess = false;
          });
          _loadingController.stop();
        }
      }
    });
  }

  void _navigateToInvoice() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicePage(
          userInfo: widget.userInfo,
          orderId: widget.orderId,
          transactionId: widget.transactionId,
          orderDate: widget.orderDate,
          paymentMethod: widget.paymentMethod,
          topUpItem: widget.topUpItem,
          totalPayment: widget.totalPayment,
          fullName: _fullName ?? 'User', // ✅ Gunakan nama lengkap yang benar
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildPaymentMethodIcon() {
    final Map<String, String> paymentIcons = {
      "GoPay": "assets/payment/gopay.png",
      "Dana": "assets/payment/dana.png",
      "QRIS": "assets/payment/Qris.png",
      "ShopeePay": "assets/payment/ShopeePay.png",
      "Bank Transfer": "assets/payment/Bank.png",
      "OVO": "assets/payment/ovo.png",
      "Indomaret": "assets/payment/indomaret.png",
      "Telkomsel": "assets/payment/telkomsel.png",
    };

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            paymentIcons[widget.paymentMethod] ?? 'assets/payment/default.png',
            width: 40,
            height: 40,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.paymentMethod,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(widget.totalPayment),
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _loadingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mencegah user kembali saat proses pembayaran
        if (_isProcessing) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pembayaran'),
          centerTitle: true,
          leading: _isProcessing ? SizedBox.shrink() : BackButton(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Header dengan countdown
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isProcessing
                      ? Colors.orange.shade50
                      : _paymentSuccess
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isProcessing
                        ? Colors.orange
                        : _paymentSuccess
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isProcessing) ...[
                      Text(
                        'Memproses Pembayaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Waktu tersisa: ${_formatTime(_countdown)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade600,
                        ),
                      ),
                    ] else if (_paymentSuccess) ...[
                      Text(
                        'Pembayaran Berhasil!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mengarahkan ke halaman invoice...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Pembayaran Gagal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Waktu pembayaran habis atau terjadi kesalahan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Status Icon dengan Animasi
              Container(
                height: 120,
                child: Center(
                  child: _isProcessing
                      ? AnimatedBuilder(
                          animation: _loadingAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _loadingAnimation.value * 2 * 3.14159,
                              child: Icon(
                                Icons.sync,
                                size: 60,
                                color: Colors.orange,
                              ),
                            );
                          },
                        )
                      : _paymentSuccess
                      ? ScaleTransition(
                          scale: _successAnimation,
                          child: Icon(
                            Icons.check_circle,
                            size: 60,
                            color: Colors.green,
                          ),
                        )
                      : Icon(Icons.error, size: 60, color: Colors.red),
                ),
              ),

              SizedBox(height: 24),

              // Detail Transaksi
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Transaksi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),

                      _buildDetailRow('ID Transaksi', widget.transactionId),
                      _buildDetailRow('Order ID', widget.orderId),
                      _buildDetailRow('Item', widget.topUpItem),
                      _buildDetailRow('User Info', widget.userInfo),
                      _buildDetailRow(
                        'Total',
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(widget.totalPayment),
                      ),

                      SizedBox(height: 16),
                      _buildPaymentMethodIcon(),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Action Buttons
              if (!_isProcessing) ...[
                if (_paymentSuccess) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToInvoice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Lihat Invoice',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Kembali'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Reset dan coba lagi
                            setState(() {
                              _isProcessing = true;
                              _paymentSuccess = false;
                              _countdown = 300;
                            });
                            _loadingController.repeat();
                            _startPaymentProcess();
                            _startCountdown();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Coba Lagi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Text(': '),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
