//
//  UsuariosTableViewController.swift
//  SnapChat
//
//  Created by Ivaszek on 23/01/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    var usuarios: [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataBase = Database.database().reference()
        let usuarios = dataBase.child("usuarios")
        
        //adiciona evento novo usuario adicionado
        usuarios.observe(DataEventType.childAdded, with: { (snapshot) in
            
            let dados = snapshot.value as? NSDictionary
            
            //recupera dados usuário logado
            let autenticacao = Auth.auth()
            let idUsuarioLogado = autenticacao.currentUser?.uid
            
            //Recuperar os dados
            let emailUsuario = dados!["email"] as! String
            let nomeUsuario = dados!["nome"] as! String
            let idUsuario =  snapshot.key
            
            let usuario = Usuario(email: emailUsuario, nome: nomeUsuario, uid: idUsuario)
            
            //adiciona usuario no array
            if idUsuario != idUsuarioLogado{
            self.usuarios.append( usuario )
            self.tableView.reloadData()
            
            }
        })
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usuarios.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        //configurar a celula
        let usuario = self.usuarios[indexPath.row]
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = usuario.email
        
        return celula
    }
    
    //aqui recuperamos o indexpath da linha que foi selecionada(na hora de selecionar pra quem enviar o snap)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usuarioSelecionado = self.usuarios[indexPath.row]
        let idUsuarioSelecionado = usuarioSelecionado.uid
        
        //recupera referencias do banco de dados
        let dataBase = Database.database().reference()
        let usuarios = dataBase.child("usuarios")
        
        //recuperar dados do usuario logado
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            
            let usuarioLogado = usuarios.child(idUsuarioLogado)
            usuarioLogado.observeSingleEvent(of: DataEventType.value) { snapshot in
                
                let dados = snapshot.value as? NSDictionary
                
                let snap = [
                    "de" : dados?["email"] as! String,
                    "nome" : dados?["nome"] as! String,
                    "descricao": self.descricao,
                    "urlImagem": self.urlImagem,
                    "idImagem": self.idImagem
                    
                    
                ]
                
                //agora criamos o nó snap
                let snaps = usuarios.child(idUsuarioSelecionado).child("snaps")
                
                //agora dentro dos snaps criamos nós de identificador unico pra nao sobrescrever
                snaps.childByAutoId().setValue(snap)
                
                //aqui direcionamos pra tela inicial após clicar na pessoa que quer enviar o snap
                self.performSegue(withIdentifier: "voltarTelaSnap", sender: nil)
                
            }
            
        }

    }
    
}
