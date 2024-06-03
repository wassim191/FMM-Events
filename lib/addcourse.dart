import 'dart:io';
import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medcine/.env';
import 'package:medcine/course.dart';
import 'package:medcine/locales/strings.dart';

import 'Add_equipement.dart';

class Formater_screen extends StatefulWidget {
  final String email;
  final DateTime date;
  final TimeOfDay starttime;
  final TimeOfDay endtime;

  Formater_screen({
    super.key,
    required this.email,
    required this.date,
    required this.starttime,
    required this.endtime,
  });

  final cloudinary = CloudinaryPublic("dtcaflgkn", "ngts3mup");

  @override
  State<Formater_screen> createState() => _Formater_screenState();
}

class _Formater_screenState extends State<Formater_screen> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = "Essentials";
  final ProfEditingController = TextEditingController();
  final DescriptionEditingController = TextEditingController();
  final PriceEditingController = TextEditingController();
  final QuantityEditingController = TextEditingController();
  List<File> images = [];

  Future<List<File>> pickImages() async {
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (files != null && files.files.isNotEmpty) {
        List<File> selectedImages = [];
        for (int i = 0; i < files.files.length; i++) {
          selectedImages.add(File(files.files[i].path!));
        }
        return selectedImages;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  Future<void> save() async {
    try {
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await widget.cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path),
        );
        imageUrls.add(res.secureUrl);
        print(images[i]);
        print(imageUrls[i]);
      }
      print(images.map((file) => file.path).toList());

      var res = await http.post(
        Uri.parse("http://$ip:3002/addcourse"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Prof': ProfEditingController.text,
          'description': DescriptionEditingController.text,
          'price': double.parse(PriceEditingController.text),
          'quantity': double.parse(QuantityEditingController.text),
          'category': selectedCategory,
          'images': imageUrls,
        }),
      );

      print(res.body);

      ProfEditingController.clear();
      DescriptionEditingController.clear();
      PriceEditingController.clear();
      QuantityEditingController.clear();
      setState(() {
        selectedCategory = "Essentials";
        images.clear();
      });

      if (res.statusCode == 200) {
        print("Course saved successfully!");
      } else {
        print("Failed to save course. Status code: ${res.statusCode}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Coursee course = Coursee('', '', 0, '', 0, '', 0, DateTime.now(),
      TimeOfDay.now(), TimeOfDay.now());
  final telEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Prof = TextFormField(
        autofocus: false,
        controller: ProfEditingController,
        onChanged: (value) {
          course.Prof = value;
        },
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Prof Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          ProfEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: AppLocalizations.translate(context, 'prof_name'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final Description = TextFormField(
        autofocus: false,
        controller: DescriptionEditingController,
        onChanged: (value) {
          course.description = value;
        },
        keyboardType: TextInputType.name,
        maxLines: 5,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Description cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          DescriptionEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: AppLocalizations.translate(context, 'description'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final Price = SizedBox(
      width: 150,
      child: TextFormField(
          autofocus: false,
          controller: PriceEditingController,
          onChanged: (value) {
            try {
              double parsedValue = double.parse(value);
              setState(() {
                course.price = parsedValue;
              });
            } catch (e) {
              print(e.toString());
            }
          },
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Price cannot be Empty");
            }
            double price = double.tryParse(value)!;
            if (price < 0 || price > 1000) {
              return "price must be between 0 and 1000 ";
            }
            return null;
          },
          onSaved: (value) {
            PriceEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: AppLocalizations.translate(context, 'price'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )),
    );
    final Quantity = TextFormField(
        autofocus: false,
        controller: QuantityEditingController,
        onChanged: (value) {
          try {
            double parseValue = double.parse(value);
            setState(() {
              course.price = parseValue;
            });
          } catch (e) {
            print(e.toString());
          }
        },
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Quantity cannot be Empty");
          }
          double quantity = double.tryParse(value)!;
          if (quantity < 10 || quantity > 180) {
            return "Quantity must be between 30 and 180 ";
          }
          return null;
        },
        onSaved: (value) {
          QuantityEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: AppLocalizations.translate(context, 'quantity'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final Categoryselect = DropdownButton<String>(
      value: selectedCategory,
      items: ["Essentials", "Mobile", "DataScience", "UI/UX", "Anatomy"]
          .map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value ?? "";
        });
        course.category = selectedCategory;
      },
      underline: Container(
        height: 0,
      ),
      hint: const Text("Select "),
      isDense: true,
    );
    final RegisterButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xFF8B1111),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (_formKey.currentState != null &&
                _formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EquipmentSelectionPage(
                    profName: ProfEditingController.text,
                    phone: telEditingController.text,
                    description: DescriptionEditingController.text,
                    price: double.parse(PriceEditingController.text),
                    quantityy: double.parse(QuantityEditingController.text),
                    category: selectedCategory,
                    imageUrls: images.map((file) => file.path).toList(),
                    email: widget.email,
                    date: widget.date,
                    starttime: widget.starttime,
                    endtime: widget.endtime,
                  ),
                ),
              );
            } else {
              print('not ok');
            }
          },
          child: Text(
            AppLocalizations.translate(context, 'next'),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.translate(context, 'add_course'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8B1111),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.file(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10.0),
                          strokeWidth: 2,
                          dashPattern: const [10, 4],
                          color: Colors.black,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    AppLocalizations.translate(
                                        context, 'select_thumbnail'),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Prof,
                const SizedBox(
                  height: 10,
                ),
                Description,
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Price,
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "TND",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Quantity,
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Categoryselect,
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "+216",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 250,
                      child: TextFormField(
                        controller: telEditingController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          try {
                            double parsedValue = double.parse(value);
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.translate(
                              context, 'phonenumber'),
                          hintStyle: const TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                RegisterButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
