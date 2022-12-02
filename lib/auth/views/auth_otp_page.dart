import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:vibank/auth/bloc/token_bloc.dart';
import 'package:vibank/repo/auth_repo.dart';

class AuthOTPPage extends StatefulWidget {
  const AuthOTPPage({
    Key? key,
    required this.id,
    required this.phone,
  }) : super(key: key);

  static Route route({required String id, required String phone}) {
    return MaterialPageRoute<void>(
      builder: (_) => AuthOTPPage(id: id, phone: phone),
    );
  }

  final String id;
  final String phone;

  @override
  State<AuthOTPPage> createState() => _AuthOTPPageState();
}

class _AuthOTPPageState extends State<AuthOTPPage> {
  bool _resend = false;
  String code = '';
  // ignore: unused_field
  late Timer _timer;
  int _duration = 30;

  void onResend() {
    setState(() {
      _resend = true;
    });

    const second = Duration(seconds: 1);

    _timer = Timer.periodic(second, (timer) {
      setState(() {
        if (_duration == 0) {
          _duration = 30;
          _resend = false;
          timer.cancel();
        } else {
          _duration--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TokenBloc(authRepo: RepositoryProvider.of<AuthRepo>(context)),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<TokenBloc, TokenState>(
            listener: (context, state) {
              if (state is TokenLoading) {
                showDialog<String>(
                  //barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => const SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
                  ),
                );
              }

              if (state is TokenError) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        /* Image.asset(
                          'assets/images/lock.png',
                          width: 200,
                          fit: BoxFit.cover,
                        ), */
                        const SizedBox(height: 50),
                        const Text(
                          'Verification',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                'Please enter the verification code',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                'sent to your phone number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Pinput(
                          length: 6,
                          keyboardType: TextInputType.number,
                          forceErrorState: state is TokenError ? true : false,
                          /* errorText: state is TokenError ? state.message : null,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi, */
                          onCompleted: (code) {
                            context.read<TokenBloc>().add(ValidateToken(
                                  id: widget.id,
                                  code: code,
                                ));
                          },
                          senderPhoneNumber: 'AUTHMSG',
                        ),
                        const SizedBox(height: 30),
                        _resend
                            ? SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Resend code in 0:',
                                      style: TextStyle(
                                          color: Colors.grey.shade500),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: Text(
                                        _duration.toString(),
                                        style: TextStyle(
                                            color: Colors.grey.shade500),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Didn\'t receive an SMS yet?',
                                      style: TextStyle(
                                          color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(width: 5),
                                    TextButton(
                                      onPressed: () {
                                        if (_resend) return;
                                        onResend();
                                      },
                                      child: const Text(
                                        'Resend',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Change phone number'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
