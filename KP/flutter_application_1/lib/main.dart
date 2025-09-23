import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(AppStore());
} //end main

class AppStore extends StatefulWidget {
  const AppStore({super.key});

  @override
  //Codigo
  State<AppStore> createState() => _AppStoreState();
}

class _AppStoreState extends State<AppStore> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Muebles cauca",
      home: Scaffold(
        appBar: AppBar(
          title: Text("calidad a su servicio"),
          backgroundColor: const Color.fromARGB(255, 139, 12, 54),
          foregroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Image.network(
                "https://i.pinimg.com/736x/b2/b5/75/b2b5754857a97b15391846dcffa8b6d5.jpg",
                width: 100,
                height: 100,
              ),
              ListTile(
                title: Text("Home"),
                subtitle: Text("portal persona"),
                trailing: Icon(Icons.arrow_circle_right),
                leading: Icon(Icons.home),
                onTap: () {
                  print("presiono la opcion 1");
                },
              ),
              ListTile(
                title: Text("Mueble oficina"),
                subtitle: Text("muebles"),
                trailing: Icon(Icons.arrow_circle_right),
                leading: Icon(Icons.chair),
                onTap: () {
                  print("presione la opcion 2");
                },
              ),
              ListTile(
                title: Text("Mueble casa"),
                subtitle: Text("muebles"),
                trailing: Icon(Icons.arrow_circle_right),
                leading: Icon(Icons.bed),
                onTap: () {
                  print("presione la opcion 3");
                },
              ),
              ListTile(
                title: Text("Estructuras"),
                subtitle: Text("modelos"),
                trailing: Icon(Icons.arrow_circle_right),
                leading: Icon(Icons.architecture),
                onTap: () {
                  print("presione la opcion 4");
                },
              ),
              ListTile(
                title: Text("Pedidos"),
                subtitle: Text("pedidos"),
                trailing: Icon(Icons.arrow_circle_right),
                leading: Icon(Icons.add_box),
                onTap: () {
                  print("presione la opcion 5");
                },
              ),
              ListTile(
                trailing: Icon(Icons.add_circle),
                onTap: () {
                  print("presione la opcion 6");
                },
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(width: 700, height: 60, child: Text("home")),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(
                  width: 700,
                  height: 60,
                  child: Text("Estructura"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(width: 700, height: 60, child: Text("home")),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(
                  width: 700,
                  height: 60,
                  child: Text("Estructura"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(width: 700, height: 60, child: Text("home")),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(
                  width: 700,
                  height: 60,
                  child: Text("Estructura"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(width: 700, height: 60, child: Text("home")),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(
                  width: 700,
                  height: 60,
                  child: Text("Estructura"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(width: 700, height: 60, child: Text("home")),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(
                  width: 700,
                  height: 60,
                  child: Text("Estructura"),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(width: 700, height: 60, child: Text("home")), 
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  print("Ejecuto el codigo del card");
                },
                child: SizedBox(
                  width: 700,
                  height: 60,
                  child: Text("Estructura"),
                ),
              ),
            ),
           
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Agregar una nueva categoría");
          },
          child: Icon(Icons.add_rounded), 
        ),
        bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
        BottomNavigationBarItem(icon: Icon(Icons.phone_android), label: "llamar"),
        BottomNavigationBarItem(icon: Icon(Icons.face_3), label: "contactos"),
        ]),
      ),
    );
  }
}