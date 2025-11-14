import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  final Set<String> _scannedEventIds = {};

  Future<void> _handleBarcode(String rawValue) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      debugPrint(' RAW QR VALUE: $rawValue');

      final Map<String, dynamic> qrData = jsonDecode(rawValue);
      final String eventId = qrData['eventId'] ?? '';
      final int points = qrData['points'] ?? 0;

      if (eventId.isEmpty) {
        throw Exception('Invalid QR code');
      }

      if (_scannedEventIds.contains(eventId)) {
        throw Exception('This QR code has already been used');
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final scanDocId = '${uid}_$eventId';
      final scanRef = FirebaseFirestore.instance.collection('scans').doc(scanDocId);
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await FirebaseFirestore.instance.runTransaction((tx) async {
        // читаем оба документа ДО записи
        final scanSnap = await tx.get(scanRef);
        final userSnap = await tx.get(userRef);

        if (scanSnap.exists) {
          throw Exception('This QR code has already been used');
        }

        final currentPoints = userSnap.data()?['points'] ?? 0;

        // запись о скане
        tx.set(scanRef, {
          'uid': uid,
          'eventId': eventId,
          'points': points,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // обновляем очки
        tx.set(userRef, {
          'points': currentPoints + points,
        }, SetOptions(merge: true));
      });

      _scannedEventIds.add(eventId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $points points!')),
      );

      debugPrint(' SUCCESS: $points points added for event $eventId');
    } catch (e, stack) {
      debugPrint('❌ Scanner ERROR: $e');
      debugPrint(stack.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture capture) {
          if (capture.barcodes.isEmpty) return;

          final Barcode barcode = capture.barcodes.first;
          final String? rawValue = barcode.rawValue;

          if (rawValue != null) {
            _handleBarcode(rawValue);
          } else {
            debugPrint(' QR code has no data');
          }
        },
      ),
    );
  }
}
