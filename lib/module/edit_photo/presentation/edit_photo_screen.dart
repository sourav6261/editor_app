import 'package:edt/core/bloc/download_status.dart';
import 'package:edt/core/component/dialog/confirmation_dialog.dart';
import 'package:edt/core/component/dialog/loading_dialog.dart';
import 'package:edt/core/component/dialog/success_dialog.dart';
import 'package:edt/core/component/snackbar/info_snackbar.dart';
import 'package:edt/module/edit_photo/model/dragable_widget_child.dart';
import 'package:edt/module/edit_photo/presentation/widget/dragable_widget.dart';
import 'package:edt/module/home/model/photo/photo_model.dart';
import 'package:edt/widgettwo/edit_image_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'cubit/edit_photo_cubit.dart';
import 'pages/add_text_layout.dart';
import 'widget/edit_photo_widget.dart';
import 'widget/menu_icon_widget.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPhotoScreen extends StatelessWidget {
  const EditPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditPhotoCubit(),
      child: const EditPhotoLayout(),
    );
  }
}

class EditPhotoLayout extends StatefulWidget {
  const EditPhotoLayout({super.key});

  @override
  State<EditPhotoLayout> createState() => _EditPhotoLayoutState();
}

class _EditPhotoLayoutState extends State<EditPhotoLayout> {
  final picker = ImagePicker();
  File? imageFile;
  late PhotoItemModel photo;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void didChangeDependencies() {
    photo = ModalRoute.of(context)?.settings.arguments as PhotoItemModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPhotoCubit, EditPhotoState>(
      listenWhen: (p, c) {
        return p.shareStatus != c.shareStatus ||
            p.downloadStatus != c.downloadStatus;
      },
      listener: (context, state) {
        if (state.shareStatus == DownloadStatus.downloading) {
          showLoadingDialog(context);
        }
        if (state.shareStatus == DownloadStatus.success) {
          Navigator.pop(context);
        }

        if (state.downloadStatus == DownloadStatus.downloading) {
          showLoadingDialog(context);
        }
        if (state.downloadStatus == DownloadStatus.success) {
          Navigator.pop(context);
          showSuccessDialog(context, "Success Download!");
        }

        if (state.shareStatus == DownloadStatus.failed ||
            state.downloadStatus == DownloadStatus.failed) {
          Navigator.pop(context);
          showInfoSnackBar(
            context,
            "Something wrong when downloading photo, please try again!",
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            ///
            Screenshot(
              controller: screenshotController,
              child: EditPhotoWidget(photo: photo),
            ),

            ///
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              child: MenuIconWidget(
                onTap: () async {
                  final result = await showConfirmationDialog(
                    context,
                    title: "Discard Edits",
                    desc:
                        "Are you sure want to Exit ? You'll lose all the edits you've made",
                  );
                  if (result == null) return;

                  if (result) {
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                icon: Icons.arrow_back_ios_new_rounded,
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MenuIconWidget(
                    onTap: () async {
                      context
                          .read<EditPhotoCubit>()
                          .changeDownloadStatus(DownloadStatus.downloading);

                      final image = await screenshotController.capture(
                        delay: const Duration(milliseconds: 200),
                      );
                      if (!mounted) return;
                      context.read<EditPhotoCubit>().downloadImage(image);
                    },
                    icon: CupertinoIcons.cloud_download,
                  ),
                  const SizedBox(width: 16),
                  MenuIconWidget(
                    onTap: () async {
                      context.read<EditPhotoCubit>().changeShareStatus(
                            DownloadStatus.downloading,
                          );

                      final image = await screenshotController.capture(
                        delay: const Duration(milliseconds: 200),
                      );
                      if (!mounted) return;
                      context.read<EditPhotoCubit>().shareImage(image);
                    },
                    icon: CupertinoIcons.share,
                  ),
                ],
              ),
            ),

            Positioned(
              left: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<EditPhotoCubit, EditPhotoState>(
                        buildWhen: (p, c) {
                          return p.editState != c.editState ||
                              p.opacityLayer != c.opacityLayer;
                        },
                        builder: (context, state) {
                          return Visibility(
                            visible: state.editState == EditState.layering,
                            maintainState: true,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  value: state.opacityLayer,
                                  min: 0,
                                  max: 1,
                                  onChanged: context
                                      .read<EditPhotoCubit>()
                                      .changeOpacityLayer,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      MenuIconWidget(
                        onTap: () async {
                          final curentState =
                              context.read<EditPhotoCubit>().state.editState;

                          if (curentState == EditState.layering) {
                            context
                                .read<EditPhotoCubit>()
                                .changeEditState(EditState.idle);
                          } else {
                            context
                                .read<EditPhotoCubit>()
                                .changeEditState(EditState.layering);
                          }
                        },
                        icon: Icons.layers,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  MenuIconWidget(
                    onTap: () async {
                      context
                          .read<EditPhotoCubit>()
                          .changeEditState(EditState.addingText);

                      final result = await addText(context);

                      if (result == null ||
                          result is! DragableWidgetTextChild) {
                        if (!mounted) return;
                        context
                            .read<EditPhotoCubit>()
                            .changeEditState(EditState.idle);
                        return;
                      }

                      final widget = DragableWidget(
                        widgetId: DateTime.now().millisecondsSinceEpoch,
                        child: result,
                        onPress: (id, widget) async {
                          if (widget is DragableWidgetTextChild) {
                            context
                                .read<EditPhotoCubit>()
                                .changeEditState(EditState.addingText);

                            final result = await addText(
                              context,
                              widget,
                            );

                            if (result == null ||
                                result is! DragableWidgetTextChild) {
                              if (!mounted) return;
                              context
                                  .read<EditPhotoCubit>()
                                  .changeEditState(EditState.idle);
                              return;
                            }

                            if (!mounted) return;
                            context
                                .read<EditPhotoCubit>()
                                .editWidget(id, result);
                          }
                        },
                        onLongPress: (id) async {
                          final result = await showConfirmationDialog(
                            context,
                            title: "Delete Text ?",
                            desc: "Are you sure want to Delete this text ?",
                            rightText: "Delete",
                          );
                          if (result == null) return;

                          if (result) {
                            if (!mounted) return;
                            context.read<EditPhotoCubit>().deleteWidget(id);
                          }
                        },
                      );

                      if (!mounted) return;
                      context.read<EditPhotoCubit>().addWidget(widget);
                    },
                    icon: Icons.text_fields_rounded,
                  ),
                  IconButton(
                      onPressed: () async {
                        XFile? file = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditImageScreen(
                                selectedImage: file.path,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: []);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });
      // reload();
    }
  }
}
