import 'dart:io';

import 'package:flutter/foundation.dart' show describeEnum, kIsWeb;
import 'package:flutter/services.dart';

const Map<KeyModifier, List<LogicalKeyboardKey>> _knownLogicalKeys =
    <KeyModifier, List<LogicalKeyboardKey>>{
  KeyModifier.capsLock: [
    LogicalKeyboardKey.capsLock,
  ],
  KeyModifier.shift: [
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  ],
  KeyModifier.control: [
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
  ],
  KeyModifier.alt: [
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
  ],
  KeyModifier.meta: [
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
  ],
  KeyModifier.fn: [
    LogicalKeyboardKey.fn,
  ],
};

const Map<KeyModifier, ModifierKey> _knownModifierKeys =
    <KeyModifier, ModifierKey>{
  KeyModifier.capsLock: ModifierKey.capsLockModifier,
  KeyModifier.shift: ModifierKey.shiftModifier,
  KeyModifier.control: ModifierKey.controlModifier,
  KeyModifier.alt: ModifierKey.altModifier,
  KeyModifier.meta: ModifierKey.metaModifier,
  KeyModifier.fn: ModifierKey.functionModifier,
};

final Map<KeyModifier, String> _knownKeyLabels = <KeyModifier, String>{
  KeyModifier.capsLock: '⇪',
  KeyModifier.shift: (Platform.isMacOS) ? '⇧' : "Shift",
  KeyModifier.control: (Platform.isMacOS) ?  '⌃' : "Ctrl",
  KeyModifier.alt: (Platform.isMacOS) ? '⌥' : "Alt",
  KeyModifier.meta: (Platform.isMacOS) ? '⌘' : 'Windows key',
  KeyModifier.fn: 'fn',
};

enum KeyModifier {
  capsLock,
  shift,
  control,
  alt, // Alt / Option key
  meta, // Command / Win key
  fn,
}

extension KeyModifierParser on KeyModifier {
  static KeyModifier parse(String string) {
    return KeyModifier.values.firstWhere((e) => describeEnum(e) == string);
  }

  static ModifierKey? fromModifierKey(ModifierKey modifierKey) {
    return _knownModifierKeys.entries
        .firstWhere((entry) => entry.value == modifierKey)
        .value;
  }

  ModifierKey get modifierKey {
    return _knownModifierKeys[this]!;
  }

  static KeyModifier? fromLogicalKey(LogicalKeyboardKey logicalKey) {
    List<int> logicalKeyIdList = [];

    for (List<LogicalKeyboardKey> item in _knownLogicalKeys.values) {
      logicalKeyIdList.addAll(item.map((e) => e.keyId).toList());
    }
    if (!logicalKeyIdList.contains(logicalKey.keyId)) return null;

    return _knownLogicalKeys.entries
        .firstWhere((entry) =>
            entry.value.map((e) => e.keyId).contains(logicalKey.keyId))
        .key;
  }

  List<LogicalKeyboardKey> get logicalKeys {
    return _knownLogicalKeys[this]!;
  }

  String get stringValue => describeEnum(this);

  String get keyLabel {
    return _knownKeyLabels[this] ?? describeEnum(this);
  }
}
