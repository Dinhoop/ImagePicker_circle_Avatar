import 'dart:io';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
      MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? arquivoFoto;
  double tamanhoFoto = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Picker")),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(""),
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                      image: arquivoFoto == null ?
                        AssetImage("assets/person.png") :
                        FileImage(io.File(arquivoFoto!.path)) as ImageProvider // ou FileImage(arquivo)
                  ),
                ),
                width: 200,
                height: 200,

              ),
              CircleAvatar(
                maxRadius: 150,
                backgroundImage: arquivoFoto == null ? AssetImage("assets/person.png") : FileImage(arquivoFoto!) as ImageProvider,//arquivoFoto ==null ? AssetImage("assets/person.png") : AssetImage("assets/person.png"),
                //child: Image.file(arquivoFoto!)
                  child: Center(child:
                  Text("A", style: TextStyle(fontSize: 200),))//arquivoFoto ==null ? Image.asset("assets/person.png"):Image.file(arquivoFoto!)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        ImagePicker().pickImage(source: ImageSource.camera).then((arquivo){
                          if(arquivo==null) {
                            return;
                          } else{
                            print("\n\n\nFotografia tirada com sucesso\n\n\n");
                            File file = File(arquivo.path);
                            setState(() {
                              arquivoFoto = file;
                              print("PATHHH => ${arquivo.path}");
                              file.length().then((value){
                                tamanhoFoto = value/1024.0;
                              });
                            });
                            print("");
                            // file.delete();
                            file.exists().then((value){
                              if (value) {
                                print("Arquivo existe");
                              } else
                                print("Arquivo não existe");
                            }) ;

                          }

                        });

                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          Text("Tirar Foto"),
                        ],
                      )
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: (){
                        File file = File(arquivoFoto!.path);
                        file.exists().then((value){
                          if (value)
                          {
                            print("Arquivo existe");
                            file.length().then((value) => print("Arquivo tem $value Kb"));
                            ;
                          }
                          else
                            print("Arquivo não existe");
                        }) ;
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          Text("Ver tamanho da foto"),
                        ],
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Tamanho da foto:"),
                tamanhoFoto == 0.0 ? Text("--") : Text("${(tamanhoFoto/1024).toStringAsFixed(2)} Mb")
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
