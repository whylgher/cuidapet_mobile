part of '../register_page.dart';

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final controller = Modular.get<RegisterController>();

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
            label: 'Login',
            controller: _loginEC,
            validator: Validatorless.multiple([
              Validatorless.required('Login obrigatório!'),
              Validatorless.email('e-mail inválido!'),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          CuidapetTextFormField(
            label: 'Senha',
            controller: _passwordEC,
            obscureText: true,
            validator: Validatorless.multiple([
              Validatorless.required('Senha obrigatória'),
              Validatorless.min(6, 'A senha precisa ser maior que 6 dígitos'),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          CuidapetTextFormField(
            label: 'Confirmar Senha',
            obscureText: true,
            validator: Validatorless.multiple([
              Validatorless.required('Confirmar senha obrigatória'),
              Validatorless.min(6, 'A senha precisa ser maior que 6 dígitos'),
              Validatorless.compare(_passwordEC, 'Senhas diferentes.'),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          CuidapetDefaultButton(
            label: 'Cadastrar',
            onPressed: () {
              final formValid = _formKey.currentState?.validate() ?? false;

              if (formValid) {
                controller.register(
                  email: _loginEC.text,
                  password: _passwordEC.text,
                );
              }
            },
          )
        ],
      ),
    );
  }
}
