import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/auth/view/pages/sign_up_page.dart';
import 'package:client/fetures/auth/view/widgets/auth_gradiant_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/fetures/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/fetures/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider.select((val)=>val?.isLoading==true));
     ref.listen(
      authViewmodelProvider,
      (_, next) {
        next?.when(
            data: (data) {
              Navigator.pushAndRemoveUntil(context,HomePage.route(),(_)=>false );
            },
            error: (error, st) {
            showSnackBar(context, error.toString());
            },
            loading: () {});
      },
    );
    return Scaffold(
      body: isLoading?const Loader(): Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Log In.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomField(
                hintText: "Email",
                controller: emailController,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomField(
                hintText: "Password",
                controller: passwordController,
                isobsecureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradiantButton(
                buttonText: 'Log In',
                onpressed: () async {
                  if(formKey.currentState!.validate()){

                 await ref.read(authViewmodelProvider.notifier).LoginUser(email: emailController.text, password: passwordController.text);
                  }
                  else{
                    showSnackBar(context, 'missing fields!');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, SignUpPage.route());
                },
                child: RichText(
                    text: TextSpan(
                        text: "Don't have account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                      TextSpan(
                        text: ' Sign up',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold),
                      )
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/* body: 
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
              if(state is AuthFailure){
              showSnackBar(context, state.message);
            }else if(state is AuthSuccess){
              Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route)=>false);
            } 
          },
          builder: (context, state) {
             if(state is AuthLoaing){
              return const Loader();
            }  
            return 
                  )
                ],
              ),
            );
          },
        ),
      ),
 */