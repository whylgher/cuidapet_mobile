import 'package:flutter/material.dart';

import '../../../core/ui/extensions/size_screen_extension.dart';
import '../../../core/ui/extensions/theme_extension.dart';
import '../../../core/ui/icons/cuidapet_icons.dart';
import '../../../core/ui/widgets/cuidapet_default_button.dart';
import '../../../core/ui/widgets/cuidapet_text_form_field.dart';
import '../../../core/ui/widgets/loader.dart';
import '../../../core/ui/widgets/rounded_button_with_icon.dart';

part 'widgets/login_form.dart';
part 'widgets/login_register_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 162.w,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const _LoginForm(),
              const SizedBox(
                height: 8,
              ),
              const _OrSerparator(),
              const SizedBox(
                height: 8,
              ),
              const _LoginRegisterButtons()
            ],
          ),
        ),
      ),
    );
  }
}

class _OrSerparator extends StatelessWidget {
  const _OrSerparator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: context.primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'OU',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: context.primaryColor),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: context.primaryColor,
          ),
        ),
      ],
    );
  }
}
