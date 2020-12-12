import 'package:artcraftliving/Model/model.dart';
import 'package:artcraftliving/constant.dart';
import 'package:artcraftliving/home_screen.dart';
import 'package:artcraftliving/profiles/my_gallery.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';

class UploadArt extends StatefulWidget {
  @override
  _UploadArtState createState() => _UploadArtState();
}

class _UploadArtState extends State<UploadArt> {
  //multi image picker
  List<Asset> images = List<Asset>();
  List imagesDisplay = [];
  bool firstTime = true;
  List<String> imageUrls = <String>[];
  bool upoadingLoading = false;
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  TextEditingController tittleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController techniqueController = TextEditingController();
  TextEditingController yearContoller = TextEditingController();
  TextEditingController aboutartContoller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Art Craft Living",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
      if (resultList.isNotEmpty) firstTime = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Upload Artwork',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: ListView(
          children: [
            SizedBox(height: 30),
            //Center(child: Text('Error: $_error')),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      child: firstTime
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 5))
                                  ]),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.art_track_sharp,
                                color: Colors.blue,
                                size: 40,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, top: 6),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Carousel(
                                    overlayShadow: false,
                                    dotBgColor: Colors.transparent,
                                    autoplay: false,
                                    dotIncreaseSize: 3,
                                    dotSize: 5,
                                    // dotSpacing: 30,

                                    dotIncreasedColor: Colors.white,
                                    dotColor: Colors.black,
                                    images: [
                                      for (int i = 0; i < images.length; i++)
                                        AssetThumb(
                                          asset: images[i],
                                          width: 300,
                                          height: 300,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    onTap: loadAssets,
                  ),
                  //SizedBox(height: 30),
                  //buildGridView(),
                  SizedBox(height: 30),
                  _input('Title *', tittleController),
                  _input('Price *', priceController),
                  _input('Size *', sizeController),
                  _input('Technique *', techniqueController),
                  _input('Year *', yearContoller),
                  _input('About Art ', aboutartContoller),
                  SizedBox(height: 20),
                  Container(
                    child: upoadingLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            padding: EdgeInsets.fromLTRB(80, 2, 80, 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text(
                              'Upload',
                              style: TextStyle(fontSize: 17),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                uploadArt();
                              }
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => AfterSignup()));
                            },
                          ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadArt() async {
    setState(() {
      upoadingLoading = true;
    });

    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) async {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          await Firebase.initializeApp();
          await FirebaseFirestore.instance.collection("ArtWork").add({
            'tittle': tittleController.text,
            'size': sizeController.text,
            'technique': techniqueController.text,
            'year': yearContoller.text,
            'aboutArt': aboutartContoller.text,
            'userUid': userDetails.userUid,
            'userDocid': userDetails.userDocid,
            'price': priceController.text,
            'sold': false,
            'imageUrls': imageUrls,
            'buyerdocId': '',
            'buyerUid': ' '
          });
          print(3);
          if (!firstTimeForartWork) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyGallery()),
            );
          }
          if (firstTimeForartWork)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          print(4);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }
}

Widget _input(String label, controller) {
  return Container(
    //height: 60,
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black)),
    ),
    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: TextFormField(
      controller: controller,
      validator: (String val) {
        if (val.trim().isEmpty) {
          if (label == 'About Art ') {
            controller.text = '';
            return null;
          }
          return label + " must not be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        //prefixIcon: Icon(icon, color: Colors.blue,),
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        border: InputBorder.none,
        labelText: label,
      ),
    ),
  );
}
