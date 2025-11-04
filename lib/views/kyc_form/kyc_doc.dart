import 'dart:io';
import 'package:dispatch/const/buttons.dart';
import 'package:dispatch/const/common_methods.dart';
import 'package:dispatch/const/common_widget.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/const/image_picker/image_preview.dart';
import 'package:dispatch/services/ocr_text_recognition/comp_regist_verifier.dart';
import 'package:dispatch/view_model/kyc_vm/kyc_doc_vm.dart';
import 'package:dispatch/view_model/kyc_vm/profile_details_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../connectivity/internet_controller.dart';
import '../../const/aadhar_card_formatter.dart';
import '../../const/app_colors.dart';
import '../../const/app_strings.dart';
import '../../const/loader/loader_controller.dart';
import '../../const/text_style.dart';
import '../../services/ocr_text_recognition/aadhar_verifier.dart';
import '../../services/ocr_text_recognition/cheque_verifier.dart';
import '../../services/ocr_text_recognition/gst_verifier.dart';
import '../../services/ocr_text_recognition/ocr_const.dart';
import '../../services/ocr_text_recognition/pan_verifier.dart';
import '../../view_model/kyc_vm/kyc_dashbord_vm.dart';

class KycDocumentsScreen extends ConsumerStatefulWidget {
  final TabController tabController;
  final KycDocumentsViewModel vm;
  final KycDashboardViewModel kycVm;
  final ProfileDetailsViewModel profileVm;
  final Map<String, String> clientDetails;
  const KycDocumentsScreen({super.key, required this.tabController, required this.vm, required this.kycVm, required this.profileVm, required this.clientDetails});

  @override
  ConsumerState<KycDocumentsScreen> createState() => _KycDocumentsScreenState();
}

class _KycDocumentsScreenState extends ConsumerState<KycDocumentsScreen> {

