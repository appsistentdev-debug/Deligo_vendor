/// Depends on
/// ImagePicker: https://pub.dev/packages/image_picker

import 'dart:io';

import 'package:delivoo_store/Locale/locales.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

enum PickerSource { camera, gallery, ask }

enum CropConfig { free, square }

class Picker {
  final _imagePicker = ImagePicker();

  Future<File?> pickVideoFile(
      BuildContext context, PickerSource pickerSource) async {
    ThemeData theme = Theme.of(context);
    if (pickerSource == PickerSource.ask) {
      PickerSource? pickerSourceChoice = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(AppLocalizations.of(context)!
              .getTranslationOf("video_pic_header")),
          content: Text(AppLocalizations.of(context)!
              .getTranslationOf("video_pic_subheader")),
          actions: <Widget>[
            // MaterialButton(
            //   child: Text(
            //       AppLocalizations.of(context)!.getTranslationOf("cancel")),
            //   textColor: theme.primaryColor,
            //   shape: RoundedRectangleBorder(
            //       side: BorderSide(color: theme.primaryColor)),
            //   onPressed: () => Navigator.pop(context, null),
            // ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)!
                  .getTranslationOf("image_pic_camera")),
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.primaryColor)),
              onPressed: () => Navigator.pop(context, PickerSource.camera),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)!
                  .getTranslationOf("image_pic_gallery")),
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.primaryColor)),
              onPressed: () => Navigator.pop(context, PickerSource.gallery),
            ),
          ],
        ),
      );
      return pickerSourceChoice != null
          ? _pickVideo(pickerSourceChoice == PickerSource.camera
              ? ImageSource.camera
              : ImageSource.gallery)
          : null;
    } else {
      return _pickVideo(pickerSource == PickerSource.camera
          ? ImageSource.camera
          : ImageSource.gallery);
    }
  }

  Future<File?> pickImageFile(BuildContext context, PickerSource pickerSource,
      CropConfig? cropConfig) async {
    ThemeData theme = Theme.of(context);
    File? toReturn;
    if (pickerSource == PickerSource.ask) {
      PickerSource? pickerSourceChoice = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(AppLocalizations.of(context)!
              .getTranslationOf("image_pic_header")),
          content: Text(AppLocalizations.of(context)!
              .getTranslationOf("image_pic_subheader")),
          actions: <Widget>[
            // MaterialButton(
            //   child: Text(
            //       AppLocalizations.of(context)!.getTranslationOf("cancel")),
            //   textColor: theme.primaryColor,
            //   shape: RoundedRectangleBorder(
            //       side: BorderSide(color: Colors.white70)),
            //   onPressed: () => Navigator.pop(context, null),
            // ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)!
                  .getTranslationOf("image_pic_camera")),
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.primaryColor)),
              onPressed: () => Navigator.pop(context, PickerSource.camera),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)!
                  .getTranslationOf("image_pic_gallery")),
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.primaryColor)),
              onPressed: () => Navigator.pop(context, PickerSource.gallery),
            ),
          ],
        ),
      );
      toReturn = pickerSourceChoice != null
          ? (await _pickImage(pickerSourceChoice == PickerSource.camera
              ? ImageSource.camera
              : ImageSource.gallery))
          : null;
    } else {
      toReturn = await _pickImage(pickerSource == PickerSource.camera
          ? ImageSource.camera
          : ImageSource.gallery);
    }
    if (toReturn != null && cropConfig != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: toReturn.path,
        aspectRatio: cropConfig == CropConfig.square
            ? const CropAspectRatio(ratioX: 1, ratioY: 1)
            : null,
        uiSettings: [
          AndroidUiSettings(
            hideBottomControls: true,
            lockAspectRatio: cropConfig != CropConfig.free,
            toolbarTitle: AppLocalizations.of(context)!
                    .getTranslationOf("adjust_image")
                    .contains("_")
                ? "Adjust Image"
                : AppLocalizations.of(context)!
                    .getTranslationOf("adjust_image"),
            toolbarColor: theme.scaffoldBackgroundColor,
            toolbarWidgetColor: theme.primaryColor,
            aspectRatioPresets: [
              if (cropConfig == CropConfig.square) CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: AppLocalizations.of(context)!
                    .getTranslationOf("adjust_image")
                    .contains("_")
                ? "Adjust Image"
                : AppLocalizations.of(context)!
                    .getTranslationOf("adjust_image"),
            cancelButtonTitle:
                AppLocalizations.of(context)!.getTranslationOf("cancel"),
            doneButtonTitle:
                AppLocalizations.of(context)!.getTranslationOf("done"),
            rotateClockwiseButtonHidden: true,
            resetButtonHidden: true,
            aspectRatioPresets: [
              if (cropConfig == CropConfig.square) CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      toReturn = croppedFile != null ? File(croppedFile.path) : null;
    }
    return toReturn;
  }

  Future<File?> _pickImage(ImageSource imageSource) async {
    final XFile? image = await _imagePicker.pickImage(source: imageSource);
    return image != null ? File(image.path) : null;
  }

  Future<File?> _pickVideo(ImageSource imageSource) async {
    final XFile? video = await _imagePicker.pickVideo(source: imageSource);
    return video != null ? File(video.path) : null;
  }
}
