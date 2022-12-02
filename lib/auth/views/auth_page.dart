import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibank/auth/bloc/signin_bloc.dart';
import 'package:vibank/auth/views/auth_otp_page.dart';
import 'package:vibank/repo/auth_repo.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AuthPage());
  }

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String phone = '0886746522';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SigninBloc(authRepo: RepositoryProvider.of<AuthRepo>(context)),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: BlocConsumer<SigninBloc, SigninState>(
                listener: (context, state) {
                  if (state is SigninFailed) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(state.message)));
                  }

                  if (state is SigninSuccess) {
                    Navigator.push(
                      context,
                      AuthOTPPage.route(
                        id: state.user.id,
                        phone: state.user.phone,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          /* Image.asset(
                            'assets/images/cover.png',
                            width: 200,
                            fit: BoxFit.cover,
                          ), */
                          const SizedBox(height: 50),
                          const Text(
                            'Get Started',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Enter your phone number to continue, we will send you OTP to verify',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Stack(
                            children: [
                              TextFormField(
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9,]+')),
                                ],
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.green,
                                  )),
                                  contentPadding:
                                      const EdgeInsets.only(left: 60),
                                  hintText: 'Enter phone number',
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, left: 15),
                                child: Text(
                                  '+265',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 46,
                            onPressed: state is SigninLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<SigninBloc>().add(
                                            RequestSignin(
                                              phone: phone,
                                              country: 'mw',
                                            ),
                                          );
                                    }
                                  },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            color: Colors.black,
                            disabledColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: state is SigninLoading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
