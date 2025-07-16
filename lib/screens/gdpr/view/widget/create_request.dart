import 'package:bagisto_app_demo/screens/gdpr/bloc/gdpr_bloc.dart';
import 'package:bagisto_app_demo/screens/gdpr/bloc/gdpr_event.dart';
import 'package:bagisto_app_demo/screens/review/utils/index.dart';
import 'package:flutter/material.dart';

enum GdprRequestType {
  DELETE,
  UPDATE,
}

class CreateRequestModal extends StatelessWidget {
  final GdprBloc? gdprBloc;
  final String customerEmail;

  const CreateRequestModal(
      {super.key, this.gdprBloc, required this.customerEmail});

  @override
  Widget build(BuildContext context) {
    Enum selectedType = GdprRequestType.UPDATE;
    String message = "";
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController messageController = TextEditingController();

    Future<void> createGdprRequest() async {
      if (!_formKey.currentState!.validate()) {
        // If the form is not valid, do not proceed
      } else {
        if (gdprBloc != null) {
          gdprBloc!.add(CreateGdprRequest(
            type: selectedType,
            message: message.trim(),
          ));
          Navigator.of(context).pop();
        }
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.createNewRequest.localized(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<Enum>(
                          decoration: InputDecoration(
                            labelText: "Type *",
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).dividerColor)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    width: 1, color: MobiKulTheme.greyColor)),
                          ),
                          value: selectedType,
                          hint: Text(StringConstants.selectType.localized()),
                          dropdownColor: Theme.of(context).primaryColorLight,
                          items: [
                            DropdownMenuItem(
                                value: GdprRequestType.DELETE,
                                child:
                                    Text(StringConstants.delete.localized())),
                            DropdownMenuItem(
                                value: GdprRequestType.UPDATE,
                                child:
                                    Text(StringConstants.update.localized())),
                          ],
                          onChanged: (value) {
                            setState(() =>
                                selectedType = value ?? GdprRequestType.UPDATE);
                          },
                        ),
                        const SizedBox(height: 20),

                        // Message TextField

                        TextFormField(
                          controller: messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText:
                                '${StringConstants.message.localized()} *',
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).dividerColor)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ),
                          onChanged: (value) {
                            message = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Message is required.";
                            }

                            return null;
                          },
                        ),
                      ],
                    )),

                // Dropdown

                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MobiKulTheme.linkColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      // Submit logic here
                      await createGdprRequest();
                    },
                    child: Text(
                      StringConstants.save.localized(),
                      style: TextStyle(
                        color: MobiKulTheme.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
