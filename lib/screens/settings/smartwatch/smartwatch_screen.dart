import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/smartwatch/pair_button.dart';
import 'package:flutter/material.dart';
import 'smartwatch.i18n.dart';

class SmartwatchScreen extends StatelessWidget {
  const SmartwatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 12.0),
          child: Text(
            "smartwatch_title".i18n,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 24.0, left: 24.0, right: 24.0),
        child: Column(
          children: [
            Panel(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160.0,
                      child: Image.asset("assets/graphics/smartwatch.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "supported_devices".i18n,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Panel(
                  title: Text(
                    "smartwatch_overview".i18n,
                    textAlign: TextAlign.left,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        Text(
                          "no_device_connected".i18n,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PairButton(
                  child: Text(
                      "pair_button".i18n,
                      style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0,)
                  ),
                  onPressed: () => print("[PLACEHOLDER PRINT] You pressed the smartwatch pairing button"), // TODO: CALL ACTUAL PAIRING FUNCTION
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}