//
//  DetalhesViewController.swift
//  SnapChat
//
//  Created by Ivaszek on 25/01/23.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesViewController: UIViewController {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var snap = Snap()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detalhes.text = "Carregando..."
        
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { imagem, erro, cache, url in
            
            if erro == nil{
                
                self.detalhes.text = self.snap.descricao
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    
                    //decrementar o timer
                    self.tempo = self.tempo - 1
                    
                    //exibir na tela
                    self.contador.text = String(self.tempo)
                    
                    //parar o timer
                    if self.tempo == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true)
                    }
                    
                }
                
            }
            
        }
        
    }
    //esse método é chamado sempre que a view é fechada
    override func viewWillDisappear(_ animated: Bool) {
        
        let autenticaco = Auth.auth()
        
        if let idUsuarioLogado = autenticaco.currentUser?.uid{
            
            //remove o nó do banco de dados
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            //remover a imagem do snap
            
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child( "\(snap.idImagem).jpg" ).delete { erro in
                if erro == nil {
                    print("Sucesso ao excluir")
                    
                }else{
                    print("Erro ao excluir")
                }
                
            }
            
        }

    }

}
