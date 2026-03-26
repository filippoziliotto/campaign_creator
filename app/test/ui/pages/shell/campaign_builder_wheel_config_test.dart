import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('setting, twist, and preset wheel configs are independently tuned', () {
    expect(settingWheelPickerConfig.sheetHeight, 260);
    expect(settingWheelPickerConfig.itemExtent, 54);
    expect(settingWheelPickerConfig.diameterRatio, 2.45);
    expect(settingWheelPickerConfig.perspective, 0.0032);
    expect(settingWheelPickerConfig.fontSize, 16);
    expect(settingWheelPickerConfig.letterSpacing, 1.15);
    expect(settingWheelPickerConfig.fontWeight, FontWeight.w700);
    expect(settingWheelPickerConfig.maxLines, 2);

    expect(twistWheelPickerConfig.sheetHeight, 350);
    expect(twistWheelPickerConfig.itemExtent, 80);
    expect(twistWheelPickerConfig.diameterRatio, 3.5);
    expect(twistWheelPickerConfig.perspective, 0.0045);
    expect(twistWheelPickerConfig.fontSize, 13);
    expect(twistWheelPickerConfig.letterSpacing, 1.0);
    expect(twistWheelPickerConfig.fontWeight, FontWeight.w600);
    expect(twistWheelPickerConfig.maxLines, 3);

    expect(presetWheelPickerConfig.sheetHeight, 300);
    expect(presetWheelPickerConfig.itemExtent, 66);
    expect(presetWheelPickerConfig.diameterRatio, 2.9);
    expect(presetWheelPickerConfig.perspective, 0.0038);
    expect(presetWheelPickerConfig.fontSize, 14);
    expect(presetWheelPickerConfig.letterSpacing, 1.08);
    expect(presetWheelPickerConfig.fontWeight, FontWeight.w700);
    expect(presetWheelPickerConfig.maxLines, 2);

    expect(
      settingWheelPickerConfig.sheetHeight,
      isNot(twistWheelPickerConfig.sheetHeight),
    );
    expect(
      settingWheelPickerConfig.itemExtent,
      isNot(twistWheelPickerConfig.itemExtent),
    );
    expect(
      settingWheelPickerConfig.diameterRatio,
      isNot(twistWheelPickerConfig.diameterRatio),
    );
    expect(
      settingWheelPickerConfig.perspective,
      isNot(twistWheelPickerConfig.perspective),
    );
    expect(
      settingWheelPickerConfig.fontSize,
      isNot(twistWheelPickerConfig.fontSize),
    );
    expect(
      settingWheelPickerConfig.letterSpacing,
      isNot(twistWheelPickerConfig.letterSpacing),
    );
    expect(
      settingWheelPickerConfig.fontWeight,
      isNot(twistWheelPickerConfig.fontWeight),
    );
    expect(
      settingWheelPickerConfig.maxLines,
      isNot(twistWheelPickerConfig.maxLines),
    );
    expect(
      presetWheelPickerConfig.sheetHeight,
      isNot(settingWheelPickerConfig.sheetHeight),
    );
    expect(
      presetWheelPickerConfig.itemExtent,
      isNot(twistWheelPickerConfig.itemExtent),
    );
    expect(
      presetWheelPickerConfig.diameterRatio,
      isNot(settingWheelPickerConfig.diameterRatio),
    );
    expect(
      presetWheelPickerConfig.perspective,
      isNot(twistWheelPickerConfig.perspective),
    );
    expect(
      presetWheelPickerConfig.fontSize,
      isNot(settingWheelPickerConfig.fontSize),
    );
    expect(
      presetWheelPickerConfig.letterSpacing,
      isNot(twistWheelPickerConfig.letterSpacing),
    );
    expect(
      presetWheelPickerConfig.fontWeight,
      isNot(twistWheelPickerConfig.fontWeight),
    );
  });
}
