//
//  SnapsViewController.swift
//  SnapChat
//
//  Created by Ivaszek on 12/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snap] = []
    
    @IBAction func botaoSair(_ sender: Any) {
        
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
            self.performSegue(withIdentifier: "segueSair", sender: nil)
        } catch  {
        }//Fim de deslogar usuário
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //recuperar id do usuario logado
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            
            //acessar os nós do banco de dados
            let dataBase = Database.database().reference()
            let usuarios = dataBase.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            //criar ouvinte para os snaps
            snaps.observe(DataEventType.childAdded) { snapshot in
                
                //converter snaps em um dicionário
                let dados = snapshot.value as? NSDictionary
                
                let snap = Snap()
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao = dados?["descricao"] as! String
                snap.urlImagem = dados?["urlImagem"] as! String
                snap.idImagem = dados?["idImagem"] as! String
                
                //agora adicionamos dentro do nosso array de snaps
                self.snaps.append( snap )
                self.tableView.reloadData()
                
            }
            
            //adiciona evento para o item removido
            
            snaps.observe(DataEventType.childRemoved, with: { (snapshot) in
                
                var indice = 0
                for snap in self.snaps {
                    if snap.identificador == snapshot.key {
                        self.snaps.remove(at: indice)
                    }
                    indice = indice + 1
                }
                self.tableView.reloadData()
                
            })
            
            
        }
        self.tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            return 1
        }else{
        return totalSnaps
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            celula.textLabel?.text = "Nenhum Snap para você :)"
        }else{
            
            let snap = self.snaps[indexPath.row]
            celula.textLabel?.text = snap.nome
        }
            
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snap)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detalhesSnapSegue"{
            
            let detalhesSnapViewController = segue.destination as! DetalhesViewController
            
            detalhesSnapViewController.snap = sender as! Snap
            
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
