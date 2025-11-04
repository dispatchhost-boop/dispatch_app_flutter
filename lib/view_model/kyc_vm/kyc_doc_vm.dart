import 'dart:io';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/models/kyc_model/gst_verify_model.dart';
import 'package:dispatch/models/kyc_model/pan_verify_model.dart';
import 'package:dispatch/repositories/kyc_repo/key_documents_repo.dart';
import 'package:dispatch/view_model/kyc_vm/profile_details_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../const/image_picker/image_confirm_bottom_sheet.dart';
import '../../const/image_picker/media_option_bottom_sheet.dart';
import '../../const/image_picker/my_media_picker.dart';

class KycDocumentsViewModel{
  late final WidgetRef _ref;
  late KycDocumentsRepo _repo;
  KycDocumentsViewModel(this._ref){
    _repo = _ref.read(kycDataRepo);
  }

  final TextEditingController aadharCntlr = TextEditingController();
  final TextEditingController gstCntlr = TextEditingController();
  final TextEditingController panCntlr = TextEditingController();
  final TextEditingController companyRegistrationCntlr = TextEditingController();
  final TextEditingController cancelChequeCntlr = TextEditingController();
  final GlobalKey<FormState> docFormKey = GlobalKey<FormState>();

  // final companyType = StateProvider<String?>((ref)=>null);
  final isGstRegistered = StateProvider<bool>((ref)=>true);
  final aadharImage = StateProvider<Map<String, String?>>((ref)=>{"aadhar_front": null, "aadhar_back": null});
  // final aadharImage = StateProvider<String?>((ref)=>null);
  final gstImage = StateProvider<String?>((ref)=>null);
  final panImage = StateProvider<String?>((ref)=>null);
  final compRegImage = StateProvider<String?>((ref)=>null);
  final cancelChequeImage = StateProvider<String?>((ref)=>null);
  // final isPanVerified = StateProvider<bool?>((ref)=>null);
  final isGstVerifiedData = StateProvider<GstVerificationModel?>((ref)=>null);
  final isPanVerifiedData = StateProvider<PanVerifyModel?>((ref)=>null);
  final isVerifiedImages = StateProvider<Map<String, String?>>((ref) => {
    "aadhar_front": null,
    "aadhar_back": null,
    "pan": null,
    "gst": null,
    "comp_reg": null,
    "cheque": null,
  });

  // inside your ViewModel
  final imageErrors = StateProvider<Map<String, dynamic>>((ref) => {});


  Future<void> onSelectImage({required BuildContext context, required WidgetRef ref, required int target, required String dockey,}) async {
    final pickedFile = await MyMediaPicker.onSingleMediaPicker(quality: 50, allowedExtensions: ['jpg', 'jpeg', 'png']);
    if(pickedFile is String && (pickedFile == 'unsupported' || pickedFile == 'large_size')){
      // validate images
      // final images = {
      //   "aadhar_front": _ref.read(aadharImage.notifier).state["aadhar_front"],
      //   "aadhar_back": _ref.read(aadharImage.notifier).state["aadhar_back"],
      //   "pan": _ref.read(panImage),
      //   "gst": _ref.read(gstImage),
      //   "comp_reg": _ref.read(compRegImage),
      //   "cheque": _ref.read(cancelChequeImage),
      // };
      //
      // final errors = <String, String?>{};
      // images.forEach((key, path) {
      //   errors[key] = validateImage(ref, key, path);
      // });
      // _ref.read(imageErrors.notifier).state = errors;
      // You can also attach it to your imageErrors
      final errors = <String, String?>{};
      errors[dockey] = pickedFile; //"unsupported"; //"Unsupported file type. Please upload JPG, PNG, or PDF.";
      ref.read(imageErrors.notifier).state = errors;

      // 🔄 Map of targets to their providers
      final targetMap = {
        1: aadharImage,         // Aadhaar (map with front/back)
        2: gstImage,
        3: panImage,
        4: compRegImage,
        5: cancelChequeImage,
      };

      if (target == 1) {
        // Aadhaar special case → clear only the side (front/back)
        final aadhaar = ref.read(aadharImage.notifier).state;
        aadhaar[dockey] = null;
        ref.read(aadharImage.notifier).state = {...aadhaar}; // update state
      } else {
        // Non-Aadhaar → directly nullify provider
        ref.read(targetMap[target]!.notifier).state = null;
      }

      // Reset status
      updateImageStatus(ref, dockey, null);
      // }

    }
    else if (pickedFile != null && pickedFile is File) {
      final errors = <String, String?>{};
      errors[dockey] = null; //"Unsupported file type. Please upload JPG, PNG, or PDF.";
      ref.read(imageErrors.notifier).state = errors;


      final path = pickedFile.path.toLowerCase();

      // ✅ PDF → save directly
      if (path.endsWith(".pdf")) {
        _setDoc(ref, target, dockey, pickedFile.path);
        DebugConfig.debugLog("📄 PDF selected: ${pickedFile.path}");
      }
      // ✅ Image → show confirmation bottomsheet
      else {
        ConfirmationImageBottomSheet.showBottomSheet(
          context: context,
          selectedImage: pickedFile,
          status: true,
          onConfirm: () async {
            var compressed = await MyMediaPicker.onSingleImageCompressor(
              atQuality: 60,
              imageFile: pickedFile,
            );
            _setDoc(ref, target, dockey, compressed?.path);
            DebugConfig.debugLog("🖼️ Image confirmed: ${compressed?.path}");
          },
        );
      }

    }
  }

