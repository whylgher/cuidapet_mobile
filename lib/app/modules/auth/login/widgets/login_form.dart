part of '../login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _loginEC = TextEditingController();

  final _passwordEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _controller = Modular.get<LoginController>();

  @override
  void dispose() {
    _loginEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CuidapetTextFormField(
            controller: _loginEC,
            label: 'Login',
            validator: Validatorless.multiple([
              Validatorless.required('Login obrigatório.'),
              Validatorless.email('e-mail inválido.'),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          CuidapetTextFormField(
            controller: _passwordEC,
            label: 'Senha',
            obscureText: true,
            validator: Validatorless.multiple(
              [
                Validatorless.required('Senha obrigatória.'),
                Validatorless.min(6, 'Senha tem que ter pelo menos 6 dígitos'),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CuidapetDefaultButton(
            label: 'Entrar',
            onPressed: () async {
              final formValid = _formKey.currentState?.validate() ?? false;
              if (formValid) {
                await _controller.login(_loginEC.text, _passwordEC.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
