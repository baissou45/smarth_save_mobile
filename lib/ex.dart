import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class Ex extends StatefulWidget {
  const Ex({super.key});

  @override
  _ExState createState() => _ExState();
}

class _ExState extends State<Ex> {
  LinkTokenConfiguration? _configuration;
  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;
  LinkObject? _successObject;
  bool loading = true;

  plaidConnect() async {
    final dio = Dio();
    final response =
        await dio.get('http://192.168.255.116:8000/api/plaid/link-token');

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
        appBar: AppBar(
          title: const Text("Plaid Link Example",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Authentification avce votre banque"),
                    SizedBox(height: longeur / 50.0),
                    const CircularProgressIndicator(),
                  ],
                ),
              )
            : null);
  }
}