  void _setDoc(WidgetRef ref, int target, String docKey, String? path) {
    update(String key, StateProvider provider) {
      ref.read(provider.notifier).state = path;
      updateImageStatus(ref, key, path == null ? '0' : '3');
    }

    switch (target) {
      case 1: // Aadhaar
        ref.read(aadharImage.notifier).state[docKey] = path;
        updateImageStatus(ref, docKey, path == null ? '0' : '3');
        break;
      case 2:
        update('gst', gstImage);
        break;
      case 3:
        update('pan', panImage);
        break;
      case 4:
        update('comp_reg', compRegImage);
        break;
      case 5:
        update('cheque', cancelChequeImage);
        break;
    }
  }

  Future<GstVerificationModel?> fetchGstDetails({required WidgetRef loaderRef, required Map<String, String> body})async{
    final res = await _repo.fetchGstDetails(body: body, loaderRef: loaderRef);
    if(res != null){
      _ref.refresh(isGstVerifiedData.notifier).state = res;
      DebugConfig.debugLog('Gstfsdlv hahah');
    }else{
      _ref.refresh(isGstVerifiedData.notifier).state = null;
    }
    return res;
  }

  Future<PanVerifyModel?> fetchPanDetails({required WidgetRef loaderRef, required Map<String, String> body})async{
    final res = await _repo.fetchPanDetails(body: body, loaderRef: loaderRef);
    // DebugConfig.debugLog('Pan verification : ${res.toString()}');
    if(res != null && res.data != null){
      // _ref.refresh(isPanVerified.notifier).state = true;
      _ref.refresh(isPanVerifiedData.notifier).state = res;
    }else{
      // _ref.refresh(isPanVerified.notifier).state = false;
      _ref.refresh(isPanVerifiedData.notifier).state = null;
    }
    return res;
  }

  void updateImageStatus(WidgetRef ref, String key, String? status) {
    // not selected = null, not verified = 1, verified = 2, selected but not verified = 3

    // ✅ PAN special handling
    if (key == 'pan') {
      final panStatus = ref.read(isPanVerifiedData.notifier).state;
      if (panStatus?.data?.status.toString() == "1") {
        ref.read(isVerifiedImages.notifier).update((state) {
          final newState = Map<String, String?>.from(state);
          newState[key] = status;
          return newState;
        });
      } else {
        ref.read(isVerifiedImages.notifier).update((state) {
          final newState = Map<String, String?>.from(state);
          newState[key] = "1"; // not verified
          return newState;
        });
      }
      return;
    }

    // ✅ Aadhaar front/back + other docs (flat map, no nesting)
    ref.read(isVerifiedImages.notifier).update((state) {
      final newState = Map<String, String?>.from(state);
      newState[key] = status;
      return newState;
    });
  }

