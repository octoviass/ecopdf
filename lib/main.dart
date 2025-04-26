
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final InAppPurchase _iap = InAppPurchase.instance;

bool _available = false;
List<ProductDetails> _products = [];

void initStoreInfo() async {
  _available = await _iap.isAvailable();
  if (!_available) return;

  const Set<String> ids = <String>{'ecopdf_monthly'};
  final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
  if (response.error != null || response.productDetails.isEmpty) return;

  _products = response.productDetails;
}

void buySubscription() {
  final ProductDetails product = _products.first;
  final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
  _iap.buyNonConsumable(purchaseParam: purchaseParam);
}

void listenToPurchases() {_iap.purchaseStream.listen((List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Save purchase in Firebase or local storage
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'subscribed': true,
          'productId': purchase.productID,
          'purchaseDate': FieldValue.serverTimestamp()
        }, SetOptions(merge: true),);
      }
    }
  });
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initStoreInfo();
    listenToPurchases();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}







