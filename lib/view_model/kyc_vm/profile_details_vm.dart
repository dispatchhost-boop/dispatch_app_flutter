import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../const/image_picker/image_confirm_bottom_sheet.dart';
import '../../const/image_picker/media_option_bottom_sheet.dart';

class ProfileDetailsViewModel{
  late final WidgetRef _ref;
  ProfileDetailsViewModel(this._ref);

  final profileImage = StateProvider<String?>((ref)=> null);
  final compImage = StateProvider<String?>((ref)=>null);
  final isProfileNotPicked = StateProvider<bool?>((ref)=> null);
  final isCompImageRequired = StateProvider<bool?>((ref)=> null);
  final companyType = StateProvider<int?>((ref)=>null);
  final isCompTypeNotSelected = StateProvider<bool?>((ref)=>null);final
  TextEditingController compName = TextEditingController();
  final TextEditingController brandName = TextEditingController();
  final TextEditingController compEmail = TextEditingController();
  final TextEditingController compWebsite = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  Future<void> onPickCompImage({required BuildContext context}) async {

    File? image = await MyBottomSheet.onMediaOptionBottomSheet(context: context, pickImage: 1);
    if(image != null){
      ConfirmationImageBottomSheet.showBottomSheet(context: context, selectedImage: image, status: true, onConfirm: (){
        _ref.refresh(compImage.notifier).state = image.path;
      });
    }
  }

  void removeCompImage(){
    _ref.refresh(compImage.notifier).state = null;
  }

}