  Future<dynamic> uploadKycDetails({required WidgetRef loaderRef, required ProfileDetailsViewModel profileVm, required Map<String, String> clientDetails}) async {
    String selfie = _ref.read(profileVm.profileImage.notifier).state ?? '';
    String logo = _ref.read(profileVm.compImage.notifier).state ?? '';
    String panHolderName = _ref.read(isPanVerifiedData.notifier).state?.data?.msg?.nameOnTheCard ?? '';
    Map<String, String?> aadhar = _ref.read(aadharImage.notifier).state;//['aadhar_front'] ?? ''
    String pan = _ref.read(panImage.notifier).state ?? '';
    String gst = _ref.read(gstImage.notifier).state ?? '';
    String compReg = _ref.read(compRegImage.notifier).state ?? '';
    String cheque = _ref.read(cancelChequeImage.notifier).state ?? '';
    int? compType = _ref.read(profileVm.companyType.notifier).state;
    bool isGstReg = _ref.read(isGstRegistered.notifier).state;

    // ✅ Build files map dynamically
    final Map<String, File> files = {
      "selfie": File(selfie),
      "aadhaarFrontUpload": File(aadhar['aadhar_front'] ?? ''),
      "aadhaarBackUpload": File(aadhar['aadhar_back'] ?? ''),
      "pandoc": File(pan),
      "cancelledCheckUpload": File(cheque),
      "clientLogo": File(logo),
    };

    // ✅ Only include GST & CompanyReg if NOT individual (compType != 4)
    if (compType != 4) {
      if (gst.isNotEmpty) files["gstdoc"] = File(gst);
      if (compReg.isNotEmpty) files["companyRegUpload"] = File(compReg);
    }

    final r = await _repo.uploadKycDetails(loaderRef: loaderRef, fields: {
      "clientName": clientDetails['name'],
      "clientEmail": clientDetails['email'],
      "clientPhone": clientDetails['phone'],
      "companyType": compType == 1 ? 'privateCompany' : compType == 2 ? "publicCompany" : compType == 3? "partnership" : compType == 4 ? "individual" : "",
      "registeredCompanyName": profileVm.compName.text.toString(),
      "brandName": profileVm.brandName.text.toString(),
      "companyEmail": profileVm.compEmail.text.toString(),
      "website": profileVm.compWebsite.text.toString(),
      "aadhaarNumber": aadharCntlr.text.toString().replaceAll(" ", ''),
      "gstNo": compType == 4 ? isGstReg == true ? gstCntlr.text.toString() : "" : gstCntlr.text.toString(),
      "company_pan": panCntlr.text.toString(),
      "pan_holder_name": panHolderName,
      "companyRegNumber": compType == 4 ? "" : companyRegistrationCntlr.text.toString(),
      "cancelledCheckNumber": cancelChequeCntlr.text.toString(),
    }, files: files);

    return r;
  }

  resetAll(){
    aadharCntlr.clear();
    panCntlr.clear();
    gstCntlr.clear();
    companyRegistrationCntlr.clear();
    cancelChequeCntlr.clear();
    _ref.refresh(isGstRegistered.notifier).state = true;
    _ref.refresh(aadharImage.notifier).state = {"aadhar_front": null, "aadhar_back": null};
    _ref.refresh(gstImage.notifier).state = null;
    _ref.refresh(panImage.notifier).state = null;
    _ref.refresh(compRegImage.notifier).state = null;
    _ref.refresh(cancelChequeImage.notifier).state = null;
    // _ref.refresh(isPanVerified.notifier).state = null;
    _ref.refresh(imageErrors.notifier).state = {};
    _ref.refresh(isVerifiedImages.notifier).state = {
      "aadhar": null,
      "pan": null,
      "gst": null,
      "comp_reg": null,
      "cheque": null
    };
  }

}