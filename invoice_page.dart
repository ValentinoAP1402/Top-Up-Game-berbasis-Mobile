import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatelessWidget {
  final String userInfo;
  final String orderId;
  final String transactionId;
  final DateTime orderDate;
  final String paymentMethod;
  final String topUpItem;
  final double totalPayment;

  const InvoicePage({
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/selamat.png', // sesuaikan path logo di pubspec.yaml
                height: 80,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topUpItem,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRow('User Info', userInfo),
                    _buildRow('Order ID', orderId),
                    _buildRow('ID Transaksi', transactionId),
                    _buildRow(
                      'Tanggal pemesanan',
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(orderDate),
                    ),
                    _buildRow('Metode Pembayaran', paymentMethod),
                    _buildRow(
                      'Total Pembayaran',
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalPayment),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
