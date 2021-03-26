import 'dart:convert';
import 'package:flutter/material.dart';
import 'network.dart';
import 'webview.dart';

class AccountsPage extends StatefulWidget {
  String mxID;
  String deviceID;
  AccountsPage(this.mxID, this.deviceID, {Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<String> _accountInfo = new List<String>();
  @override
  void initState() {
    super.initState();
    _getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Accounts"),
      ),
      body: Container(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index >= _accountInfo.length) {
                return Container(
                  child: OutlineButton(
                    child: new Text("Add Account"),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      _addAccount();
                    },
                  ),
                );
              }
              return GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        _accountInfo[index],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  print(_accountInfo[index]);
                },
              );
            },
            itemCount: _accountInfo.length + 1),
      ),
    );
  }

  void _getAccounts() async {
    if (widget.mxID.isNotEmpty) {
      var response = await Network.getMXAccounts(widget.deviceID);
      var obj = json.decode(response.body);
      var accountList = obj['accounts'] as List<dynamic>;

      setState(() {
        if (accountList.isNotEmpty) {
          _accountInfo.clear();
        }
        for (var account in accountList) {
          _accountInfo.add("Inst: " +
              account['institution_code'] +
              "\nAcct#: " +
              account['account_number'] +
              "\nBalance: " +
              account['balance'].toString());
        }
      });
    }
  }

  void _addAccount() async {
    if (widget.mxID.isEmpty) {
      var response = await Network.createMXUSer(widget.deviceID);
      print(response.body);
      var obj = json.decode(response.body);
      widget.mxID = obj["mxid"];
    }
    var response = await Network.getConnectWidget(widget.deviceID);
    var obj = json.decode(response.body);
    print(obj['widget_url']['url']);
    Navigator.of(context)
        .push(
      new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
        return new WebviewPage(
          url: obj['widget_url']['url'],
          title: "Connect Accounts",
        );
      }, transitionsBuilder:
          (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(opacity: animation, child: child);
      }),
    )
        .then((value) {
      _getAccounts();
    });
  }
}
