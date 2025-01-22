import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/screen/dashboard.dart';

class PlaidLogin extends StatefulWidget {
  const PlaidLogin({super.key});

  @override
  _ExState createState() => _ExState();
}

class _ExState extends State<PlaidLogin> {
  LinkTokenConfiguration? _configuration;
  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;
  LinkObject? _successObject;
  bool loading = true;

  plaidConnect() async {
    final dio = Dio();
    final response =
        // await dio.get('http://192.168.255.116:8000/api/plaid/link-token');
        await dio.get('http://10.92.4.217:8000/api/plaid/link-token');

    setState(() {
      _configuration = LinkTokenConfiguration(
        token: response.data['link_token'],
      );
    });

    PlaidLink.create(configuration: _configuration!);
    loading = false;
    _configuration != null ? PlaidLink.open() : null;
  }

  @override
  void initState() {
    super.initState();

    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);

    plaidConnect();
  }

  @override
  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    super.dispose();
  }

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    print("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) {
    final token = event.publicToken;
    final metadata = event.metadata.description();
    print("onSuccess: $token, metadata: $metadata");
    setState(() => _successObject = event);
    navigationTonextPage(context, const Dashboard());
  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    print("onExit metadata: $metadata, error: $error");
  }

  @override
  Widget build(BuildContext context) {
    double longeur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Connexion ",
        //       style: TextStyle(color: Colors.white)),
        //   backgroundColor: Colors.blue,
        // ),
        body: loading
            ? Center(
                child: Card(
                  elevation: 8.0,
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: longeur / 15.0, horizontal: longeur / 50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(height: longeur / 50.0),
                          const Text("Authentification avce votre banque"),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null);
  }
}
