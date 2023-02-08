//
//  EntrarViewController.swift
//  SnapChat
//
//  Created by Ivaszek on 10/01/23.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
        
        //Recuperar dados digitados
        
        if let emailR = self.email.text{
            if let senhaR = self.senha.text{
                
                //Autenticar usuário no FireBase
                
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailR, password: senhaR) { usuario, erro in
                    
                    if erro == nil {
                        
                        if usuario == nil {
                            self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação, tente novamente.")
                        }else{
                            
                            //redireciona usuário pra tela principal
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            
                        }
                        
                    }else{
                        self.exibirMensagem(titulo: "Dados incorretos", mensagem: "Verifique os dados digitados e tente novamente.")
                    }
                    
                }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func exibirMensagem(titulo: String, mensagem: String){
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
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
