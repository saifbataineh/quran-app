import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/fetures/auth/view/pages/login_page.dart';
import 'package:client/fetures/auth/view/widgets/auth_gradiant_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/fetures/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
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
              showSnackBar(
                  context, "Account created successfully,please login");
              Navigator.push(context, LoginPage.route());
            },
            error: (error, st) {
              showSnackBar(context, error.toString());
            },
            loading: () {});
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading
              ? const Loader()
              : Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomField(
                        hintText: "Name",
                        controller: nameController,
                      ),
                      const SizedBox(
                        height: 15,
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
                        buttonText: "Sign Up",
                        onpressed: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewmodelProvider.notifier)
                                .signUpUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text);
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
                          Navigator.push(context, LoginPage.route());
                        },
                        child: RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                              TextSpan(
                                text: ' Sign in',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: AppPallete.gradient2,
                                        fontWeight: FontWeight.bold),
                              )
                            ])),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
/* 
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is AuthFailure){
              showSnackBar(context, state.message);
            }
            else if(state is AuthSuccess){
              Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route)=>false);
            } 
          
          },
          builder: (context, state) {
            if(state is AuthLoaing){
              return const Loader();
            }
                      
                     
                     
                      
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,LoginPage.route() );
                        },*/
  

    