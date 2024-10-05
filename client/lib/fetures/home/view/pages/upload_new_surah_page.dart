import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/home/view/widgets/audio_wave.dart';
import 'package:client/fetures/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadNewSurahPage extends ConsumerStatefulWidget {
  const UploadNewSurahPage({super.key});

  @override
  ConsumerState<UploadNewSurahPage> createState() => _UploadNewSurahPageState();
}

class _UploadNewSurahPageState extends ConsumerState<UploadNewSurahPage> {
  final surahNameController = TextEditingController();
  final shaikhNameController = TextEditingController();
  Color selectedColor = AppPallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey=GlobalKey<FormState>();
  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
       
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    surahNameController.dispose();
    shaikhNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(homeViewmodelProvider.select((val)=>val?.isLoading==true));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Surah"),
        actions: [
          IconButton(
              onPressed: () async {
                if(formKey.currentState!.validate()&& selectedAudio!=null&&selectedImage!=null){

                ref.read(homeViewmodelProvider.notifier).uploadSurah(
                    selectedAudio: selectedAudio!,
                    selectedThumbNail: selectedImage!,
                    surahName: surahNameController.text,
                    shaikh: shaikhNameController.text,
                    selectedColor: selectedColor);
                }else{
                  showSnackBar(context, 'missing fields');
                }

              },
              icon: const Icon(Icons.check))
        ],
      ),
      body:isLoading?const Loader(): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key:formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: selectedImage != null
                      ? SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              )))
                      : DottedBorder(
                          color: AppPallete.borderColor,
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          dashPattern: const [10, 4],
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'select thumbnail for your surah',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 40,
                ),
                selectedAudio != null
                    ? AudioWave(path: selectedAudio!.path)
                    : CustomField(
                        hintText: 'pick surah',
                        controller: null,
                        readOnly: true,
                        onTap: selectAudio,
                      ),
                const SizedBox(
                  height: 20,
                ),
                CustomField(
                  hintText: 'Shaikh',
                  controller: shaikhNameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomField(
                  hintText: ' Surah name',
                  controller: surahNameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                ColorPicker(
                  pickersEnabled: const {ColorPickerType.wheel: true},
                  color: selectedColor,
                  onColorChanged: (Color color) {
                    setState(
                      () {
                        selectedColor = color;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
