//
//  ViewController.swift
//  SnapChat
//
//  Created by Ivaszek on 01/11/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Verificar se o usuário já está autenticado e logar automaticamente
        
        let autenticacao = Auth.auth()
        
        autenticacao.addStateDidChangeListener { autenticacao, usuario in
            
            if usuario != nil {
                
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }


}

