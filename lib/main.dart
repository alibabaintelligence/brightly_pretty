import 'package:brightly_pretty/providers/manzanares_provider.dart';
import 'package:brightly_pretty/screens/course_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // const iconSvgLoader = SvgAssetLoader('assets/svgs/user_icon.svg');
  // svg.cache.putIfAbsent(
  //   iconSvgLoader.cacheKey(null),
  //   () => iconSvgLoader.loadBytes(null),
  // );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const BrightlyApp());
}

class BrightlyApp extends StatelessWidget {
  const BrightlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider<FirebaseAuthProvider>(
        //   create: (context) => FirebaseAuthProvider(),
        // ),
        ChangeNotifierProvider<ManzanaresProvider>(
          create: (context) => ManzanaresProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(248, 248, 250, 1.0),
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: const ColorScheme.light(
            error: Color.fromARGB(255, 255, 0, 43),
            background: Colors.white,
            onBackground: Colors.black,
            primary: Colors.black,
            onPrimary: Colors.black,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Colors.black.withOpacity(0.2),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
            size: 30,
          ),
        ),
        scrollBehavior: const CupertinoScrollBehavior(),
        routes: {
          '/': (context) => const AuthWrapper(),
          // ContactScreen.routeName: (context) => const ContactScreen(),
          // FAQScreen.routeName: (context) => const FAQScreen(),
          // NotificationsScreen.routeName: (context) =>
          //     const NotificationsScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _manzanaresProvider = context.watch<ManzanaresProvider>();

  late final _getCoursesFuture = _manzanaresProvider.getCourses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getCoursesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(),
                  ..._manzanaresProvider.courses.map(
                    (course) => CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseScreen(
                              courseId: course.courseId,
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      minSize: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 188, 198, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.shade100,
                              offset: const Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 22,
                          horizontal: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 86, 0, 184),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              course.desc,
                              style: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 86, 0, 184),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<ManzanaresProvider>().currentUser;

    if (currentUser == null) {
      return const AuthScreen();
    } else {
      return const HomeScreen();
    }
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  // Login
  final _loginKey = GlobalKey<FormState>();
  final _loginEmailController = TextEditingController();
  // final _loginPasswordController = TextEditingController();

  // Sign up
  // final _signUpKey = GlobalKey<FormState>();
  // final _signUpEmailController = TextEditingController();
  // final _signUpPasswordController = TextEditingController();
  // final _signUpConfirmPasswordController = TextEditingController();

  late final _manzanaresProvider = context.read<ManzanaresProvider>();

  // bool _login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _loginKey,
        child: Center(
          child: FutureBuilder(
              future: _manzanaresProvider.getUser(
                  email: 'correoalumno@escuela.com'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      // Assets.textLogoRed(width: 130),
                      const SizedBox(height: 50),
                      const Text(
                        "¡Bienvenido de vuelta!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Correo Electrónico',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: const Color.fromARGB(255, 239, 239, 239),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: TextFormField(
                              controller: _loginEmailController,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Escribe aquí...',
                              ),
                              buildCounter: (
                                context, {
                                required int currentLength,
                                required bool isFocused,
                                required int? maxLength,
                              }) =>
                                  null,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: (email) {
                                final String? trimmedEmail = email?.trim();

                                if (trimmedEmail == null ||
                                    trimmedEmail.isEmpty) {
                                  return "Escribe algo";
                                }
                                if (!EmailValidator.validate(trimmedEmail)) {
                                  return "Correo inválido";
                                }
                                return null;
                              },
                            ),
                          ),
                          // const SizedBox(height: 16),
                          // const Text(
                          //   'Contraseña',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(13),
                          //     color: const Color.fromARGB(255, 239, 239, 239),
                          //   ),
                          //   padding: const EdgeInsets.symmetric(
                          //     vertical: 10,
                          //     horizontal: 15,
                          //   ),
                          //   child: TextFormField(
                          //     controller: _loginPasswordController,
                          //     decoration: const InputDecoration.collapsed(
                          //       hintText: 'Escribe aquí...',
                          //     ),
                          //     buildCounter: (
                          //       context, {
                          //       required int currentLength,
                          //       required bool isFocused,
                          //       required int? maxLength,
                          //     }) =>
                          //         null,
                          //     style: const TextStyle(
                          //       color: Colors.black87,
                          //       fontSize: 16,
                          //     ),
                          //     textInputAction: TextInputAction.done,
                          //     obscureText: true,
                          //     validator: (password) {
                          //       final String? trimmedPassword = password?.trim();

                          //       if (trimmedPassword == null ||
                          //           trimmedPassword.isEmpty) {
                          //         return "Escribe algo";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_loginKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    await _manzanaresProvider.getUser(
                                      email: _loginEmailController.text.trim(),
                                    );
                                  } catch (err) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.transparent,
                                          insetPadding:
                                              const EdgeInsets.fromLTRB(
                                            20,
                                            0,
                                            20,
                                            0,
                                          ),
                                          alignment: Alignment.center,
                                          elevation: 25,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              top: 30.0,
                                              bottom: 20.0,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      err.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    CupertinoButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 25.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: const Text(
                                                          'Entendido',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                        child: Container(
                          width: 203,
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: Colors.black,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color:
                            //         const Color(0x00000000).withOpacity(0.25),
                            //     offset: const Offset(0, 4),
                            //     blurRadius: 4,
                            //   ),
                            // ],
                          ),
                          child: _isLoading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 10,
                                )
                              : const Text(
                                  "Iniciar Sesión",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      // const SizedBox(height: 45),
                      // const Text(
                      //   "¿Eres nuevo?",
                      //   style: TextStyle(
                      //     fontSize: 13,
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      // const SizedBox(height: 5),
                      // CupertinoButton(
                      //   padding: EdgeInsets.zero,
                      //   onPressed: () {
                      //     setState(() {
                      //       _login = false;
                      //     });
                      //   },
                      //   child: Container(
                      //     width: 171,
                      //     height: 38,
                      //     alignment: Alignment.center,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(14.0),
                      //       color: Colors.grey.shade200,
                      //       // border: Border.all(
                      //       //   color: Colors.black,
                      //       //   strokeAlign: BorderSide.strokeAlignInside,
                      //       //   style: BorderStyle.solid,
                      //       //   width: 3.0,
                      //       // ),
                      //     ),
                      //     child: const Text(
                      //       "Crear Cuenta",
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         color: Colors.black,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 50),
                    ],
                  ),
                );
              }),
        ),
      ),
      // : Form(
      //     key: _signUpKey,
      //     child: Center(
      //       child: SingleChildScrollView(
      //         padding: const EdgeInsets.symmetric(horizontal: 25),
      //         child: Column(
      //           children: [
      //             const SizedBox(height: 120),
      //             Assets.imgs.logo.image(width: 130),
      //             const SizedBox(height: 50),
      //             const Text(
      //               "¡Bienvenido!",
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 color: Colors.black,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
      //             const SizedBox(height: 20),
      //             Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const Text(
      //                   'Nombre(s)',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 const Text(
      //                   'Apellido(s)',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 const Text(
      //                   'Correo Electrónico',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 10),
      //                 Container(
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(13),
      //                     color: const Color.fromARGB(255, 239, 239, 239),
      //                   ),
      //                   padding: const EdgeInsets.symmetric(
      //                     vertical: 10,
      //                     horizontal: 15,
      //                   ),
      //                   child: TextFormField(
      //                     controller: _signUpEmailController,
      //                     decoration: const InputDecoration.collapsed(
      //                       hintText: 'Escribe aquí...',
      //                     ),
      //                     buildCounter: (
      //                       context, {
      //                       required int currentLength,
      //                       required bool isFocused,
      //                       required int? maxLength,
      //                     }) =>
      //                         null,
      //                     style: const TextStyle(
      //                       color: Colors.black87,
      //                       fontSize: 16,
      //                     ),
      //                     textInputAction: TextInputAction.next,
      //                     keyboardType: TextInputType.emailAddress,
      //                     validator: (email) {
      //                       final String? trimmedEmail = email?.trim();

      //                       if (trimmedEmail == null ||
      //                           trimmedEmail.isEmpty) {
      //                         return "Escribe algo";
      //                       }

      //                       print(trimmedEmail);

      //                       if (!EmailValidator.validate(
      //                           trimmedEmail.trim())) {
      //                         return "Correo inválido";
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 const Text(
      //                   'Contraseña',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 10),
      //                 Container(
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(13),
      //                     color: const Color.fromARGB(255, 239, 239, 239),
      //                   ),
      //                   padding: const EdgeInsets.symmetric(
      //                     vertical: 10,
      //                     horizontal: 15,
      //                   ),
      //                   child: TextFormField(
      //                     controller: _signUpPasswordController,
      //                     decoration: const InputDecoration.collapsed(
      //                       hintText: 'Escribe aquí...',
      //                     ),
      //                     buildCounter: (
      //                       context, {
      //                       required int currentLength,
      //                       required bool isFocused,
      //                       required int? maxLength,
      //                     }) =>
      //                         null,
      //                     style: const TextStyle(
      //                       color: Colors.black87,
      //                       fontSize: 16,
      //                     ),
      //                     textInputAction: TextInputAction.next,
      //                     obscureText: true,
      //                     validator: (password) {
      //                       final String? trimmedPassword =
      //                           password?.trim();

      //                       if (trimmedPassword == null ||
      //                           trimmedPassword.isEmpty) {
      //                         return "Escribe algo";
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 const Text(
      //                   'Confirma tu contraseña',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 10),
      //                 Container(
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(13),
      //                     color: const Color.fromARGB(255, 239, 239, 239),
      //                   ),
      //                   padding: const EdgeInsets.symmetric(
      //                     vertical: 10,
      //                     horizontal: 15,
      //                   ),
      //                   child: TextFormField(
      //                     controller: _signUpConfirmPasswordController,
      //                     decoration: const InputDecoration.collapsed(
      //                       hintText: 'Escribe aquí...',
      //                     ),
      //                     buildCounter: (
      //                       context, {
      //                       required int currentLength,
      //                       required bool isFocused,
      //                       required int? maxLength,
      //                     }) =>
      //                         null,
      //                     style: const TextStyle(
      //                       color: Colors.black87,
      //                       fontSize: 16,
      //                     ),
      //                     textInputAction: TextInputAction.done,
      //                     obscureText: true,
      //                     validator: (confirmedPassword) {
      //                       final String? trimmedConfPassword =
      //                           confirmedPassword?.trim();

      //                       if (trimmedConfPassword == null ||
      //                           trimmedConfPassword.isEmpty) {
      //                         return "Escribe algo";
      //                       } else if (trimmedConfPassword !=
      //                           _signUpPasswordController.text.trim()) {
      //                         return "Las contraseñas no coinciden";
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 30),
      //             CupertinoButton(
      //               padding: EdgeInsets.zero,
      //               onPressed: _isLoading
      //                   ? null
      //                   : () async {
      //                       if (_signUpKey.currentState!.validate()) {
      //                         setState(() {
      //                           _isLoading = true;
      //                         });
      //                         try {
      //                           await _authMethods.signUpWithEmail(
      //                             email: _signUpEmailController.text.trim(),
      //                             password:
      //                                 _signUpPasswordController.text.trim(),
      //                           );
      //                         } catch (err) {
      //                           setState(() {
      //                             _isLoading = false;
      //                           });
      //                           showCupertinoDialog(
      //                             context: context,
      //                             builder: (ctx) {
      //                               return Dialog(
      //                                 shape: RoundedRectangleBorder(
      //                                   borderRadius:
      //                                       BorderRadius.circular(16.0),
      //                                 ),
      //                                 backgroundColor: Colors.white,
      //                                 surfaceTintColor: Colors.transparent,
      //                                 insetPadding:
      //                                     const EdgeInsets.fromLTRB(
      //                                   20.0,
      //                                   80.0,
      //                                   20.0,
      //                                   10.0,
      //                                 ),
      //                                 alignment: Alignment.center,
      //                                 elevation: 25,
      //                                 child: Padding(
      //                                   padding: const EdgeInsets.all(22.0),
      //                                   child: SingleChildScrollView(
      //                                     child: Container(
      //                                       color: Colors.white,
      //                                       alignment: Alignment.center,
      //                                       child: Column(
      //                                         mainAxisSize:
      //                                             MainAxisSize.min,
      //                                         children: [
      //                                           Text(
      //                                             err.toString(),
      //                                             style: const TextStyle(
      //                                               color: Colors.black,
      //                                               fontSize: 15,
      //                                             ),
      //                                           ),
      //                                           CupertinoButton(
      //                                             child: const Text(
      //                                               'Entendido',
      //                                               style: TextStyle(
      //                                                 color: Colors.black,
      //                                                 fontSize: 15,
      //                                                 fontWeight:
      //                                                     FontWeight.bold,
      //                                               ),
      //                                             ),
      //                                             onPressed: () {
      //                                               Navigator.of(ctx).pop();
      //                                             },
      //                                           )
      //                                         ],
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ),
      //                               );
      //                             },
      //                           );
      //                         }
      //                       }
      //                     },
      //               child: Container(
      //                 width: 203,
      //                 height: 46,
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(14.0),
      //                   color: Colors.black,
      //                   // boxShadow: [
      //                   //   BoxShadow(
      //                   //     color: const Color(0x00000000).withOpacity(
      //                   //       0.25,
      //                   //     ),
      //                   //     offset: const Offset(0, 4),
      //                   //     blurRadius: 4,
      //                   //   ),
      //                   // ],
      //                 ),
      //                 child: _isLoading
      //                     ? const CupertinoActivityIndicator(
      //                         color: Colors.white,
      //                         radius: 10,
      //                       )
      //                     : const Text(
      //                         "Crear Cuenta",
      //                         style: TextStyle(
      //                           fontSize: 15,
      //                           color: Colors.white,
      //                           fontWeight: FontWeight.w600,
      //                         ),
      //                       ),
      //               ),
      //             ),
      //             const SizedBox(height: 45),
      //             const Text(
      //               "¿Ya tienes cuenta?",
      //               style: TextStyle(
      //                 fontSize: 13,
      //                 color: Colors.black,
      //                 fontWeight: FontWeight.w400,
      //               ),
      //             ),
      //             const SizedBox(height: 5),
      //             CupertinoButton(
      //               padding: EdgeInsets.zero,
      //               onPressed: () {
      //                 setState(() {
      //                   _login = true;
      //                 });
      //               },
      //               child: Container(
      //                 width: 171,
      //                 height: 38,
      //                 alignment: Alignment.center,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(14.0),
      //                   // color: Colors.white,
      //                   // border: Border.all(
      //                   //   color: Colors.black,
      //                   //   strokeAlign: BorderSide.strokeAlignInside,
      //                   //   style: BorderStyle.solid,
      //                   //   width: 3.0,
      //                   // ),
      //                   color: Colors.grey.shade200,
      //                 ),
      //                 child: const Text(
      //                   "Iniciar Sesión",
      //                   style: TextStyle(
      //                     fontSize: 14,
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(height: 50),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
    );
  }
}