  @override
  void initState() {
    // _vm = KycDocumentsViewModel(ref);
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.refresh(widget.vm.isGstRegistered.notifier).state = true;
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    return Consumer(
      builder: (context, loader, _) {
        final isLoading = loader.watch(loadingProvider);
        final a = loader.read(widget.kycVm.profileDetails.notifier).state;
        return PopScope(
          canPop: isLoading ? false : true,
          child: Center(
            child: SizedBox(
              // padding: EdgeInsets.only(left: 20, right: 20, top: 0),
              width: screenWidth * 0.9,
              child: Form(
                key: widget.vm.docFormKey,
                child: Consumer(builder: (key, ref, child){
                  final imageStatus = ref.watch(widget.vm.isVerifiedImages);
                  final isGstRegister = ref.watch(widget.vm.isGstRegistered.notifier).state;
                  return SingleChildScrollView(child: Column(
                    // shrinkWrap: true,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      MyTextStyles.getRegularText(text: AppStrings.uploadRequiredDocumentsForKycVerification, size: 14 * textScale),
                      _buildBox(screenHeight: screenHeight,screenWidth: screenWidth, textScale: textScale,
                        heading: '', label: AppStrings.aadharNumber, controller: widget.vm.aadharCntlr, imageVar: StateProvider<String?>((ref) => ref.watch(widget.vm.aadharImage)['aadhar_front']), target: 1, hint: 'XXXX-XXXX-XXXX', customValidator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.required;  // <-- return error string
                        }else if(v.length < 12){
                          return 'Invalid Aadhaar Number';
                        }
                        // Add other custom checks for target 4,5 if needed
                        return null; // valid
                      }, docKey: 'aadhar',),
                      if(a['comp_type'].toString() == '4')
                        _buildGstConfirmation(screenHeight: screenHeight, screenWidth: screenWidth, textScale: textScale),
                      if(isGstRegister)
                        _buildBox(screenHeight: screenHeight,screenWidth: screenWidth, textScale: textScale,
                            heading: '', label: AppStrings.gstNumber, controller: widget.vm.gstCntlr, imageVar: widget.vm.gstImage, target: 2, hint: '15 characters (e.g. 22AAAAA0000A1Z5)', customValidator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;  // <-- return error string
                          }else if (v.length < 15) {
                            return 'Invalid GST Number';
                          }
                          // Add other custom checks for target 4,5 if needed
                          return null; // valid
                        }, docKey: 'gst',
                            onChanged: (v) async {
                              if(v.length == 15){
                                final body = {
                                  "gstNumber": widget.vm.gstCntlr.text.toString().toUpperCase()
                                };
                                await widget.vm.fetchGstDetails(body: body, loaderRef: ref);
                              }
                            }),
                      // const SizedBox(height: 25,),
                      _buildBox(screenHeight: screenHeight,screenWidth: screenWidth, textScale: textScale,
                        heading: '', label: AppStrings.panNumber, controller: widget.vm.panCntlr, imageVar: widget.vm.panImage, target: 3, hint: 'e.g. ABCDE1234F', onChanged: (v) async {
                        if(v.length == 10){
                          final body = {
                            "docNumber": widget.vm.panCntlr.text.toString().toUpperCase()
                          };
                          await widget.vm.fetchPanDetails(body: body, loaderRef: ref);
                        }
                      }, customValidator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.required;  // <-- return error string
                        }else if (v.length < 10) {
                          return 'Invalid PAN Number';
                        }
                        // Add other custom checks for target 4,5 if needed
                        return null; // valid
                      }, docKey: 'pan',),
                      // const SizedBox(height: 25,),
                      if(a['comp_type'].toString() != '4')
                        _buildBox(screenHeight: screenHeight,screenWidth: screenWidth, textScale: textScale,
                          heading: '', label: AppStrings.companyRegistrationNumber, controller: widget.vm.companyRegistrationCntlr, imageVar: widget.vm.compRegImage, target: 4, hint: 'Enter as per ROC Certificate', customValidator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required; // <-- return error string
                          }else if (v.length < 21) {
                            return 'Invalid Registration Number';
                          }
                          // Add other custom checks for target 4,5 if needed
                          return null; // valid
                        }, docKey: 'comp_reg',),
                      // const SizedBox(height: 25,),
                      _buildBox(screenHeight: screenHeight,screenWidth: screenWidth, textScale: textScale,
                        heading: '', label: AppStrings.cancelledChequeNumber, controller: widget.vm.cancelChequeCntlr, imageVar: widget.vm.cancelChequeImage, target: 5, customValidator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.required;  // <-- return error string
                        }else if (v.length < 6) {
                          return 'Invalid Cheque Number';
                        }
                        // Add other custom checks for target 4,5 if needed
                        return null; // valid
                      }, docKey: 'cheque',),
                      SizedBox(height: screenHeight * 0.08),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Spacer(),
                          Expanded(child: _buildBackButton(ref: ref, screenHeight: screenHeight)),Spacer(),
                          Expanded(child: _buildSaveButton(ref: ref, screenHeight: screenHeight, clientDetails: widget.clientDetails)),Spacer(),
                        ],
                      ),
                      const SizedBox(height: 80,),
                    ],
                  ));
                }),
              ),
            ),

            // )
          ),
        );
      },
    );
  }

  Widget _buildGstConfirmation({required double screenWidth, required double screenHeight, required double textScale}){
    return Consumer(builder: (key, ref, child){
      final isSelected = ref.watch(widget.vm.isGstRegistered.notifier).state;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.02,),
          MyTextStyles.getRegularText(text: AppStrings.isGstRegistered),
          RadioListTile<bool>(
            activeColor: AppColors.mainClr,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: MyTextStyles.getRegularText(text: AppStrings.yes, size: 15 * textScale),
            value: true,
            groupValue: isSelected,
            onChanged: (value) {
              ref.refresh(widget.vm.isGstRegistered.notifier).state = value ?? true;
            },
          ),
          RadioListTile<bool>(
            activeColor: AppColors.mainClr,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: MyTextStyles.getRegularText(text: AppStrings.no, size: 15 * textScale),
            value: false,
            groupValue: isSelected,
            onChanged: (value) {
              ref.refresh(widget.vm.isGstRegistered.notifier).state = value ?? true;
            },
          ),
        ],
      );
    });
  }

  Widget _buildBackButton({required WidgetRef ref, required double screenHeight}) {
    return AppButtons.buildContainerButton(
      text: AppStrings.back,
      height: screenHeight * 0.045,
      onTap: () async {
        widget.tabController.animateTo(0);
        // widget.vm.resetAll();
      },

    );
  }

  Future<bool> verifyAadharFront(File aadharImage, String userInput) async {
    // final extractedText = await OcrFiles.extractTextFromImage(aadharImage);
    String extractedText = "";

    if (aadharImage.path.toLowerCase().endsWith(".pdf")) {
      // ✅ Extract text from all pages of PDF
      extractedText = await OcrFiles.extractTextFromPdf(aadharImage) ?? '';
    } else {
      // ✅ Extract text from Image
      extractedText = await OcrFiles.extractTextFromImage(aadharImage) ?? '';
    }
    final scannedAadhar = AadhaarVerifier.extractAadhaarNumber(extractedText ?? "");
    if (scannedAadhar == null) return false;

    final cleanedInput = userInput.replaceAll(RegExp(r"\s+"), "");
    bool numberMatch = false;
    bool keywordsOk = false;

    if (scannedAadhar.length == 12) {
      // Full Aadhaar → exact match
      numberMatch = cleanedInput == scannedAadhar;
      // ✅ Keywords check (BOTH required)
      keywordsOk = AadhaarVerifier.verifyFront(extractedText ?? '');
    } else if (scannedAadhar.length == 4) {
      // Masked Aadhaar → compare last 4 digits
      numberMatch = cleanedInput.endsWith(scannedAadhar);
      // ✅ Keywords check (BOTH required)
      keywordsOk = AadhaarVerifier.verifyFront(extractedText ?? '');
    }

    return numberMatch && keywordsOk;
  }

  // Future<bool> verifyAadharBack(File aadharImage, String userInput) async {
  //   final extractedText = await OcrFiles.extractTextFromImage(aadharImage);
  //   bool keywordsOk = false;
  //
  //   keywordsOk = AadhaarVerifier.verifyBack(extractedText ?? '');
  //
  //   return keywordsOk;
  // }
  Future<bool> verifyAadharBack(File aadharFile, String userInput) async {
    String extractedText = "";

    if (aadharFile.path.toLowerCase().endsWith(".pdf")) {
      // ✅ Extract text from all pages of PDF
      extractedText = await OcrFiles.extractTextFromPdf(aadharFile) ?? '';
    } else {
      // ✅ Extract text from Image
      extractedText = await OcrFiles.extractTextFromImage(aadharFile) ?? '';
    }

    // ✅ Verify with Aadhaar verifier
    bool keywordsOk = AadhaarVerifier.verifyBack(extractedText);

    return keywordsOk;
  }

  Future<bool> verifyPan(File panImage, String userInputPan) async {
    // 1. OCR: Extract text
    var extractedText = '';
    if(panImage.path.toLowerCase().endsWith(".pdf")){
      extractedText = await OcrFiles.extractTextFromPdf(panImage) ?? '';
    }else{
      extractedText = await OcrFiles.extractTextFromImage(panImage) ?? '';
    }
    DebugConfig.debugLog('Extracted :: $extractedText');

    if (extractedText.isEmpty) {
      return false;
    }
    // 2. Extract PAN number from OCR text
    final scannedPan = PanVerifier.extractPanNumber(extractedText);
    // 3. Match input PAN with scanned PAN
    bool numberMatch = false;
    if (scannedPan != null && scannedPan.isNotEmpty) {
      numberMatch = userInputPan.toUpperCase().replaceAll(" ", "") ==
          scannedPan.toUpperCase();
    }
    // 4. Keywords verification
    final keywordsOk = PanVerifier.verify(extractedText);
    // // 5. Final decision
    return numberMatch && keywordsOk;
  }

  Future<bool> verifyGstDocument(File gstImageFile) async {
    // final extractedText = await OcrFiles.extractTextFromImage(gstImageFile);
    var extractedText = '';
    if(gstImageFile.path.toLowerCase().endsWith(".pdf")){
      extractedText = await OcrFiles.extractTextFromPdf(gstImageFile) ?? '';
    }else{
      extractedText = await OcrFiles.extractTextFromImage(gstImageFile) ?? '';
    }
    DebugConfig.debugLog('Extracted :: $extractedText');
    if (extractedText.isEmpty) {
      return false;
    }
    // Step 2: Verify GST text
    final isValid = GstVerifier.verify(extractedText);
    return isValid;
  }

  Future<bool> verifyCompRegAccount(File compFile) async {
    // final extractedText = await OcrFiles.extractTextFromImage(compFile);
    var extractedText = '';
    if(compFile.path.toLowerCase().endsWith(".pdf")){
      extractedText = await OcrFiles.extractTextFromPdf(compFile) ?? '';
    }else{
      extractedText = await OcrFiles.extractTextFromImage(compFile) ?? '';
    }
    if (extractedText.isEmpty) {
      return false;
    }
    // Step 2: Verify GST text
    final isValid = CompanyRegVerifier.verify(extractedText.toLowerCase());
    return isValid;
  }

  Future<bool> verifyCheque(File chequeImageFile) async {
    // final extractedText = await OcrFiles.extractTextFromImage(chequeImageFile);
    var extractedText = '';
    if(chequeImageFile.path.toLowerCase().endsWith(".pdf")){
      extractedText = await OcrFiles.extractTextFromPdf(chequeImageFile) ?? '';
    }else{
      extractedText = await OcrFiles.extractTextFromImage(chequeImageFile) ?? '';
    }
    if (extractedText == null || extractedText.isEmpty) {
      return false;
    }
    // Step 2: Verify Cheque text
    final isValid = ChequeVerifier.verify(extractedText, widget.vm.cancelChequeCntlr.text);

    return isValid;
  }

  String? validateImage(WidgetRef ref, String key, String? path) {
    final status = ref.read(widget.vm.isVerifiedImages)[key];
    final isGstRegistered = ref.read(widget.vm.isGstRegistered.notifier).state;
    final compType = ref.read(widget.kycVm.profileDetails.notifier).state['comp_type'];

    // Aadhaar special case → handled as a group
    if (key == 'aadhar_front' || key == 'aadhar_back') {
      final aadhar = ref.read(widget.vm.aadharImage.notifier).state;
      final front = aadhar['aadhar_front'];
      final back = aadhar['aadhar_back'];

      if (front == null || front.isEmpty || back == null || back.isEmpty) {
        return "Please upload both Front & Back";
      }
      return null; // ✅ Both uploaded, no error
    }

    // PAN is always required
    if (key == 'pan') {
      if (path == null || path.isEmpty) return "Please upload PAN";
    }

    // GST required only if GST is registered
    if (key == 'gst' && isGstRegistered) {
      if (path == null || path.isEmpty) return "Please upload GST";
    }

    // Company Registration required only if compType != 4
    if (key == 'comp_reg' && compType != '4') {
      if (path == null || path.isEmpty) return "Please upload Company Registration";
    }

    // Cheque is always required (since you have _buildBox for it unconditionally)
    if (key == 'cheque') {
      if (path == null || path.isEmpty) return "Please upload Cancelled Cheque";
    }

    // If verification failed
    if (status == '1') {
      return "Verification failed. Please re-upload.";
    }

    return null; // ✅ valid
  }

  Future<void> _checkAndVerifyDocuments(WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true;

    final verifiedImages = ref.read(widget.vm.isVerifiedImages);
    final adhar = ref.read(widget.vm.aadharImage);
    final pan = ref.read(widget.vm.panImage);
    final gst = ref.read(widget.vm.gstImage);
    final compReg = ref.read(widget.vm.compRegImage);
    final cheque = ref.read(widget.vm.cancelChequeImage);

    // Aadhaar-front
    if (adhar['aadhar_front'] != null && widget.vm.aadharCntlr.text.isNotEmpty) {
      if (verifiedImages['aadhar_front'] == '3') { // only if pending verification
        bool result = await verifyAadharFront(
          File(adhar['aadhar_front']!),
          widget.vm.aadharCntlr.text,
        );
        widget.vm.updateImageStatus(ref, 'aadhar_front', result ? '2' : '1');
      }
    }

    // Aadhaar-back
    if (adhar['aadhar_back'] != null && widget.vm.aadharCntlr.text.isNotEmpty) {
      if (verifiedImages['aadhar_back'] == '3') {
        bool result = await verifyAadharBack(
          File(adhar['aadhar_back']!),
          widget.vm.aadharCntlr.text,
        );
        widget.vm.updateImageStatus(ref, 'aadhar_back', result ? '2' : '1');
      }
    }

    // PAN
    if (pan != null && widget.vm.panCntlr.text.isNotEmpty) {
      if (verifiedImages['pan'] == '3') {
        bool result = await verifyPan(File(pan), widget.vm.panCntlr.text);
        widget.vm.updateImageStatus(ref, 'pan', result ? '2' : '1');
      }
    }

    // GST
    if (gst != null) {
      if (verifiedImages['gst'] == '3') {
        bool result = await verifyGstDocument(File(gst));
        widget.vm.updateImageStatus(ref, 'gst', result ? '2' : '1');
      }
    }

    // Company Registration
    if (compReg != null) {
      if (verifiedImages['comp_reg'] == '3') {
        bool result = await verifyCompRegAccount(File(compReg));
        widget.vm.updateImageStatus(ref, 'comp_reg', result ? '2' : '1');
      }
    }

    // Cheque
    if (cheque != null) {
      if (verifiedImages['cheque'] == '3') {
        bool result = await verifyCheque(File(cheque));
        widget.vm.updateImageStatus(ref, 'cheque', result ? '2' : '1');
      }
    }

    ref.read(loadingProvider.notifier).state = false;
  }

  Widget _buildSaveButton({
    required WidgetRef ref,
    required double screenHeight,
    required Map<String, String> clientDetails
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final hasConnection = ref.watch(internetProvider).hasConnection;

        return AppButtons.buildContainerButton(
          text: AppStrings.save,
          height: screenHeight * 0.045,
          onTap: () async {
            if (!hasConnection) return;

            if (!widget.vm.docFormKey.currentState!.validate()) {
              return;
            }

            final aadhar = ref.read(widget.vm.aadharImage);

            // validate images
            final images = {
              "aadhar_front": aadhar["aadhar_front"],
              "aadhar_back": aadhar["aadhar_back"],
              "pan": ref.read(widget.vm.panImage),
              "gst": ref.read(widget.vm.gstImage),
              "comp_reg": ref.read(widget.vm.compRegImage),
              "cheque": ref.read(widget.vm.cancelChequeImage),
            };

            final errors = <String, String?>{};
            images.forEach((key, path) {
              errors[key] = validateImage(ref, key, path);
            });
            ref.read(widget.vm.imageErrors.notifier).state = errors;

            if (errors.values.any((msg) => msg != null)) {
              return;
            }

            DebugConfig.debugLog("✅ Form validated successfully");

            await _checkAndVerifyDocuments(ref);

            final verifiedImages = ref.read(widget.vm.isVerifiedImages);
            final verifiedDocs = verifiedImages.entries
                .where((e) => e.value == '2')
                .map((e) => e.key)
                .toList();

            final failedDocs = verifiedImages.entries
                .where((e) => e.value != '2')
                .map((e) => e.key)
                .toList();

            final allVerified = failedDocs.isEmpty;

            final profile = ref.read(widget.kycVm.profileDetails.notifier).state;
            final compType = profile['comp_type'].toString(); // "1","2","3","4"
            final isIndividual = compType == '4';
            // final isGstReq = ref.read(widget.vm.isGstRegistered.notifier).state;

            bool allowUpload = false;

            if (allVerified) {
              allowUpload = true;
            } else if (isIndividual) {
              // Individual → GST optional, Company Reg not needed
              allowUpload = true;
            } else {
              // Companies (1,2,3) → require GST AND Company Registration
              final gstOk = verifiedDocs.contains("gst");
              final regOk = verifiedDocs.contains("comp_reg");
              allowUpload = gstOk && regOk;
            }

            if (allowUpload) {
              DebugConfig.debugLog("✅ Uploading KYC. Verified: $verifiedDocs | Failed: $failedDocs");
              await widget.vm.uploadKycDetails(
                  loaderRef: ref,
                  profileVm: widget.profileVm,
                  clientDetails: clientDetails
              );
            } else {
              DebugConfig.debugLog("🚫 Upload blocked. GST + Company Reg are mandatory for companies.");
              DebugConfig.debugLog("✅ Uploading Failed: $failedDocs");
            }
          },
        );
      },
    );
  }

  // 🔹 Build Box
  Widget _buildBox({
    String? heading,
    String? label,
    String? hint,
    required int target,
    required TextEditingController controller,
    required StateProvider<String?> imageVar,
    void Function(String)? onChanged,
    String? Function(String?)? customValidator,
    String? docKey,
    required double screenWidth,
    required double screenHeight,
    required double textScale,
  }) {

    bool isBigSize = screenWidth >= 550;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.04),
        Card(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.buildTextField(
                      label: label ?? '',
                      controller: controller,
                      hint: hint ?? '',
                      onChanged: onChanged,
                      labelFontWeight: FontWeight.w600,
                      keyboardType: target == 1 || target == 5
                          ? TextInputType.number
                          : TextInputType.text,
                      validator: true,
                      customValidator: (v) {
                        final base = customValidator?.call(v);
                        if (base != null) return base;

                        if (docKey != null) {
                          final status = ref.watch(
                              widget.vm.isVerifiedImages)[docKey];
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(target == 1
                            ? 14
                            : target == 2
                            ? 15
                            : target == 3
                            ? 10
                            : target == 4
                            ? 21
                            : target == 5 ? 6 : 0),
                        FilteringTextInputFormatter.allow(RegExp(
                            target == 1 || target == 5 ? r'[0-9]' : r'[a-zA-Z0-9]')),
                        UpperCaseTextFormatter(),
                        if (target == 1) AadhaarNumberFormatter(),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.012),
                    // if (target == 3 && panStatus?.data != null)
                    Consumer(builder: (key, ref, child){
                      final panStatus = ref.read(widget.vm.isPanVerifiedData.notifier).state;
                      final gstStatus = ref.read(widget.vm.isGstVerifiedData.notifier).state;
                      if((target == 3 && panStatus?.data != null) || (target == 2 && gstStatus != null)) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.lightGreen.shade100),
                          ),
                          child: MyTextStyles.getRegularText(
                            text: target == 3 ? panStatus?.data?.status == 1
                                ? 'PAN is Verified'
                                : (panStatus?.data?.errorMsg?.isNotEmpty == true
                                ? panStatus!.data!.errorMsg ?? ''
                                : 'PAN verification failed') : gstStatus?.success == true ? 'GST is Verified' : gstStatus?.message ?? '',
                          ),
                        );}
                      else{
                        return SizedBox.shrink();
                      }
                    }),
                  ],
                ),
                SizedBox(height: screenHeight * 0.006),
                if(target != 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Consumer(builder: (key, ref, child) {
                        final pickedImage =
                            ref.watch(imageVar.notifier).state;
                        bool isPdf = pickedImage != null && pickedImage.isNotEmpty && pickedImage.contains(".pdf");
                        return SizedBox(
                            height: isBigSize ? screenHeight * 0.145 : screenHeight * 0.15,
                            width: isBigSize ? screenWidth * 0.3 : screenWidth * 0.46,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.12,
                                  width: isBigSize ? screenWidth * 0.25 : screenWidth * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: pickedImage != null &&
                                        pickedImage.isNotEmpty
                                        ? GestureDetector(
                                      onTap: () {
                                        showImagePreviewDialog(
                                            context: context,
                                            imagePath: pickedImage);
                                      },
                                      child: isPdf ? Icon(Icons.picture_as_pdf, size: 32, color: Colors.green,) : Image.file(
                                        File(pickedImage),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                        : const Icon(Icons.image, size: 32),
                                  ),
                                ),
                                if (pickedImage != null)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: isBigSize ? screenHeight * 0.025 : screenHeight * 0.03,  // e.g., 3% of screen height
                                      width: isBigSize ? screenWidth * 0.05 : screenWidth * 0.06,    // e.g., 6% of screen width
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(screenWidth * 0.04),  // radius scaled to width
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () => removeImageAndResetConditions(ref, docKey ?? ''),
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: screenHeight * 0.02,  // icon scaled w.r.t height
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),  // let icon size control widget size
                                      ),
                                    ),
                                  ),

                              ],
                            ));
                      }),

                      SizedBox(height: screenHeight * 0.006),
                      AppButtons.buildContainerButton(
                          text: AppStrings.upload,
                          height: isBigSize ? 50 : screenHeight * 0.045,
                          width: isBigSize ? 100 : screenWidth * 0.18,
                          size: textScale * 12, onTap: () async {
                        widget.vm.onSelectImage(
                            ref: ref, context: context, target: target, dockey: docKey ?? '');
                      }),
                    ],
                  ),
                if(target == 1)
                  Consumer(builder: (key, ref, child) {
                    // final pickedImage = ref.watch(imageVar.notifier).state;
                    final pickedImage = ref.watch(widget.vm.aadharImage);//['aadhar_front']
                    return SizedBox(
                      height: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAadharView(pickedImage: pickedImage, screenWidth: screenWidth, textScale: textScale, docKey: 'aadhar_front', buttonText: 'Front', target: target),
                          _buildAadharView(pickedImage: pickedImage, screenWidth: screenWidth, textScale: textScale, docKey: 'aadhar_back', buttonText: AppStrings.back, target: target),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     SizedBox(
                          //         height: 100,
                          //         width: 90,
                          //         child: Stack(
                          //           alignment: Alignment.center,
                          //           children: [
                          //             Container(
                          //               height: 75,
                          //               width: 70,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.grey.shade300,
                          //                 borderRadius: BorderRadius.circular(12),
                          //               ),
                          //               child: ClipRRect(
                          //                 borderRadius: BorderRadius.circular(12),
                          //                 child: pickedImage['aadhar_front'] != null &&
                          //                     pickedImage['aadhar_front']!.isNotEmpty
                          //                     ? GestureDetector(
                          //                   onTap: () {
                          //                     showImagePreviewDialog(
                          //                         context: context,
                          //                         imagePath: pickedImage['aadhar_front'] ?? '');
                          //                   },
                          //                   child: Image.file(
                          //                     File(pickedImage['aadhar_front'] ?? ''),
                          //                     fit: BoxFit.cover,
                          //                   ),
                          //                 )
                          //                     : const Icon(Icons.image, size: 32),
                          //               ),
                          //             ),
                          //             if (pickedImage['aadhar_front'] != null)
                          //               Positioned(
                          //                 top: 0,
                          //                 right: 0,
                          //                 child: Container(
                          //                   height: 24,  // e.g., 3% of screen height
                          //                   width: 24,    // e.g., 6% of screen width
                          //                   decoration: BoxDecoration(
                          //                     color: Colors.red,
                          //                     borderRadius: BorderRadius.circular(screenWidth * 0.04),  // radius scaled to width
                          //                     boxShadow: [
                          //                       BoxShadow(
                          //                         color: Colors.black26,
                          //                         blurRadius: 2,
                          //                         offset: Offset(0, 1),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                   child: IconButton(
                          //                     onPressed: () => removeImageAndResetConditions(ref, "aadhar_front" ?? ''),
                          //                     icon: Icon(
                          //                       Icons.close,
                          //                       color: Colors.white,
                          //                       size: 16,  // icon scaled w.r.t height
                          //                     ),
                          //                     padding: EdgeInsets.zero,
                          //                     constraints: BoxConstraints(),  // let icon size control widget size
                          //                   ),
                          //                 ),
                          //               ),
                          //
                          //           ],
                          //         )),
                          //     SizedBox(height: 10,),
                          //     AppButtons.buildContainerButton(
                          //         text: "Front",
                          //         height: 30,
                          //         width: 70,
                          //         size: textScale * 12, onTap: () async {
                          //       widget.vm.onSelectImage(
                          //           ref: ref, context: context, target: target, dockey: 'aadhar_front');
                          //     }),
                          //   ],
                          // ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     SizedBox(
                          //         height: 100,
                          //         width: 90,
                          //         child: Stack(
                          //           alignment: Alignment.center,
                          //           children: [
                          //             Container(
                          //               height: 72,
                          //               width: 70,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.grey.shade300,
                          //                 borderRadius: BorderRadius.circular(12),
                          //               ),
                          //               child: ClipRRect(
                          //                 borderRadius: BorderRadius.circular(12),
                          //                 child: pickedImage['aadhar_back'] != null &&
                          //                     pickedImage['aadhar_back']!.isNotEmpty
                          //                     ? GestureDetector(
                          //                   onTap: () {
                          //                     showImagePreviewDialog(
                          //                         context: context,
                          //                         imagePath: pickedImage['aadhar_back'] ?? '');
                          //                   },
                          //                   child: Image.file(
                          //                     File(pickedImage['aadhar_back'] ?? ''),
                          //                     fit: BoxFit.cover,
                          //                   ),
                          //                 )
                          //                     : const Icon(Icons.image, size: 32),
                          //               ),
                          //             ),
                          //             if (pickedImage['aadhar_back'] != null)
                          //               Positioned(
                          //                 top: 0,
                          //                 right: 0,
                          //                 child: Container(
                          //                   height: 24,  // e.g., 3% of screen height
                          //                   width: 24,    // e.g., 6% of screen width
                          //                   decoration: BoxDecoration(
                          //                     color: Colors.red,
                          //                     borderRadius: BorderRadius.circular(screenWidth * 0.04),  // radius scaled to width
                          //                     boxShadow: [
                          //                       BoxShadow(
                          //                         color: Colors.black26,
                          //                         blurRadius: 2,
                          //                         offset: Offset(0, 1),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                   child: IconButton(
                          //                     onPressed: () => removeImageAndResetConditions(ref, 'aadhar_back' ?? ''),
                          //                     icon: Icon(
                          //                       Icons.close,
                          //                       color: Colors.white,
                          //                       size: 16,  // icon scaled w.r.t height
                          //                     ),
                          //                     padding: EdgeInsets.zero,
                          //                     constraints: BoxConstraints(),  // let icon size control widget size
                          //                   ),
                          //                 ),
                          //               ),
                          //
                          //           ],
                          //         )),
                          //     SizedBox(height: 10,),
                          //     AppButtons.buildContainerButton(
                          //         text: AppStrings.back,
                          //         height: 30,
                          //         width: 70,
                          //         size: textScale * 12, onTap: () async {
                          //       widget.vm.onSelectImage(
                          //           ref: ref, context: context, target: target, dockey: 'aadhar_back');
                          //     }),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  }),
                SizedBox(height: screenHeight * 0.01),
                Consumer(
                  builder: (context, ref, child) {
                    final errors = ref.watch(widget.vm.imageErrors);
                    final statuses = ref.watch(widget.vm.isVerifiedImages);

                    String? errorMsg;
                    String? status;

                    if (target == 1) {
                      // Aadhaar → just check once for overall error
                      errorMsg = errors['aadhar_front'] ?? errors['aadhar_back'];
                      if (errorMsg != null) {
                        if(errorMsg == 'unsupported'){
                          errorMsg = AppStrings.unsupportedFileType;
                        }else if(errorMsg == 'large_size'){
                          errorMsg = AppStrings.fileMaxSize;
                        }else{
                          errorMsg = AppStrings.pleaseUploadBothFrontAndBack;
                        }
                      }

                      // statuses merged same as before
                      final statusFront = statuses['aadhar_front'];
                      final statusBack = statuses['aadhar_back'];

                      // 🔹 Decide Aadhaar overall status
                      if (statusFront == '2' && statusBack == '2') {
                        status = '2'; // ✅ Both verified → Verified
                      } else if (statusFront == '1' || statusBack == '1') {
                        status = '1'; // ❌ Any failed → Failed
                      } else if (statusFront == '3' || statusBack == '3') {
                        status = '3'; // ⏳ Either pending → Pending
                      } else {
                        status = null; // Not uploaded
                      }
                    } else {
                      errorMsg = errors[docKey];
                      if (errorMsg == 'unsupported') {
                        errorMsg = AppStrings.unsupportedFileType;
                      }else if(errorMsg == 'large_size'){
                        errorMsg = AppStrings.fileMaxSize;
                      }
                      status = statuses[docKey];
                    }

                    // 🔹 Show messages
                    if (errorMsg != null) {
                      return MyTextStyles.getRegularText(
                        text: errorMsg,
                        clr: Colors.red,
                        size: textScale * 12,
                      );
                    }
                    if (status == '1') {
                      return MyTextStyles.getRegularText(
                        text: AppStrings.verificationFailed,
                        clr: Colors.red,
                        size: textScale * 12,
                      );
                    }
                    if (status == '2') {
                      return MyTextStyles.getRegularText(
                        text: AppStrings.verified,
                        clr: Colors.green,
                        size: textScale * 12,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void removeImageAndResetConditions(WidgetRef ref, String key) {
    // Remove the image path based on key
    switch (key) {
      case "aadhar_front":
        ref.read(widget.vm.aadharImage.notifier).state['aadhar_front'] = null;
        break;
      case "aadhar_back":
        ref.read(widget.vm.aadharImage.notifier).state['aadhar_back'] = null;
        break;
      case "pan":
        ref.read(widget.vm.panImage.notifier).state = null;
        break;
      case "gst":
        ref.read(widget.vm.gstImage.notifier).state = null;
        break;
      case "comp_reg":
        ref.read(widget.vm.compRegImage.notifier).state = null;
        break;
      case "cheque":
        ref.read(widget.vm.cancelChequeImage.notifier).state = null;
        break;
      default:
      // Unknown key, optionally log or throw error
        return;
    }

    // Also reset any related errors if you track those
    final errors = ref.read(widget.vm.imageErrors.notifier).state;
    if (errors.containsKey(key)) {
      errors[key] = null;
      ref.refresh(widget.vm.imageErrors.notifier).state = Map<String, String?>.from(errors);
    }

    // Reset verification status for the same key
    final currentVerifications = ref.read(widget.vm.isVerifiedImages.notifier).state;
    final updatedVerifications = Map<String, String?>.from(currentVerifications);
    if (updatedVerifications.containsKey(key)) {
      updatedVerifications[key] = null;
      ref.read(widget.vm.isVerifiedImages.notifier).state = updatedVerifications;
    }
  }

  Widget _buildAadharView({required Map<String, String?> pickedImage, required double screenWidth, required double textScale, required String docKey, required String buttonText, required int target,}){
    bool isPdf = pickedImage[docKey] != null && pickedImage[docKey]!.isNotEmpty && pickedImage[docKey]!.contains(".pdf");
    final isBig = screenWidth >= 550;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 100,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 75,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: pickedImage[docKey] != null &&
                        pickedImage[docKey]!.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        showImagePreviewDialog(
                            context: context,
                            imagePath: pickedImage[docKey] ?? '');
                      },
                      child: isPdf ? Icon(Icons.picture_as_pdf, size: 32, color: Colors.green,) : Image.file(
                        File(pickedImage[docKey] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(Icons.image, size: 32),
                  ),
                ),
                if (pickedImage[docKey] != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 24,  // e.g., 3% of screen height
                      width: 24,    // e.g., 6% of screen width
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),  // radius scaled to width
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => removeImageAndResetConditions(ref, docKey),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,  // icon scaled w.r.t height
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),  // let icon size control widget size
                      ),
                    ),
                  ),

              ],
            )),
        SizedBox(height: 10,),
        AppButtons.buildContainerButton(
            text: buttonText,
            height: isBig ? 45 :30,
            width: 70,
            size: textScale * 12, onTap: () async {
          widget.vm.onSelectImage(
              ref: ref, context: context, target: target, dockey: docKey);
        }),
      ],
    );
  }
}
