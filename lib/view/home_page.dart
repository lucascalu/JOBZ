import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home';

  @override
  Widget build(BuildContext context) {

        





    var snapshots = Firestore.instance
        .collection('todo')
        .where('excluido', isEqualTo: false)
        .orderBy('data')
        .snapshots();

    return Scaffold(

     
 
     appBar: AppBar(
        title: Text('JOBZ HOME'),
      ),
     

      backgroundColor: Colors.grey[200],

          
          drawer: Container(
          color: Colors.green,
          
          //editar aqui nomes e rotas
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text("adm@mail.com"),
              accountName: Text("Adinistrador"),
              currentAccountPicture: CircleAvatar(
                child: Text("ADM"),
              ),

            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Login"),
              onTap: () {
               Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondRoute()),
  );

                //Navegar para outra página
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Cadastro"),
              onTap: () {
                Navigator.push(
    context,


    MaterialPageRoute(builder: (context) => ThirdRoute()),
  );
                //Navegar para outra página

              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
              onTap: () {
                Navigator.pop(context);


                //Navegar para outra página
              },
            ),
          ],
        ),

        



          
          ),


      body: StreamBuilder(
        stream: snapshots,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.documents.length == 0) {
            return Center(child: Text('Nenhuma jobz ainda'));
          }

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int i) {
              var doc = snapshot.data.documents[i];
              var item = doc.data;

              // print('todo/${doc.reference.documentID}');

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  isThreeLine: true,
                  leading: IconButton(
                    icon: Icon(
                      item['favorito']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 32,
                    ),
                    onPressed: () => doc.reference.updateData({
                      'favorito': !item['favorito'],
                    }),
                  ),
                  title: Text(item['titulo']),
                   
                  subtitle: Text(item['descricao']),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red[300],
                    foregroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => doc.reference.updateData({
                        'excluido': true,
                      }),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),









      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreate(context),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.add),
      ),
    );
  }

  modalCreate(BuildContext context) {
    var form = GlobalKey<FormState>();

    var titulo = TextEditingController();
    var descricao = TextEditingController();
    var resumo = TextEditingController();


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastrar novo serviço'),
          content: Form(
            key: form,
            child: Container(
              //height: MediaQuery.of(context).size.height / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Título'),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex.: Manutenção Predial',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: titulo,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Este campo não pode ser vazio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  Text('Descrição'),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '(Opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: descricao,
                  ),




Text('Resumo'),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '(Opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: resumo,
                  ),








                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            FlatButton(
              onPressed: () async {
                if (form.currentState.validate()) {
                  await Firestore.instance.collection('todo').add({
                    'titulo': titulo.text,
                    'descricao': descricao.text,
                    'resumo' : resumo.text,
                    'favorito': false,
                    'data': Timestamp.now(),
                    'excluido': false,
                  });

                  Navigator.of(context).pop();
                }
              },
              color: Colors.green,
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}




//login page



class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
           backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white, fontSize: 30),
                decoration: InputDecoration(
                  labelText:"Telefone do usuário",
                  labelStyle: TextStyle(color: Colors.black),
                )
           ),  //TextField
              TextField(
                autofocus: true,
                obscureText: true,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white, fontSize: 30),
                decoration: InputDecoration(
                  labelText:"Senha do usuário",
                  labelStyle: TextStyle(color: Colors.black),
                )
              ),
              
              
              
               Container(
              height: 70,
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                child: Text(
                  "Login",
                  textAlign: TextAlign.right,
                ),
                onPressed: () {

                     Navigator.pop(context);

                },
              ),
            ),




            Container(
              height: 70,
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                child: Text(
                  "Registrar",
                  textAlign: TextAlign.right,
                ),
                onPressed: () {

                     Navigator.pop(context);

                },
              ),
            ),




            Container(
              height: 70,
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                child: Text(
                  "Esqueci minha senha",
                  textAlign: TextAlign.right,
                ),
                onPressed: () {

                     Navigator.pop(context);

                },
              ),
            ),


              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              //TextField
            ],
         ),
        ),
      )     
    );
  }
}




//tela de cadastro

class ThirdRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CADASTRO NOVO PERFIL'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
            autofocus: true,
            // alignment: Alignment(-77, 0),
          ),
          new IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
            autofocus: true,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CPF/CNPJ",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Repetir Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 70,
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                child: Text(
                  "Registrar",
                  textAlign: TextAlign.right,
                ),
                onPressed: () {


                         Navigator.pop(context);


                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
