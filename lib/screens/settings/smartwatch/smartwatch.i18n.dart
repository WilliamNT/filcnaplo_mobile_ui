import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "smartwatch_title": "Filc++ for Wearables",
          "pair_button": "Start pairing",
          "supported_devices": "Connect any smartwatch powered by Tizen or Wear OS",
          "smartwatch_overview": "Smartwatch overview",
          "no_device_connected": "You haven't paired your watch yet",
        },
        "hu_hu": {
          "smartwatch_title": "Filc++ for Wearables",
          "pair_button": "Párosítás megkezdése",
          "supported_devices": "Párosíts bármilyen Tizent vagy Wear OS-t futtató okosórát",
          "smartwatch_overview": "Okosóra áttekintése",
          "no_device_connected": "Még nem párosítottad az órádat",
        },
        "de_de": {
          "smartwatch_title": "Filc++ for Wearables",
          "pair_button": "Koppeln starten",
          "supported_devices": "Koppeln jede Smartwatch mit Tizen oder Wear OS installiert",
          "smartwatch_overview": "Smartwatch Übersicht",
          "no_device_connected": "Du hast deine Uhr noch nicht koppelt",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
