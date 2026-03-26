import 'package:campaign_creator_flutter/src/ui/pages/shell/campaign_builder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('setting and twist wheel configs are independently tuned', () {
    expect(settingWheelPickerConfig.sheetHeight, 260);
    expect(settingWheelPickerConfig.itemExtent, 54);
    expect(settingWheelPickerConfig.diameterRatio, 2.45);
    expect(settingWheelPickerConfig.perspective, 0.0032);
    expect(settingWheelPickerConfig.fontSize, 16);
    expect(settingWheelPickerConfig.letterSpacing, 1.15);
    expect(settingWheelPickerConfig.fontWeight, FontWeight.w700);
    expect(settingWheelPickerConfig.maxLines, 2);

    expect(twistWheelPickerConfig.sheetHeight, 320);
    expect(twistWheelPickerConfig.itemExtent, 84);
    expect(twistWheelPickerConfig.diameterRatio, 3.5);
    expect(twistWheelPickerConfig.perspective, 0.0045);
    expect(twistWheelPickerConfig.fontSize, 13);
    expect(twistWheelPickerConfig.letterSpacing, 1.0);
    expect(twistWheelPickerConfig.fontWeight, FontWeight.w600);
    expect(twistWheelPickerConfig.maxLines, 3);

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
  });
}
