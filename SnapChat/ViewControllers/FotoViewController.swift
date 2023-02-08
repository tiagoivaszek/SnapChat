//
//  FotoViewController.swift
//  SnapChat
//
//  Created by Ivaszek on 12/01/23.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagem: UIImageView!
    
    @IBOutlet weak var descricao: UITextField!
    
    @IBOutlet weak var botaoProximo: UIButton!
    
    //gerar nome de imagem randomico
    var idImagem = NSUUID().uuidString
    
    @IBAction func proximoPasso(_ sender: Any) {
        
        //aqui desabilitamos o botao assim que ele for pressionado
        self.botaoProximo.isEnabled = false
        //aqui mudamos o que stá escrito no botao
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        
        //agora acessamos o firebase
        let armazenamento = Storage.storage().reference()
        
        //agora criamos um pasta no fire base com o nome imagens
        let imagens = armazenamento.child("imagens")
        
        //agora recuperamos a imagem
        if let imagemSelecionada = imagem.image {
            
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.5){
                
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil, completion: { (metaDados, erro) in
                    
                    if erro == nil {
                        print("Sucesso no upload")
                            
                            _ = Storage.storage().reference()
                            
                            let refImagem = imagens.child("\(self.idImagem).jpg")
                            
                            refImagem.downloadURL { url, erro in
                                if erro == nil {
                                    let urlRecuperada = url!.absoluteString
                                    self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: urlRecuperada )
                                }else{
                                    print("erro")
                                }
                            }
                        
                        //aqui desabilitamos o botao assim que ele for pressionado
                        self.botaoProximo.isEnabled = true
                        //aqui mudamos o que stá escrito no botao
                        self.botaoProximo.setTitle("Próximo", for: .normal)
                        
                    }else{
                        
                        let alerta = Alerta(titulo: "Upload Falhou", mensagem: "Erro ao salvar o arquivo, tente novamente")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                    
                })
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue"{
            
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
            
        }
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        
        //esse present chama pra abrir o savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imagem.image = imagemRecuperada
        
        //habilitar o botão próximo
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
        //esse é pra fechar a tela da foto
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //Esse image picker permite tirar foto ou buscar
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        func exibirMensagem(titulo: String, mensagem: String){
            
            let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alerta.addAction(acaoCancelar)
            present(alerta, animated: true, completion: nil)
        }
        
        imagePicker.delegate = self
        
        //Desabilitar o botão próximo
        botaoProximo.isEnabled = false
        botaoProximo.backgroundColor = UIColor.gray
        
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
